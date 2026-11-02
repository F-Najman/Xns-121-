// cm_lifts.m -- Claims C1, C2: above each of the seven CM points of X_ns^+(11)
// there is exactly one rational point of X_ns^+(121).
//
// The lifts of the CM Cartan algebra A0 = O/11 to level 121 form a torsor
// under M_2(F_11)/A0 = A0*j, on which a Frobenius g in (O/121)^* acts by
// multiplication by g/gbar = g^(-10) (mod 11), and Aut(E) by u/ubar.
// A non-canonical lift X <> 0 is fixed (modulo Aut(E)) only if
// g^(-10) lies in {(u/ubar)^k}.  We exhibit, for each discriminant, a
// split prime p whose Frobenius g violates this:
//   g^10 <> 1 (j <> 0,1728), g^30 <> 1 (j = 0), g^20 <> 1 (j = 1728).
SetColumns(0);
Ds := [-3,-4,-12,-16,-27,-67,-163];
js := [0,1728,54000,287496,-12288000,-147197952000,-262537412640768000];
F121 := GF(121); P<X> := PolynomialRing(F121);
for i in [1..7] do
  D := Ds[i]; j := js[i];
  assert KroneckerSymbol(D,11) eq -1;            // 11 inert in the CM order
  E := EllipticCurveWithjInvariant(Rationals()!j);
  assert HasComplexMultiplication(E);
  e := j eq 0 select 30 else (j eq 1728 select 20 else 10);
  found := false;
  for p in PrimesInInterval(5,2000) do
    if p eq 11 or Conductor(E) mod p eq 0 or KroneckerSymbol(D,p) ne 1 then continue; end if;
    ap := TraceOfFrobenius(E,p);
    rts := Roots(X^2 - ap*X + p);
    if #rts eq 0 or #rts eq 1 and rts[1][2] eq 2 and rts[1][1] in GF(11) then continue; end if;
    g := rts[1][1];
    assert g^2 - ap*g + p eq 0 and g notin GF(11) or g^e ne 1;
    if g^e ne 1 then
      printf "C1 D=%o j=%o: p=%o a_p=%o, Frobenius g in F_121 has g^%o <> 1\n", D, j, p, ap, e;
      found := true; break;
    end if;
  end for;
  assert found;
end for;
printf "C1 VERIFIED: a unique rational lift above each CM point\n";
// Claim C2: on E = X_ns^+(11), the point n0*G is the only rational point
// above j(n0*G), for n0 = -2,...,4.
load "code/compact_jmap.m";
EQ := EllipticCurve([0,-1,1,-7,10]); G := EQ![4,5];
Qx<x> := RationalFunctionField(Rationals()); Qxy<yv> := PolynomialRing(Qx);
FE<y> := FunctionField(yv^2+yv-x^3+x^2+7*x-10);
PA := PolynomialRing(Rationals())!A; PB := PolynomialRing(Rationals())!B;
jfun := (Evaluate(PA,x)+Evaluate(PB,x)*y)/((x-4)*(y-5)-11)^11;
assert Degree(jfun) eq 55;
jlist := [-12288000,287496,54000,-147197952000,1728,0,-262537412640768000];
for n0 in [-2..4] do
  j0 := jlist[n0+3];
  rat := [pl : pl in Zeros(jfun-j0) | Degree(pl) eq 1];
  pts := [ n0 eq 0 select EQ!0 else EQ![Evaluate(FE!x,pl),Evaluate(y,pl)] : pl in rat | Valuation(FE!x,pl) ge 0 ];
  if exists{pl : pl in rat | Valuation(FE!x,pl) lt 0} then Append(~pts, EQ!0); end if;
  assert #rat eq 1 and pts eq [n0*G];
  printf "C2 n0=%o: the fibre of j above %o contains exactly one rational point, n0*G\n", n0, j0;
end for;
quit;
