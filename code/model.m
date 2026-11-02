SetColumns(0);
load "code/original_jmap.m";
Q := Rationals();
E := EllipticCurve([Q|0,-1,1,-7,10]);
G := E![4,5];
printf "Rank bounds: %o; generators: %o\n", RankBounds(E), Generators(E);
K<x> := RationalFunctionField(Q);
R<Y> := PolynomialRing(K);
F<y> := FunctionField(Y^2+Y-x^3+x^2+7*x-10);
j := Evaluate(Xns11_jnum,[x,y,1])/Evaluate(Xns11_jden,[x,y,1]);
u := (x-4)*(y-5)-11;
assert Degree(j) eq 55;
assert Degree(u) eq 5;
cusps := Poles(j);
assert &and[Valuation(j,p) eq -11 : p in cusps];
assert &+[Degree(p) : p in cusps] eq 5;
assert Divisor(u) eq &+[Divisor(p) : p in cusps] - 5*Divisor(Poles(F!x)[1]);
cf := Eltseq(j*u^11);
assert #cf eq 2;
assert &and[Degree(Denominator(c)) eq 0 : c in cf];
S<t> := PolynomialRing(Q);
a := S!cf[1]; b := S!cf[2];
printf "Compact numerator degrees: %o, %o\n", Degree(a), Degree(b);
printf "CM points (n, coordinates, j, CM discriminant):\n";
Ds := [-27,-16,-12,-67,-4,-3,-163];
js := [-12288000,287496,54000,-147197952000,1728,0,-262537412640768000];
for n in [-2..4] do
  p := n*G;
  if n eq 0 then
    jj := LeadingCoefficient(b); // both numerator and u^11 have pole order 55
  else
    xx := p[1]; yy := p[2];
    jj := (Evaluate(a,xx)+Evaluate(b,xx)*yy)/((xx-4)*(yy-5)-11)^11;
  end if;
  assert jj eq js[n+3];
  assert KroneckerSymbol(Ds[n+3],11) eq -1;
  printf "%o %o %o %o\n",n,p,jj,Ds[n+3];
end for;
load "code/compact_jmap.m";
assert a eq S!A and b eq S!B;
printf "AUDIT_DONE\n";
quit;
