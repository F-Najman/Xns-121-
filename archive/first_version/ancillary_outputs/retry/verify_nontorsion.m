load "outputs/retry/verify_genus5.m";
torsionbounds:=[0:i in [1..7]];
sampleorders:=[[]:i in [1..7]];
for p in [199,397,419] do
 Fp:=GF(p); Rp<X>:=PolynomialRing(Fp);
 rz:=Roots(Rp!DefiningPolynomial(K));
 rt:=Roots(X^3-X^2-7*X+Fp!(41/4));
 assert #rz eq 5 and #rt eq 3;
 z0:=rz[1][1]; t0:=rt[1][1];
 printf "RESIDUE_EMBEDDING p=%o z=%o theta=%o\n",p,z0,t0;
 redK:=func<a | &+[Fp!Eltseq(K!a)[j+1]*z0^j:j in [0..4]]>;
 redL:=func<a | &+[redK(Eltseq(L!a)[j+1])*t0^j:j in [0..2]]>;
 for i in [1..7] do
  f:=HyperellipticPolynomials(Genus5Curves[i]);
  fp:=Rp![redL(a):a in Coefficients(f)];
  assert GCD(fp,Derivative(fp)) eq 1 and Degree(fp) eq 11;
  C:=HyperellipticCurve(fp); J:=Jacobian(C);
  N:=Integers()!Evaluate(EulerFactor(J),1);
  P:=J![X-1,Rp!redL(KnownV[i])];
  assert N*P eq J!0;
  o:=N;
  for a in Factorisation(N) do
   for j in [1..a[2]] do
    if (o div a[1])*P eq J!0 then o div:=a[1]; else break; end if;
   end for;
  end for;
  Append(~sampleorders[i],o);
  torsionbounds[i]:=GCD(torsionbounds[i],N);
  printf "p=%o n=%o #J=%o order(P)=%o gcd(#J)=%o\n",p,i-3,N,o,torsionbounds[i];
 end for;
end for;
printf "CM_TORSION_BOUNDS %o\n",torsionbounds;
printf "CM_POINT_ORDERS %o\n",sampleorders;
for i in [1..7] do
 assert exists{o:o in sampleorders[i]|torsionbounds[i] mod o ne 0};
end for;
printf "ALL_SEVEN_KNOWN_DIVISORS_HAVE_INFINITE_ORDER\n";
quit;
