
Procedure FillField;
Var i,j:Byte;
Begin
for i:=1 to 8 do
  for j:=1 to 8 do
    a[i,j].t:=Empty;

for j:=0 to 3 do
  begin
        a[1,2+2*j].t:=Fuck;a[3,2+2*j].t:=Fuck;a[2,1+2*j].t:=Fuck;
        a[1,2+2*j].c:=Black;a[3,2+2*j].c:=Black;a[2,1+2*j].c:=Black;
        a[6,1+2*j].c:=White;a[8,1+2*j].c:=White;a[7,2*(j+1)].c:=White;
        a[6,1+2*j].t:=Fuck;a[8,1+2*j].t:=Fuck;a[7,2*(j+1)].t:=Fuck
  end;
{a[2,3].c:=Black;a[2,3].t:=Fuck;  a[5,2].c:=White;a[5,2].t:=Fuck;
a[3,2].c:=Black;a[3,2].t:=Queen;  a[2,5].c:=Black;a[2,5].t:=Queen;}
end;

Procedure DrawEmpty(x,y:Word;c:Byte);
begin
setfillstyle(1,c);bar(x,y,x+ResolX-1,y+ResolY-1);
end;

Procedure DrawWhite(x,y:Word);
begin
  setcolor(0);circle(x+(ResolX div 2)+1,y+(ResolY div 2)+1,(ResolX div 2)-10);
  setfillstyle(1,0);floodfill(x+(ResolX div 2)+1,y+(ResolY div 2)+1,0);
  setcolor(15);circle(x+(ResolX div 2)-1,y+(ResolY div 2)-1,(ResolX div 2)-10);
  setfillstyle(1,15);floodfill(x+(ResolX div 2)-1,y+(ResolY div 2)-1,15);
  setcolor(0);circle(x+(ResolX div 2)-1,y+(ResolY div 2)-1,(ResolX div 2)-10);
  circle(x+(ResolX div 2)-1,y+(ResolY div 2)-1,(ResolX div 2)-12);
  circle(x+(ResolX div 2)-1,y+(ResolY div 2)-1,(ResolX div 2)-15);
end;

Procedure DrawBlack(x,y:word);
begin
  setcolor(0);circle(x+(ResolX div 2)+1,y+(ResolY div 2)+1,(ResolX div 2)-10);
  setfillstyle(1,0);floodfill(x+(ResolX div 2)+1,y+(ResolY div 2)+1,0);
  setcolor(6);circle(x+(ResolX div 2)-1,y+(ResolY div 2)-1,(ResolX div 2)-10);
  setfillstyle(1,6);floodfill(x+(ResolX div 2)-1,y+(ResolY div 2)-1,6);
  setcolor(0);circle(x+(ResolX div 2)-1,y+(ResolY div 2)-1,(ResolX div 2)-10);
  circle(x+(ResolX div 2)-1,y+(ResolY div 2)-1,(ResolX div 2)-12);
  circle(x+(ResolX div 2)-1,y+(ResolY div 2)-1,(ResolX div 2)-15);
end;

Procedure DrawWhiteQueen(x,y:Word);
begin
  setcolor(0);circle(x+(ResolX div 2)+1,y+(ResolY div 2)+1,(ResolX div 2)-10);
  setfillstyle(1,0);floodfill(x+(ResolX div 2)+1,y+(ResolY div 2)+1,0);
  setcolor(8);circle(x+(ResolX div 2)-1,y+(ResolY div 2)-1,(ResolX div 2)-10);
  setfillstyle(1,8);floodfill(x+(ResolX div 2)-1,y+(ResolY div 2)-1,8);
  setcolor(0);

  Arc(x+(ResolX div 2)-1+3,y+(ResolY div 2)-1+3,90,180,(ResolX div 2)-10);

  circle(x+(ResolX div 2)-1,y+(ResolY div 2)-1,(ResolX div 2)-10);
  circle(x+(ResolX div 2)-1,y+(ResolY div 2)-1,(ResolX div 2)-12);
     setfillstyle(1,7);
     floodfill(x+(ResolX div 2)-1,y+(ResolY div 2)-1,0);
     setfillstyle(1,15);
     floodfill(x+(ResolX div 2)-1,y+(ResolY div 2)-1+(ResolX div 2)-11,0);

end;

Procedure DrawBlackQueen(x,y:word);
begin
  setcolor(0);circle(x+(ResolX div 2)+1,y+(ResolY div 2)+1,(ResolX div 2)-10);
  setfillstyle(1,0);floodfill(x+(ResolX div 2)+1,y+(ResolY div 2)+1,0);
  setcolor(4);circle(x+(ResolX div 2)-1,y+(ResolY div 2)-1,(ResolX div 2)-10);
  setfillstyle(1,4);floodfill(x+(ResolX div 2)-1,y+(ResolY div 2)-1,4);
  setcolor(0);
  circle(x+(ResolX div 2)-1,y+(ResolY div 2)-1,(ResolX div 2)-10);
  Arc(x+(ResolX div 2)-1+3,y+(ResolY div 2)-1+3,90,180,(ResolX div 2)-10);
  circle(x+(ResolX div 2)-1,y+(ResolY div 2)-1,(ResolX div 2)-12);
     setfillstyle(1,6);
     floodfill(x+(ResolX div 2)-1,y+(ResolY div 2)-1,0);
     floodfill(x+(ResolX div 2)-1,y+(ResolY div 2)-1+(ResolX div 2)-11,0);
end;

