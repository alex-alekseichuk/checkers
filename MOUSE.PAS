Unit Mouse;

Interface

Uses Dos;

Const MousePresent:Boolean=FALSE;

Function InitMouse:Boolean;
Procedure MouseOn;
Procedure MouseOff;
Procedure SetMouse(x,y:Word);
Function GetMouse(Var x,y:Integer):Byte;
Procedure MouseBorder(x1,y1,x2,y2:Word);

Implementation

Function InitMouse:Boolean;
Var r:Registers;
begin
r.ax:=0;
Intr($33,r);
if r.ax=65535 then begin InitMouse:=True;MousePresent:=True end
		  else begin InitMouse:=False;MousePresent:=False end
end;

Procedure MouseOn;
Var r:Registers;
begin
r.ax:=1;
Intr($33,r)
end;

Procedure MouseOff;
Var r:Registers;
begin
r.ax:=2;
Intr($33,r)
end;

Procedure SetMouse(x,y:Word);
var r:registers;
begin
r.ax:=4;r.cx:=x;r.dx:=y;intr($33,r)
end;

Function GetMouse(Var x,y:Integer):Byte;
Var r:Registers;
begin
r.ax:=3;Intr($33,r);
x:=r.cx;y:=r.dx;GetMouse:=r.bl
end;

Procedure MouseBorder(x1,y1,x2,y2:Word);
Var r:Registers;
begin
r.ax:=7;r.cx:=x1;r.dx:=x2;Intr($33,r);
r.ax:=8;r.cx:=y1;r.dx:=y2;Intr($33,r)
end;

End.