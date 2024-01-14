
Procedure DrawRect(x1,y1,x2,y2:Word;s:Boolean);
begin
if s then setcolor(15) else setcolor(0); line(x1,y1,x2,y1);line(x1,y1,x1,y2);
if s then setcolor(0) else setcolor(15);line(x2,y2,x2,y1);line(x2,y2,x1,y2);
end;

Procedure DrawBar(x1,y1,x2,y2:Word;c:Byte);
begin setfillstyle(1,c);bar(x1,y1,x2,y2);DrawRect(x1,y1,x2,y2,TRUE) end;

Function InSide(x1,y1,x2,y2,x,y:Word):Boolean;
begin
if (x>=x1)and(x<=x2)and(y>=y1)and(y<=y2) then InSide:=True else InSide:=False
end;

Procedure Message(s:string);
begin
if MesLen>0 then begin setfillstyle(BGS,BGC);
   bar(getmaxx-8*(MesLen+2)-DMes,DMes,getmaxx-Dmes,Dmes+3*8) end;
MesLen:=Length(s);
if MesLen>0 then begin
  drawbar(getmaxx-8*(MesLen+2)-DMes,DMes,getmaxx-Dmes,Dmes+3*8,7);
  outtextxy(getmaxx-8*(MesLen+1)-DMes,DMes+8,s);
end;
end;




Type Str32=String[32];
Type Butt=record
       x1:Word;y1:Word;x2:Word;y2:Word;
       s:Str32;
       hot:Str32;
     end;


Const  NB=3;
       xf=7;yf=7;



Procedure ShowButt(Var b:Butt;f:Boolean); {True-Обычное сост.}
Var d:Byte;
begin
if b.x2=0 then begin b.x2:=b.x1+2*xf+8*(length(b.s)+4);b.y2:=b.y1+8+2*yf end;
DrawBar(b.x1,b.y1,b.x2,b.y2,7);
if Not F then begin DrawRect(b.x1,b.y1,b.x2,b.y2,False);d:=1 end else d:=0;
setcolor(15);outtextxy(b.x1+xf+d,b.y1+yf+d,b.hot);
setcolor(0);outtextxy(b.x1+xf+4*8+d,b.y1+yf+d,b.s);
end;

Const  buts:array[1..NB] of Butt = (
              (x1:400;y1:100;x2:525;y2:122;s:'Помощь';hot:'F1'),
              (x1:400;y1:130;x2:525;y2:152;s:'Новая Игра';hot:'F5'),
              (x1:400;y1:160;x2:525;y2:182;s:'Выход';hot:'F10')

                );



Procedure Transporant(b:Boolean);
var c:Char;x,y:Integer;k:Byte; ss:string[40];
    p:Pointer;
begin   k:=0;  ss:='Выиграли  ';
if b=Black then ss:=ss+'Черные' else ss:=ss+'Белые';
Message('Нажмите любую клавишу');

GetMem(p,ImageSize(100,150,500,250)); GetImage(100,150,500,250,p^);
DrawBar(100,150,500,250,3);

settextstyle(0,0,2);
setcolor(0);OutTextXY(180,195,ss);
setcolor(15);OutTextXY(179,194,ss);
settextstyle(0,0,0);
delay(500);
while not Keypressed AND (k=0) do if MOUSEPRESENT then k:=GetMouse(x,y);
if k=0 then begin c:=Readkey;if c=#0 then c:=Readkey end;

PutImage(100,150,p^,NormalPut);  FreeMem(p,ImageSize(100,150,500,250));

Message('Ход Белых')
end;