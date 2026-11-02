// Independent check of the six-prime sieve (written separately from
// generate_six_prime_sieve.m and six_prime_sieve.py of the draft).
//
// Differences from the draft code:
//  * the cusps are recomputed as the zeros of u=(x-4)(y-5)-11, the
//    denominator of the j-map, and checked to be the multiples r*s;
//  * the functions f_m are computed once over K and reduced modulo each
//    prime (the draft recomputes them over each residue field);
//  * the sieve is a brute force over all residues n mod 4356 (every
//    order of G modulo the six primes divides 4356), solving the three
//    linear systems directly, instead of incremental lifting.
//
// Claim S1: if n mod 4356 is not in {-2,...,4}, one of the three linear
//   systems is inconsistent.
// Claim S2: for n0 in {-2,...,4} each system has a unique solution, equal
//   to the class of f_m(n0 G) in K(S,11) computed globally.
//
// Usage: magma -b CONSERVATIVE_O:=0 code/sieve_bruteforce.m
// With CONSERVATIVE_O:=1 the residue n = 0 mod ord(G mod l) is also left
// unconstrained (no use of the normalisation at O).
SetColumns(0);
if not assigned CONSERVATIVE_O then CONSERVATIVE_O := 0;
elif Type(CONSERVATIVE_O) eq MonStgElt then CONSERVATIVE_O := StringToInteger(CONSERVATIVE_O); end if;

Q := Rationals();
E := EllipticCurve([Q|0,-1,1,-7,10]);
G := E![4,5];
assert Rank(E) eq 1 and #TorsionSubgroup(E) eq 1;
P1<t> := PolynomialRing(Q);
K<z> := NumberField(t^5+t^4-4*t^3-3*t^2+3*t+1);
OK := MaximalOrder(K);
assert Discriminant(OK) eq 11^4 and IsAbelian(K);
assert #ClassGroup(OK) eq 1;                       // proven (no GRH bound set)
EK := BaseChange(E,K);
GK := EK!G;

// --- cusps: zeros of u = (x-4)(y-5)-11.  Substituting y = 5+11/(x-4):
PK<X> := PolynomialRing(K);
yy := 5*(X-4)+11;                                  // (x-4)*y
cuspPol := yy^2 + yy*(X-4) - (X^3-X^2-7*X+10)*(X-4)^2;
assert Degree(cuspPol) eq 5;
rts := Roots(cuspPol);
assert #rts eq 5;
cusps := [ EK![r[1], 5+11/(r[1]-4)] : r in rts ];
s := EK![-z^4-z^3+2*z^2+3*z+3, -2*z^4-4*z^3+6*z^2+11*z+1];   // the draft's s
assert s in cusps and Order(s) eq 11;
rr := [1,4,3,9,5];
assert {r*s : r in rr} eq Seqset(cusps);
// the cusps are poles of j of order 11: j=(A(x)+B(x)y)/u^11 with A+By nonzero there
load "code/compact_jmap.m";       // defines A,B in Q[t]
// Claim M2: (A+By)(c) is a unit away from 11 for every cusp c, so that
// v_q(j(P)) = -11 (P.c)_q at every prime q of K not above 11.
for c in cusps do
  val := Evaluate(P1!A,c[1]) + Evaluate(P1!B,c[1])*c[2];
  assert val ne 0;
  assert &and[ Norm(pr[1]) mod 11 eq 0 : pr in Factorisation(val*OK) ];
end for;
printf "M2: (A+By)(c) is an 11-unit for all 5 cusps\n";
printf "CUSPS_OK: 5 cusps r*s, r in %o, s of order 11\n", rr;

// --- functions f_m over K, normalised by f_m*(x/y)^22 = 1 at O
kx<x> := RationalFunctionField(K);
ky<Yv> := PolynomialRing(kx);
FE<y> := FunctionField(Yv^2+Yv-(x^3-x^2-7*x+10));
O := Poles(FE!x)[1];
placeAt := function(pt)
  for q in Zeros(FE!(x-pt[1])) do
    if Degree(q) eq 1 and Evaluate(y,q) eq pt[2] then return q; end if;
  end for;
  error "no place";
end function;
cuspPlaces := [placeAt(r*s) : r in rr];
fm := [];
for m in [1..3] do
  a := [Integers()!((r^m) mod 11) : r in rr];
  assert &+a eq 22;
  ok, f := IsPrincipal(&+[a[i]*Divisor(cuspPlaces[i]) : i in [1..5]] - 22*Divisor(O));
  assert ok;
  f := f/Evaluate(f*(x/y)^22, O);
  assert Evaluate(f*(x/y)^22, O) eq 1;
  Append(~fm, f);
end for;

// --- basis of K(S,11), S = {(2-z)}
p11 := Factorisation(11*OK)[1][1];
assert #Factorisation(11*OK) eq 1 and p11 eq ideal<OK|2-z>;
U, mU := UnitGroup(OK);
bas := [K!(2-z)] cat [K!mU(U.i) : i in [2..Ngens(U)]];
assert #bas eq 5;
globalClass := function(alpha)
  fac := Factorisation(alpha*OK);
  e0 := 0; J := 1*OK;
  for pr in fac do
    if pr[1] eq p11 then e0 := pr[2];
    else assert pr[2] mod 11 eq 0; J := J*pr[1]^(pr[2] div 11); end if;
  end for;
  ok, g := IsPrincipal(J); assert ok;
  w := alpha/((K!(2-z))^e0*(K!g)^11);
  assert IsUnit(OK!w);
  v := Eltseq(w@@mU);
  return [e0 mod 11] cat [v[i] mod 11 : i in [2..#v]];
end function;
cmClasses := AssociativeArray();
for n0 in [-2..4] do
  if n0 eq 0 then cmClasses[n0] := [[0,0,0,0,0] : m in [1..3]]; continue; end if;
  pl := placeAt(n0*GK);
  cmClasses[n0] := [globalClass(Evaluate(fm[m],pl)) : m in [1..3]];
  printf "GLOBAL_CLASS n0=%o classes=%o\n", n0, cmClasses[n0];
end for;

// --- local tables
primes := [353,23,3301,12101,15731,53];
M := 4356;
tables := [* *];      // entries <N, chirows, values> per prime of K above l
for l in primes do
  Fl := GF(l);
  N := Order((ChangeRing(E,Fl))!G);
  assert M mod N eq 0;
  for pr in Factorisation(l*OK) do
    lam := pr[1];
    Fq, red := ResidueClassField(lam);
    q := #Fq; assert (q-1) mod 11 eq 0;
    e11 := (q-1) div 11;
    zeta := PrimitiveElement(Fq)^e11;
    dl := AssociativeArray(); for k in [0..10] do dl[zeta^k] := k; end for;
    chi := func< v | dl[v^e11] >;
    redK := func< c | red(OK!c) >;
    Eq := EllipticCurve([Fq|0,-1,1,-7,10]);
    Gq := Eq![4,5];
    cuspsq := { Eq![redK(c[1]), redK(c[2])] : c in cusps };
    chib := [chi(redK(b)) : b in bas];
    vals := [];
    for m in [1..3] do
      // f = (c0(x) + c1(x) y), c_i in K(x): reduce numerators and denominators
      cs := Eltseq(fm[m]);
      redrat := function(rf)
        nu := Numerator(rf); de := Denominator(rf);
        cn := Coefficients(nu); cd := Coefficients(de);
        // scale to make both lambda-integral and not both divisible by lambda
        sc := Min([Valuation(c,lam) : c in cn cat cd | c ne 0]);
        unif := UniformizingElement(lam);
        cn := [c/K!unif^sc : c in cn]; cd := [c/K!unif^sc : c in cd];
        return [redK(c) : c in cn], [redK(c) : c in cd];
      end function;
      row := [];
      for k in [0..N-1] do
        Pk := k*Gq;
        if Pk eq Eq!0 then Append(~row, CONSERVATIVE_O eq 1 select -1 else 0); continue; end if;
        if Pk in cuspsq then Append(~row, -1); continue; end if;
        val := Fq!0; good := true;
        for i in [1..2] do
          nu, de := redrat(cs[i]);
          dv := &+[Fq| de[j]*Pk[1]^(j-1) : j in [1..#de]];
          if dv eq 0 then good := false; break; end if;
          val +:= (&+[Fq| nu[j]*Pk[1]^(j-1) : j in [1..#nu]])/dv * Pk[2]^(i-1);
        end for;
        if not good or val eq 0 then Append(~row, -1); continue; end if;
        Append(~row, chi(val));
      end for;
      Append(~vals, row);
    end for;
    nunk := #[k : k in [1..N] | vals[1][k] eq -1];
    printf "TABLE l=%o N=%o deg=%o unknown_residues=%o\n", l, N, Degree(lam), nunk;
    Append(~tables, <N, chib, vals>);
  end for;
end for;

// --- brute force over n mod M
V5 := VectorSpace(GF(11),5);
survivors := [];
for n in [0..M-1] do
  okAll := true; sols := [];
  for m in [1..3] do
    cols := []; rhs := [];
    for T in tables do
      k := n mod T[1];
      if T[3][m][k+1] lt 0 then continue; end if;
      Append(~cols, T[2]); Append(~rhs, T[3][m][k+1]);
    end for;
    if #cols eq 0 then Append(~sols, <V5!0, 5>); continue; end if;
    A := Transpose(Matrix(GF(11), cols));        // 5 x r
    ok, v, ker := IsConsistent(A, Vector(GF(11), rhs));
    if not ok then okAll := false; break; end if;
    Append(~sols, <V5!v, Dimension(ker)>);
  end for;
  if okAll then Append(~survivors, <n, sols>); end if;
end for;
centred := func< n | n gt M div 2 select n-M else n >;
printf "SURVIVORS mod %o: %o\n", M, Sort([centred(S[1]) : S in survivors]);
if CONSERVATIVE_O eq 1 then
  // supplementary run: without the information at the points reducing to O
  printf "CONSERVATIVE_RUN_DONE: %o residue classes survive\n", #survivors;
  quit;
end if;
assert Sort([centred(S[1]) : S in survivors]) eq [-2..4];
for S in survivors do
  n0 := centred(S[1]);
  printf "STATE n0=%o solution_space_dims=%o\n", n0, [S[2][m][2] : m in [1..3]];
  if CONSERVATIVE_O eq 1 and n0 eq 0 then continue; end if;
  for m in [1..3] do
    assert S[2][m][2] eq 0;                        // unique solution
    assert [Integers()!c : c in Eltseq(S[2][m][1])] eq cmClasses[n0][m];
  end for;
end for;
printf "SIEVE_BRUTEFORCE_VERIFIED conservative_O=%o: n = n0 mod 4356, n0 in [-2..4], classes = global classes of f_m(n0 G)\n", CONSERVATIVE_O;
quit;
