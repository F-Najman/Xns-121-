// Run from the workspace root: magma -b outputs/retry/verify_genus5.m
// This file verifies the new reduction; it does not determine rational points.
SetColumns(0);
load "outputs/verify_descent.m";
KT<T>:=PolynomialRing(K);
L<theta>:=NumberField(T^3-T^2-7*T+41/4);
LA:=AbsoluteField(L);
LS,toLS:=OptimisedRepresentation(LA);
assert Degree(LA) eq 15;
assert Discriminant(Integers(LA)) eq -2^10*11^13;
EL:=BaseChange(E,L); GL:=EL!G; sL:=EL!s;
assert Order(EL![theta,-1/2]) eq 2;
assert not IsSquare(4-theta);
ok,beta:=IsSquare(L!alpha-theta); assert ok;
assert beta^2 eq L!alpha-theta;
LW<W>:=PolynomialRing(L);
Genus5Curves:=[]; Etas:=[]; KnownV:=[];
for i in [1..7] do
 n0:=i-3;
 eta:=IsEven(n0) select L!1 else 4-theta;
 q0:=n0*GL-3*sL;
 f5:=(L!alpha-theta+L!Deltas[i]*W^11)/eta;
 D:=HyperellipticCurve(f5);
 assert Degree(f5) eq 11 and GCD(f5,Derivative(f5)) eq 1;
 assert Genus(D) eq 5;
 ok,v0:=IsSquare((q0[1]-theta)/eta); assert ok;
 mult:=IsEven(n0) select 2 else 11;
 if mult*Norm(v0) ne 2*q0[2]+1 then v0:=-v0; end if;
 assert mult*Norm(v0) eq 2*q0[2]+1;
 assert Evaluate(f5,1) eq v0^2;
 assert (E![alpha+Deltas[i],(mult*Norm(v0)-1)/2])+3*s eq n0*G;
 assert Abs(Norm(Deltas[i])) eq 121;
 // Sample verification of the square-class homomorphism; the mathematical
 // proof uses x-theta on E(L)/2E(L), not the finiteness of this sample.
 for m in [-3..3] do
  q:=(n0+2*m)*GL-3*sL;
  assert IsSquare((q[1]-theta)/eta);
 end for;
 Append(~Genus5Curves,D); Append(~Etas,eta); Append(~KnownV,v0);
 printf "n=%o genus=5 eta=%o known_v=%o\n",n0,eta,v0;
end for;
// Exact polynomial identity underlying the reconstruction by a cubic norm.
LX<X>:=PolynomialRing(L); KX<U>:=PolynomialRing(K);
assert MinimalPolynomial(theta) eq KT! (T^3-T^2-7*T+41/4);
assert Norm(4-theta) eq 121/4;
// The cyclotomic field used for the 11-isogeny descents.
fac:=Factorisation(PolynomialRing(LS)!CyclotomicPolynomial(11));
assert &and[Degree(a[1]) eq 2:a in fac];
LF<xi>:=NumberField(fac[1][1]); AF:=AbsoluteField(LF);
F,optF:=OptimisedRepresentation(AF);
conv:=func<a | optF(AF!LF!toLS(LA!a))>;
assert Degree(F) eq 30;
assert Discriminant(Integers(F)) eq -2^20*11^27;
for i in [1..7] do
 c0:=conv(Deltas[i]/(L!alpha-theta));
 ff:=Factorisation(c0*Integers(F));
 assert #ff eq 1 and Norm(ff[1][1]) eq 1024 and ff[1][2] eq 2;
end for;
printf "ALL_SEVEN_c0_ARE_2_UNITS; valuation_at_unique_prime_above_2=2\n";
assert not IsSquare(conv(4-theta));
FT<U>:=PolynomialRing(F);
B<b>:=NumberField(U^2-conv(4-theta));
assert Degree(AbsoluteField(B)) eq 60;
printf "GENUS5_REDUCTION_VERIFIED; DESCENT_FIELD_DEGREES=30,60\n";
// Leave the objects available to the non-torsion and Selmer scripts.
