// setup.m -- common objects for all scripts.  Run every script from the
// repository root:  magma -b code/<script>.m
//
// Defines: K=Q(zeta_11)^+ (generator z), E = X_ns^+(11) over K, G=(4,5),
// the cusp s of order 11, alpha=x(2s), Deltas[i]=delta_{n0} (i=n0+3),
// the cubic field L=K(theta), beta with beta^2=alpha-theta, Etas, KnownV,
// the degree-30 field F=L(zeta_11) with the map conv: L -> F, and the
// degree-60 field B=F(sqrt(eta)) for the odd classes.
//
// The asserts below are Claims D1-D4 of the README.
SetColumns(0);
R<t> := PolynomialRing(Rationals());
K<z> := NumberField(t^5+t^4-4*t^3-3*t^2+3*t+1);
OK := MaximalOrder(K);
E := EllipticCurve([K|0,-1,1,-7,10]);
G := E![4,5];
s := E![-z^4-z^3+2*z^2+3*z+3,-2*z^4-4*z^3+6*z^2+11*z+1];
assert Order(s) eq 11;
rr := [1,4,3,9,5];
mid := 3*s;
alpha := (2*s)[1];
gamma := mid[1]-alpha;
assert gamma ne 0;

// ---- Claim D1: the function-field identity
//   (x(P-3s)-alpha)/(x(3s)-alpha) = f_1^7 f_2^10 f_3^6 f_T^3 h^11.
kx<x> := RationalFunctionField(K);
ky<Yv> := PolynomialRing(kx);
FE<y> := FunctionField(Yv^2+Yv-x^3+x^2+7*x-10);
placeAt := function(p)
  for q in Zeros(FE!(x-p[1])) do
    if Degree(q) eq 1 and Evaluate(y,q) eq p[2] then return q; end if;
  end for;
  error "No place";
end function;
OE := Poles(FE!x)[1];
pc := [placeAt(r*s) : r in rr];
mu := (y-(-1-mid[2]))/(x-mid[1]);
xt := mu^2+1-x-mid[1];                       // x(P-3s)
fb := (xt-alpha)/gamma;
bexp := [1,0,-2,0,1];
assert Divisor(fb) eq &+[bexp[i]*Divisor(pc[i]) : i in [1..5]];
assert Evaluate(fb,OE) eq 1;
av := [[(r^m) mod 11 : r in rr] : m in [1..3]];
VV11 := VectorSpace(GF(11),5);
cexp := [Integers()!c : c in Eltseq(Solution(Matrix(GF(11),av),VV11!bexp))];
vexp := [(bexp[i]-&+[cexp[m]*av[m][i] : m in [1..3]]) div 11 : i in [1..5]];
lam := (&+[vexp[i]*rr[i] : i in [1..5]]) mod 11;
assert cexp eq [7,10,6] and lam eq 3;
normalise := function(f)
  d := -Valuation(f,OE);
  return f/Evaluate(f*(x/y)^d,OE);
end function;
fm := [];
for m in [1..3] do
  ok,f := IsPrincipal(&+[av[m][i]*Divisor(pc[i]) : i in [1..5]]-(&+av[m])*Divisor(OE));
  assert ok; Append(~fm,normalise(f));
end for;
ok,fT := IsPrincipal(11*Divisor(pc[1])-11*Divisor(OE)); assert ok;
fT := normalise(fT);
Dh := &+[vexp[i]*Divisor(pc[i]) : i in [1..5]]-(&+vexp)*Divisor(OE)-lam*(Divisor(pc[1])-Divisor(OE));
ok,hh := IsPrincipal(Dh); assert ok;
hh := normalise(hh);
assert fb eq (&*[fm[m]^cexp[m] : m in [1..3]])*fT^lam*hh^11;

// ---- the seven classes: x(n0 G - 3s) = alpha + delta_{n0}
Deltas := [];
for n0 in [-2..4] do
  q := n0*G-mid;
  Append(~Deltas, q[1]-alpha);
end for;

// ---- Claim D2: the cubic field L, the two-descent and the genus 5 curves
KT<T> := PolynomialRing(K);
L<theta> := NumberField(T^3-T^2-7*T+41/4);
LA := AbsoluteField(L);
LS,toLS := OptimisedRepresentation(LA);
assert Degree(LA) eq 15;
assert Discriminant(Integers(LA)) eq -2^10*11^13;
EL := BaseChange(E,L); GL := EL!G; sL := EL!s;
assert Order(EL![theta,-1/2]) eq 2;
assert not IsSquare(4-theta);
ok,beta := IsSquare(L!alpha-theta); assert ok;
LW<W> := PolynomialRing(L);
Genus5Curves := []; Etas := []; KnownV := [];
for i in [1..7] do
  n0 := i-3;
  eta := IsEven(n0) select L!1 else 4-theta;
  q0 := n0*GL-3*sL;
  f5 := (L!alpha-theta+L!Deltas[i]*W^11)/eta;
  assert Degree(f5) eq 11 and GCD(f5,Derivative(f5)) eq 1;
  ok,v0 := IsSquare((q0[1]-theta)/eta); assert ok;
  // fix the sign of v0: for even n0 it is the duplication square root
  if IsEven(n0) then
    r0 := (n0 div 2)*GL+4*sL;
    v0 := ((r0[1]-theta)^2-(3*theta^2-2*theta-7))/(2*r0[2]+1);
    assert v0^2 eq q0[1]-theta;
  else
    mult := 11;
    if mult*Norm(v0) ne 2*q0[2]+1 then v0 := -v0; end if;
    assert mult*Norm(v0) eq 2*q0[2]+1;
  end if;
  assert Evaluate(f5,1) eq v0^2;
  assert Abs(Norm(Deltas[i])) eq 121;
  Append(~Genus5Curves,HyperellipticCurve(f5)); Append(~Etas,eta); Append(~KnownV,v0);
end for;

// ---- Claim D3: the fields F = L(zeta_11) (degree 30) and B = F(sqrt eta) (degree 60)
fac := Factorisation(PolynomialRing(LS)!CyclotomicPolynomial(11));
assert &and[Degree(a[1]) eq 2 : a in fac];
LF<xi> := NumberField(fac[1][1]); AF := AbsoluteField(LF);
F,optF := OptimisedRepresentation(AF);
conv := func<a | optF(AF!LF!toLS(LA!a))>;
assert Degree(F) eq 30;
assert Discriminant(Integers(F)) eq -2^20*11^27;
// a = delta/(alpha-theta) has ideal (prime above 2)^2 in F
for i in [1..7] do
  c0 := conv(Deltas[i]/(L!alpha-theta));
  ff := Factorisation(c0*Integers(F));
  assert #ff eq 1 and Norm(ff[1][1]) eq 1024 and ff[1][2] eq 2;
end for;
assert not IsSquare(conv(4-theta));
FU<U> := PolynomialRing(F);
B := NumberField(U^2-conv(4-theta));
zetaF := Roots(PolynomialRing(F)!CyclotomicPolynomial(11))[1][1];
printf "SETUP_DONE\n";
