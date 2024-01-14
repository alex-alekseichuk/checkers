Uses Dos,CRT,Graph,Mouse;

Function Sign(x:Integer):ShortInt;
begin Sign:=0;  if x>0 then Sign:=1;  if x<0 then Sign:=-1  end;


Const
      Black=True; White=False;

      ResolX=40;ResolY=40;
      x0=30;y0=30;
      ColW=7;
      ColB=8;
      DMes=10;
      MesLen:Word=0;
      BGS=8;
      BGC=9;


Type ChessType = (Empty,Fuck,Queen);   {Тип Ячейки поля}
     TChess = record
       t:ChessType;  {Тип фигуры}
       c:Boolean;    {Цвет фигуры}
     end;

Var a:Array[1..8,1..8] of TChess;  {Матрица Поля}


{$I rects.inc}
{$I figs.inc}

{Рисует Фигуру на доске ==================================================}
Procedure DrawFig(x,y:Byte);
Var xx,yy:Word;
begin
xx:=x0+(x-1)*ResolX;yy:=y0+(y-1)*Resoly;
      if (x+y) mod 2 = 0 then DrawEmpty(xx,yy,ColW)
                         else DrawEmpty(xx,yy,ColB);

    if a[y,x].t=Fuck then begin
      case a[y,x].c of
        Black : DrawBlack(xx,yy);
        White : DrawWhite(xx,yy);
      end;
    end;

    if a[y,x].t=Queen then begin
      case a[y,x].c of
        Black : DrawBlackQueen(xx,yy);
        White : DrawWhiteQueen(xx,yy);
      end;
    end;

end;

{ Рисуем все поле с прибамбасами =========================================}
Procedure DrawField;
Var x,y:Word; i,j:Byte; s:string[3];
Const ss='abcdefgh';
begin y:=y0;
DrawBar(x0-17,y0-17,x0+17+8*REsolX,y0+17+8*ResolY,7);
for i:=1 to 8 do begin
  x:=x0;
  for j:=1 to 8 do  begin
      if (i+j) mod 2 = 0 then DrawEmpty(x,y,ColW)
                         else DrawEmpty(x,y,ColB);
    if(a[i,j].t=Fuck) then begin
      case a[i,j].c of
        Black : DrawBlack(x,y);
        White : DrawWhite(x,y);
      end;
    end;

    if(a[i,j].t=Queen) then begin
      case a[i,j].c of
        Black : DrawBlackQueen(x,y);
        White : DrawWhiteQueen(x,y);
      end;
    end;
    x:=x+ResolX;
  end;
  y:=y+ResolY;
end;

DrawRect(x0-1,y0-1,x0+8*ResolX,y0+8*ResolY,FALSE);

setcolor(14); x:=x0+(ResolX div 2)-4;;y:=y0+(ResolY div 2)-4;
for i:=1 to 8 do begin
  str(i,s);
  outtextxy(x0-12,y,s);outtextxy(x0+8*ResolX+6,y,s);
  outtextxy(x,y0-12,Copy(ss,i,1));outtextxy(x,y0+8*Resoly+5,Copy(ss,i,1));
  x:=x+ResolX;y:=y+ResolY;
end;
end;


{ Рисуем Экран весь =====================================================}
Procedure DrawScreen;
Var i:Byte;
Begin setfillstyle(BGS,BGC);bar(0,0,getmaxx,getmaxy);
DrawBar(buts[1].x1-10,buts[1].y1-10,535,buts[nb].y2+10,7); DrawField;
for i:=1 to NB do ShowButt(buts[i],True);
End;

{------------------ POSы ------------------}
Type
     TPos=record
       x,y:Byte;
     end;

Const
      xc:Byte=1;yc:Byte=1;        {Тек.Коорд.}
      Nac:Byte=0;              {Кол-во курсоров}
      CurPl :Boolean=False;      {Тек. Игрок : White-False or Black-True}
      CurFig:ChessType=Fuck;      {Тек. Фигура }
      OldFig:ChessType=Fuck;
      ScwMode:Boolean=False;   {True - Шашака выбрана}
Var   ac:Array[1..12] of TPos;             {Массив курсоров}
      ds:Array[1..12] of TPos;             {Массив Убитых}

{=========================================================================
       Анализаторная часть
==========================================================================}
Function Dead(x,y:Byte):Boolean; {True - если здесь уже есть побитая враг}
Var i:Byte;
begin Dead:=False; if Nac<=1 then exit;
for i:=1 to Nac-1 do if (ds[i].x=x) and (ds[i].y=y) then Dead:=True;
end;

{ 0-13 - Кол-побитых ш. противника, 255-Ошибка }
Function Barrier(x1,y1,x2,y2:Byte;Var x,y:Byte):Byte;
Var dx,dy:Integer;b:Byte;
begin dx:=(x2-x1) div abs(x2-x1); dy:=(y2-y1) div abs(y2-y1);
x1:=x1+dx;y1:=y1+dy;     b:=0;
While x1<>x2 do begin
  if (a[y1,x1].c=CurPl)and(a[y1,x1].t<>Empty) then begin Barrier:=255;exit end
  else if a[y1,x1].t<>Empty then begin
    b:=b+1;if b=1 then begin x:=x1;y:=y1;end
  end;
  x1:=x1+dx;y1:=y1+dy;
end;Barrier:=b;
end;

{---------------------------------------------------------------------------}
Function EnterAnal:Byte; {0-NoThing 1-Mark 2-Xod 3-(Kill: Mark_More OR Kill) }
Var b,x,y:Byte;
begin EnterAnal:=0;
  if(Nac=0) then begin {Ничего не отмечено}
    if (CurPl=a[yc,xc].c) and (a[yc,xc].t<>Empty)
    then EnterAnal:=1;
    exit
  end; { 0 }

  {Проверка на то , что нах. на одной диагонали}
  if abs(xc-ac[Nac].x) <> abs(yc-ac[Nac].y) then exit;
  {Проверка на пуст. }
  if a[yc,xc].t<>Empty then exit;
  {Проверка на Фигню}
  if(xc=ac[Nac].x) or (yc=ac[Nac].y) then exit;

    b:=Barrier(xc,yc,ac[Nac].x,ac[Nac].y,x,y);
    if (b>1) then exit;
    if (b=0) and ((CurFig=Queen) or
                  ((yc-ac[Nac].y=1) and CurPl) or
                   ((yc-ac[Nac].y=-1) and (not CurPl))) and (Nac=1)
      then begin EnterAnal:=2;exit end;
    if ( (b=1) and
       ((CurFig=Queen) or (abs(xc-ac[Nac].x)=2)) and not Dead(x,y) )

      then begin EnterAnal:=3; ds[Nac].x:=x;ds[Nac].y:=y;exit end;
end;  {--- End of EntarAnal ---------------------------------}


Function Non_Idiot(x,y:Integer):Boolean; {True , если шашака в поле}
begin if (x>0) and (x<9) and (y>0) and (y<9) then Non_Idiot:=True
                                             else Non_Idiot:=False end;
{=========================================================================
  Проверка в позиции (XC,YC) c учетом CurFig
    если Full = True , то проверяет все напр-я , а
    если Full = False , то проверяет с учетом последней пометки
      (принцип - ОБРАТНО НЕ БЬЕТ и 2 РАЗА НЕ БЬЕТ)
  Return - True , если из (XC,YC) дальше можно еще бить something }
Function Extantion(xc,yc:Byte;CurFig:ChessType;Full:Boolean):Boolean;
Var dx,dy:Integer;x,y:Byte;b:Boolean;

begin   Extantion:=False;
for dx:=-1 to 1 do  if dx<>0  then
  for dy:=-1 to 1 do if dy<>0  then
    if Full or (NOT ((Sign(ac[Nac].x-xc)=dx) AND (Sign(ac[Nac].y-yc)=dy))) then begin
      if CurFig=Fuck then begin  {если шашака}
        x:=xc+dx;y:=yc+dy;
        if Non_Idiot(x,y) and (a[y,x].c<>CurPl) and
                 (a[y,x].t<>Empty) and (not Dead(x,y)) then
          begin
            x:=x+dx;y:=y+dy;
            if Non_Idiot(x,y) and
               (a[y,x].t=Empty) then begin Extantion:=True;exit end;
          end
      end  {если шашака}
      else begin { Дамка }
        b:=False;  x:=xc+dx;y:=yc+dy;
        while (Non_Idiot(x,y)) do begin
          if b then begin
            if (a[y,x].t=Empty) then begin Extantion:=True;exit end
                                else x:=10;
          end else begin
            if (a[y,x].c<>CurPl) and (a[y,x].t<>Empty) and (not Dead(x,y))
              then b:=True;
          end;
          x:=x+dx;y:=y+dy;
        end; { while }
      end; { Дамка }
    end;
end; { End of Extantion ---------------------------------------------- }

Procedure ChangePitcher; {Смена хода --------------------------------}
begin
if CurPl then CurPl:=False else CurPl:=True;
if(CurPl=White) then Message('Ход Белых') else Message('Ход Черных');
end;

Procedure Marker(xm,ym:Byte);  {Помечаем или снимаем пометку-крест}
Var x,y:Word;
begin
setwritemode(XORPut);setlinestyle(0,0,3);setcolor(9);
x:=x0+(xm-1)*ResolX+(ResolX div 2);
y:=y0+(ym-1)*Resoly+(Resoly div 2);
line(x-(ResolX div 4),y-(Resoly div 4),x+(Resolx div 4),y+(Resoly div 4));
line(x+(ResolX div 4),y-(Resoly div 4),x-(Resolx div 4),y+(Resoly div 4));
setcolor(8);setlinestyle(0,0,1);
line(x+(ResolX div 4)+2,y-(Resoly div 4)+2,x+4,y);
line(x,y+4,x-(Resolx div 4)+2,y+(Resoly div 4)+2);
setwritemode(CopyPut);
end;

{ Процедуры курсора =================================================== }
Procedure CursorOff;
begin
setlinestyle(0,0,3);
if (xc+yc) mod 2 = 0 then setcolor(ColW) else Setcolor(ColB);
rectangle(x0+(xc-1)*ResolX+1,y0+(yc-1)*ResolY+1,
          x0+ResolX-2+(xc-1)*ResolX,y0+(yc-1)*ResolY+ResolY-2);
setlinestyle(0,0,1);
end;

Procedure CursorOn;
begin
setcolor(10);
setlinestyle(0,0,3);
rectangle(x0+(xc-1)*ResolX+1,y0+(yc-1)*ResolY+1,
          x0+ResolX-2+(xc-1)*ResolX,y0+(yc-1)*ResolY+ResolY-2);
setlinestyle(0,0,1);
end;

{ Return - True , ecли }
Function End_Of_Game:Boolean;
Var y,x,x2:Byte;d:ShortInt;b:Boolean;
begin  if CurPl=Black then d:=-1 else d:=1;
End_Of_Game:=False;
for y:=1 to 8 do
  for x:=1 to 8 do
    if (a[y,x].c<>CurPl) and (a[y,x].t<>Empty) then begin
      if (a[y,x].t=Queen) then exit;
      CurPl:=not CurPl; b:=Extantion(x,y,Fuck,True); CurPl:=not CurPl;
      if b then exit;
      x2:=x+1; if Non_Idiot(x2,y+d) AND (a[y+d,x2].t=Empty) then Exit;
      x2:=x-1; if Non_Idiot(x2,y+d) AND (a[y+d,x2].t=Empty) then Exit;
    end;
End_Of_Game:=True
end;

{===========================================================================
------ Непосредственно Игровой Цикл =======================================}
Procedure Do_Do;
Label Enter_Label,New_Game,End_Of_Round;
Var key,key2:Char;temp:TChess; xm,ym:Integer;
    i,k,ea,xo,yo:Byte; b,Killing:Boolean;
begin k:=0;
CursorOn;Message('Ход Белых');
Repeat
if  MOUSEPRESENT then MouseOn;
Repeat
  if MOUSEPRESENT then k:=GetMouse(xm,ym)
Until (k<>0)or(Keypressed);
if  MOUSEPRESENT then MouseOff;

if k<>0 then begin

   for i:=1 to NB do
     if InSide(buts[i].x1,buts[i].y1,buts[i].x2,buts[i].y2,xm,ym) then
       case i of
         1 : begin key:=#0;key2:=#59 end;
         2 : begin key:=#0;key2:=#63 end;
         3 : begin key:=#0;key2:=#69 end;
       end;

   if InSide(x0,y0,x0+8*ResolX-1,y0+8*ResolY-1,xm,ym) then begin
     CursorOff;                   xc:=((xm-x0) div ResolX)+1;
     yc:=((ym-y0) div ResolY)+1;  CursorOn;
     case k of
         2 : key:=#27;
         4 : key:=#32;
       else  key:=#13;
     end;

   end;  {Это было Проыерка на квадратики}


end; {k<>0}

if k=0 then key:=Readkey;
case key of
  #0 : begin if k=0 then key2:=readkey;
    case key2 of
      'H' : {Up}   begin CursorOff;yc:=yc-1;
                         if yc=0 then yc:=8; CursorOn;end;
      'P' : {Down} begin CursorOff;yc:=yc+1;
                         if yc=9 then yc:=1; CursorOn;end;
      'K' : {Left} begin CursorOff;xc:=xc-1;
                         if xc=0 then xc:=8; CursorOn;end;
      'M' : {Right}begin CursorOff;xc:=xc+1;
                         if xc=9 then xc:=1; CursorOn;end;

      #59 : { F1 - Help }
         begin
           ShowButt(buts[1],False);Delay(100);ShowButt(buts[1],True)
         end;
      #63 : { F5 - New Game}
New_Game :
         begin
           ShowButt(buts[2],False);Delay(100);ShowButt(buts[2],True);
           FillField;DrawField;
           xc:=1;yc:=1;        {Тек.Коорд.}
           Nac:=0;              {Кол-во курсоров}
           CurPl :=False;      {Тек. Игрок : White-False or Black-True}
           CurFig:=Fuck;      {Тек. Фигура }
           OldFig:=Fuck;
           ScwMode:=False;   {True - Шашака выбрана}
           cursoron

         end;
      #69 : { F10 - Exit }
         begin
           ShowButt(buts[3],False);Delay(100);ShowButt(buts[3],True);
           CloseGraph;Halt(0)
         end;

    end; { case }
  end; { 0 }

  #27 : { Esc }
     if Nac>0 then begin CursorOff;
       While Nac>0 do begin
         Marker(ac[Nac].x,ac[Nac].y);
         Nac:=Nac-1;
       end; { While }  CursorOn;
       ScwMode:=False;Killing:=False;
     end; { Esc }
  #32 : { Space }
    begin
      if Nac>0 then begin
        CursorOff;Marker(ac[Nac].x,ac[Nac].y);Nac:=Nac-1;
        CursorOn;
      end;
      goto Enter_Label;
    end;

  #13 : { Enter } begin
Enter_Label :
    ea:=EnterAnal;
    if ea>0 then begin
    case ea of
      1 : {Mark  ---  Здесь мы делаем первую пометку ----------------}
        begin b:=True; Killing:=True;
          if Not Extantion(xc,yc,a[yc,xc].t,True) then begin
               for yo:=1 to 8 do
                 for xo:=1 to 8 do
                   if (a[yo,xo].c=CurPl) and (a[yo,xo].t<>Empty) then
                     if Extantion(xo,yo,a[yo,xo].t,True) then b:=False;
               if b then Killing:=False
          end;
          if b then begin
            CursorOff;Marker(xc,yc);
            Nac:=Nac+1;ac[Nac].x:=xc;ac[Nac].y:=yc;
            CurFig:=a[yc,xc].t;oldfig:=Empty;
            CursorOn;
          end;
        end; {Mark}

      2 : {Xod  ---  Здесь  Мы  Ходим ----------------------------------}
        if Not Killing then
        begin
          CursorOff;Marker(ac[1].x,ac[1].y);Nac:=0;
          a[yc,xc].t:=a[ac[1].y,ac[1].x].t;a[yc,xc].c:=CurPl;
          if ((yc=1)and(CurPl=White)) or ((yc=8)and(CurPl=Black))
          then a[yc,xc].t:=Queen;
          DrawFig(xc,yc);
          a[ac[1].y,ac[1].x].t:=Empty;DrawFig(ac[1].x,ac[1].y);
          goto End_of_Round
        end; {Xod}

      3 : {Kill} begin
     { Делаем Дамки }
     if CurFig=Fuck then
       if ((CurPl=White) and (yc=1)) or
          ((CurPl=Black) and (yc=8)) then CurFig:=Queen;

          if Extantion(xc,yc,CurFig,False) then  begin {---- Здесь помечаем след-ю
            клетку для бития врага------------------------------------- }
            CursorOff;Marker(xc,yc);
            Nac:=Nac+1;ac[Nac].x:=xc;ac[Nac].y:=yc;
            oldfig:=CurFig;
            if ((yc=1)and(CurPl=White)) or ((yc=8)and(CurPl=Black))
            then CurFig:=Queen;
            CursorOn;
          end {Extantion}
          {------------- Здесь уже непосредственно бьем отмеченные позы-и }
          else begin CursorOff;     xo:=Nac;
            a[yc,xc].t:=CurFig;a[yc,xc].c:=CurPl; DrawFig(xc,yc);
            While Nac>0 do begin
              Marker(ac[Nac].x,ac[Nac].y);
              a[ds[Nac].y,ds[Nac].x].t:=Empty;
              DrawFig(ds[Nac].x,ds[Nac].y);
              Nac:=Nac-1;
            end; { While }  CursorOn;
            a[ac[1].y,ac[1].x].t:=Empty; DrawFig(ac[1].x,ac[1].y);
            {Проверка на конец игры}
End_of_Round :
            if End_of_Game then begin
              Transporant(CurPl);goto New_Game
            end;

            ChangePitcher;  CursorOn;
          end; {Kill}
      end;
    end; {case of EnterAnal Return Code}
     { Делаем Дамки }
     if CurFig=Fuck then
       if ((CurPl=White) and (yc=1)) or
          ((CurPl=Black) and (yc=8)) then CurFig:=Queen;
    end; {of EnterAnal Return Code >0}
  end;{#13 - Enter}

end; {Main Case}
Until (key=#0) AND  (key2=#68);
CursorOff;Message('');
while Nac>1 do begin Nac:=Nac-1; end;
end;



Const GrDr:Integer=0;
Var GrMd:Integer;

BEGIN {Основная часть}  InitMouse;
InitGraph(GrDr,GrMd,'');
FillField;
DrawScreen;

Do_Do;

END.