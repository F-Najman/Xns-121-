// Regenerate all input for the six-prime completeness sieve.
// 06_sieve_data.m -- local data for the Mordell-Weil sieve on 11-integral points of E = X_ns^+(11) = 121b1.
//
// Descent: for P = nG 11-integral (i.e. P meets every cusp with multiplicity = 0 mod 11 at every prime),
//   f_m(P) in delta_m * K^{x11},  delta_m in K(S,11) = <pi11, u1..u4> / 11th powers,  S = {p_11},
// where K = Q(zeta_11)^+, f_m has divisor sum_i a_i [c_i] - (sum a_i)[O], a_i = r_i^m mod 11 (m = 1,2,3),
// normalised so that f_m * (x/y)^(sum a_i) = 1 at O.  (So delta_m(O) = 0.)
// At a prime lambda of K over l with 11 | N(lambda)-1, and nG not = cusp mod lambda:
//   sum_j e_j chi_lambda(b_j) + chi_lambda(f_m(nG)) = 0 (mod 11),  b = [pi11,u1,..,u4].
// Output: one line per (l, lambda): "L l N_l lambda_index chi_b[5] T1[N_l] T2[N_l] T3[N_l]" with T_m[k] = chi(f_m(kG)) or -1 (cusp).
// Usage: magma -b LMAX:=3000 code/06_sieve_data.m < /dev/null > data/sieve_data.txt
SetColumns(0);
SetMemoryLimit(40*10^9);
if not assigned LMAX then LMAX := 3000; elif Type(LMAX) eq MonStgElt then LMAX := StringToInteger(LMAX); end if;
if not assigned LMIN then LMIN := 2; elif Type(LMIN) eq MonStgElt then LMIN := StringToInteger(LMIN); end if;
if not assigned ONLYSPLIT then ONLYSPLIT := 0; elif Type(ONLYSPLIT) eq MonStgElt then ONLYSPLIT := StringToInteger(ONLYSPLIT); end if;
allowed := ONLYSPLIT eq 1 select {1} else {1,3,4,5,9};
E := EllipticCurve([0,-1,1,-7,10]);
G := E![4,5];
R<t> := PolynomialRing(Rationals());
fK := t^5 + t^4 - 4*t^3 - 3*t^2 + 3*t + 1;
K<z> := NumberField(fK);
OK := MaximalOrder(K);
assert #ClassGroup(OK) eq 1;
cuspsK := [ [-z^4 - z^3 + 2*z^2 + 3*z + 3, -2*z^4 - 4*z^3 + 6*z^2 + 11*z + 1],
            [-z^4 + 3*z^2 - 2*z + 1, -3*z^4 + z^3 + 11*z^2 - 4*z - 2],
            [-z^4 + 5*z^2 + z - 2, 2*z^4 + 2*z^3 - 5*z^2 - 2*z + 3],
            [z^4 - z^3 - 3*z^2 + 3*z + 2, z^4 - 2*z^2 - 2*z + 1],
            [2*z^4 + 2*z^3 - 7*z^2 - 5*z + 5, 2*z^4 + z^3 - 10*z^2 - 3*z + 11] ];
rr := [1, 4, 3, 9, 5];
// basis of K(S,11)
pi11 := K!(2 - z);
assert Norm(pi11) eq 11 or Norm(pi11) eq -11;
U, mU := UnitGroup(OK);
units := [ K!mU(U.i) : i in [2..Ngens(U)] ];   // U.1 = -1
assert #units eq 4;
bas := [pi11] cat units;
printf "# basis b = [pi11, u1..u4]: %o\n", bas;

for l in [23,53,353,3301,12101,15731] do
  f := (l mod 11 eq 1) select 1 else 5;
  Fq := GF(l^f);
  Fl := GF(l);
  El := ChangeRing(E, Fl);
  Gl := El!G;
  N := Order(Gl);
  Eq := ChangeRing(E, Fq);
  rts := [ r[1] : r in Roots(PolynomialRing(Fq)!fK) ];
  if f eq 5 then rts := [rts[1]]; end if;   // one prime above l (inert); any root
  e11 := (#Fq - 1) div 11;
  zeta := PrimitiveElement(Fq)^e11;
  dl := AssociativeArray();
  for k in [0..10] do dl[zeta^k] := k; end for;
  chi := func< v | dl[v^e11] >;
  // multiples of G (over F_l, viewed in F_q)
  mults := [ Eq!(k*Gl) : k in [0..N-1] ];
  kx<x> := RationalFunctionField(Fq);
  ky<Y> := PolynomialRing(kx);
  FA<y> := FunctionField(Y^2 + Y - (x^3 - x^2 - 7*x + 10));
  Pinf := Poles(FA!x)[1];
  placeAt := function(x0, y0)
    for P in Zeros(FA!(x - x0)) do
      if Degree(P) eq 1 and Evaluate(y, P) eq y0 then return P; end if;
    end for;
    error "no place";
  end function;
  for li in [1..#rts] do
    z0 := rts[li];
    red := func< a | &+[ Fq!Eltseq(a)[k+1] * z0^k : k in [0..4] ] >;
    chib := [ chi(red(b)) : b in bas ];
    cl := [ [ red(c[1]), red(c[2]) ] : c in cuspsK ];
    clset := { c : c in cl };
    tabs := [];
    for m in [1,2,3] do
      a := [ Integers()!((rr[i]^m) mod 11) : i in [1..5] ];
      D := &+[ a[i]*placeAt(cl[i][1], cl[i][2]) : i in [1..5] ] - (&+a)*Pinf;
      ok, fm := IsPrincipal(D); assert ok;
      kappa := Evaluate(fm * (x/y)^(&+a), Pinf);
      fm := fm / kappa;          // normalise: leading coefficient 1 at O
      cf := Eltseq(fm);
      T := [];
      for k in [0..N-1] do
        P := mults[k+1];
        if P eq Eq!0 then Append(~T, 0); continue; end if;
        if [P[1],P[2]] in clset then Append(~T, -1); continue; end if;
        x0 := P[1]; y0 := P[2];
        try
          v := &+[ Evaluate(cf[i], x0) * y0^(i-1) : i in [1..#cf] ];
        catch err
          v := Evaluate(fm, placeAt(x0, y0));
        end try;
        Append(~T, chi(v));
      end for;
      Append(~tabs, T);
    end for;
    printf "L %o %o %o %o", l, N, li, f;
    for c in chib do printf " %o", c; end for;
    for m in [1,2,3] do
      printf " |";
      for v in tabs[m] do printf " %o", v; end for;
    end for;
    printf "\n";
  end for;
end for;
printf "# DONE\n";
quit;
