SetColumns(0);
load "outputs/retry/verify_genus5.m";
u:=2-z; pk:=Decomposition(K,11)[1][1];
for n0 in [-1,1,3] do
 q0:=n0*G-3*s; idx:=n0+3;
 assert Valuation((q0[1]-4)/u^2,pk) eq 1;
 assert Valuation((q0[2]+1/2)/u^3,pk) eq 1;
 assert Valuation(Deltas[idx],pk) eq 2;
 for pe in Decomposition(F,11) do
  assert Valuation(conv(L!q0[1]-theta),pe[1]) in [5,6];
 end for;
 printf "ODD_ELLIPTIC_DEPTH n=%o v_K(x')=1 v_K(y')=1 v_K(delta)=2; v_K(w-1)=5k-3\n",n0;
end for;
// Verify the global formula selecting compatible square-root signs.
LX<x>:=RationalFunctionField(L); LY<yy>:=PolynomialRing(LX);
FE<y>:=FunctionField(yy^2+yy-x^3+x^2+7*x-10);
inf:=Poles(FE!x)[1];
slope:=(3*x^2-2*x-7)/(2*y+1);
x2:=slope^2+1-2*x;
y2:=-y+slope*(x-x2)-1;
h:=((x-theta)^2-(3*theta^2-2*theta-7))/(2*y+1);
assert h^2 eq x2-theta;
for n0 in [-1,1,3] do
 p0:=n0*GL-3*sL;
 slope2:=(y2-p0[2])/(x2-p0[1]);
 xsum:=slope2^2+1-x2-p0[1];
 ratio:=-(slope2*(theta-p0[1])+p0[2]+1/2)/((p0[1]-theta)*h);
 assert ratio^2 eq (xsum-theta)/(p0[1]-theta);
 assert Evaluate(ratio,inf) eq 1;
 printf "ODD_GLOBAL_SQUARE_ROOT_RATIO_VERIFIED n=%o value_at_identity=1\n",n0;
end for;
printf "ODD_DEPTH_AND_BRANCH_INPUTS_VERIFIED\n";
quit;
