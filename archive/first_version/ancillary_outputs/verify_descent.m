// A symmetric three-cusp divisor gives hyperelliptic covers of genus 16.
SetColumns(0);
R<t> := PolynomialRing(Rationals());
K<z> := NumberField(t^5+t^4-4*t^3-3*t^2+3*t+1);
E := EllipticCurve([K|0,-1,1,-7,10]);
G := E![4,5];
s := E![-z^4-z^3+2*z^2+3*z+3,-2*z^4-4*z^3+6*z^2+11*z+1];
assert Order(s) eq 11;
rr := [1,4,3,9,5];
cs := [r*s : r in rr];
mid := 3*s;
alpha := (2*s)[1];
gamma := mid[1]-alpha;
assert gamma ne 0;
kx<x> := RationalFunctionField(K);
ky<Y> := PolynomialRing(kx);
F<y> := FunctionField(Y^2+Y-x^3+x^2+7*x-10);
placeAt := function(p)
  for q in Zeros(F!(x-p[1])) do
    if Degree(q) eq 1 and Evaluate(y,q) eq p[2] then return q; end if;
  end for;
  error "No place";
end function;
O := Poles(F!x)[1];
pc := [placeAt(p) : p in cs];
// x-coordinate after translation by -mid.
mu := (y-(-1-mid[2]))/(x-mid[1]);
xt := mu^2+1-x-mid[1];
fb := (xt-alpha)/gamma;
b := [1,0,-2,0,1];
Db := &+[b[i]*Divisor(pc[i]) : i in [1..5]];
assert Divisor(fb) eq Db;
assert Evaluate(fb,O) eq 1;
printf "alpha=x(2s)=%o\ngamma=x(3s)-x(2s)=%o\n",alpha,gamma;
av := [[(r^m) mod 11 : r in rr] : m in [1..3]];
VV := VectorSpace(GF(11),5);
W := sub<VV | [VV!v : v in av]>;
Mt := Matrix(GF(11),av);
c := Eltseq(Solution(Mt,VV!b));
c := [Integers()!v : v in c];
v := [(b[i]-&+[c[m]*av[m][i] : m in [1..3]]) div 11 : i in [1..5]];
lam := (&+[v[i]*rr[i] : i in [1..5]]) mod 11;
printf "b = sum c_m a_m mod 11, c=%o; unramified correction lambda=%o\n",c,lam;
normalise := function(f)
  d := -Valuation(f,O);
  return f/Evaluate(f*(x/y)^d,O);
end function;
fm := [];
for m in [1..3] do
  D := &+[av[m][i]*Divisor(pc[i]) : i in [1..5]]-(&+av[m])*Divisor(O);
  ok,f := IsPrincipal(D); assert ok;
  Append(~fm,normalise(f));
end for;
ok,ft := IsPrincipal(11*Divisor(pc[1])-11*Divisor(O)); assert ok;
ft := normalise(ft);
Dh := &+[v[i]*Divisor(pc[i]) : i in [1..5]]-(&+v)*Divisor(O)-lam*(Divisor(pc[1])-Divisor(O));
ok,h := IsPrincipal(Dh); assert ok;
h := normalise(h);
assert fb eq (&*[fm[m]^c[m] : m in [1..3]])*ft^lam*h^11;
printf "Exact function-field identity verified.\n";
S<w> := PolynomialRing(K);
Deltas := []; Curves := []; KnownY := [];
for n in [-2..4] do
  q := n*G-mid;
  delta := q[1]-alpha;
  f := 4*(alpha+delta*w^11)^3-4*(alpha+delta*w^11)^2-28*(alpha+delta*w^11)+41;
  assert Degree(f) eq 33;
  assert GCD(f,Derivative(f)) eq 1;
  C := HyperellipticCurve(f);
  assert Genus(C) eq 16;
  assert Evaluate(f,K!1) eq (2*q[2]+1)^2;
  Append(~Deltas,delta); Append(~Curves,C); Append(~KnownY,2*q[2]+1);
  printf "n=%o delta=%o\n",n,delta;
  printf "  known point (w,Y)=(1,%o), genus=%o\n",2*q[2]+1,Genus(C);
end for;
printf "HYPERELLIPTIC_DESCENT_DONE\n";
// Deltas[i], Curves[i], KnownY[i] correspond to n=i-3, for i=1,...,7.
// The affine map to E is (w,Y) -> (alpha+Deltas[i]*w^11,(Y-1)/2)+3*s.
// No rank bound or completeness assertion is made.
