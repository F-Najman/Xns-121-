// 08_cm_delta.m -- exact descent classes delta_m(nG) in K(S,11) for the CM points n = -2..4,
// to cross-check the classes inferred by the sieve (code/07_sieve.py) from local data.
// f_m: divisor sum_i a_i [c_i] - (sum a_i)[O], a_i = r_i^m mod 11, normalised by f_m*(x/y)^(sum a) = 1 at O.
// Run from /home/fnajman/121:  magma -b code/08_cm_delta.m < /dev/null > logs/08_cm_delta.log 2>&1
SetColumns(0);
SetMemoryLimit(40*10^9);
E := EllipticCurve([0,-1,1,-7,10]);
G := E![4,5];
R<t> := PolynomialRing(Rationals());
fK := t^5 + t^4 - 4*t^3 - 3*t^2 + 3*t + 1;
K<z> := NumberField(fK);
OK := MaximalOrder(K);
cuspsK := [ [-z^4 - z^3 + 2*z^2 + 3*z + 3, -2*z^4 - 4*z^3 + 6*z^2 + 11*z + 1],
            [-z^4 + 3*z^2 - 2*z + 1, -3*z^4 + z^3 + 11*z^2 - 4*z - 2],
            [-z^4 + 5*z^2 + z - 2, 2*z^4 + 2*z^3 - 5*z^2 - 2*z + 3],
            [z^4 - z^3 - 3*z^2 + 3*z + 2, z^4 - 2*z^2 - 2*z + 1],
            [2*z^4 + 2*z^3 - 7*z^2 - 5*z + 5, 2*z^4 + z^3 - 10*z^2 - 3*z + 11] ];
rr := [1, 4, 3, 9, 5];
pi11 := K!(2 - z);
U, mU := UnitGroup(OK);
units := [ K!mU(U.i) : i in [2..Ngens(U)] ];
bas := [pi11] cat units;
p11 := Factorization(11*OK)[1][1];

kx<x> := RationalFunctionField(K);
ky<Y> := PolynomialRing(kx);
FA<y> := FunctionField(Y^2 + Y - (x^3 - x^2 - 7*x + 10));
Pinf := Poles(FA!x)[1];
placeAt := function(x0, y0)
  for P in Zeros(FA!(x - x0)) do
    if Degree(P) eq 1 and Evaluate(y, P) eq y0 then return P; end if;
  end for;
  error "no place";
end function;

// class of an element alpha of K^x in K(S,11), S = {p11}, w.r.t. bas; returns exponent vector mod 11
// (asserts that alpha is an S-unit times an 11th power)
classS := function(alpha)
  I := alpha*OK;
  fac := Factorization(I);
  e0 := 0;
  J := 1*OK;
  for pr in fac do
    if pr[1] eq p11 then e0 := pr[2];
    else
      assert pr[2] mod 11 eq 0;
      J := J * pr[1]^(pr[2] div 11);
    end if;
  end for;
  ok, beta := IsPrincipal(J); assert ok;
  u := alpha / (pi11^e0 * (K!beta)^11);
  assert IsUnit(OK!u);
  v := Eltseq((mU^-1)(OK!u));   // coordinates: [torsion, u1..u4]
  return [e0 mod 11] cat [ v[i] mod 11 : i in [2..5] ];
end function;

for m in [1,2,3] do
  a := [ Integers()!((rr[i]^m) mod 11) : i in [1..5] ];
  D := &+[ a[i]*placeAt(cuspsK[i][1], cuspsK[i][2]) : i in [1..5] ] - (&+a)*Pinf;
  ok, fm := IsPrincipal(D); assert ok;
  kappa := Evaluate(fm * (x/y)^(&+a), Pinf);
  fm := fm / kappa;
  for n in [-2..4] do
    if n eq 0 then printf "m=%o n=0: delta = 0 (normalisation)\n", m; continue; end if;
    P := n*G;
    v := Evaluate(fm, placeAt(K!P[1], K!P[2]));
    printf "m=%o n=%o: delta exponents (pi11,u1..u4) = %o\n", m, n, classS(v);
  end for;
end for;
quit;
