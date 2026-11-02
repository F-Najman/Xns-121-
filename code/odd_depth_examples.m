// Numerical checks of the valuation formula at actual nearby E(Q) images.
// These supplement, rather than replace, the all-k proof in the report.
SetColumns(0);
load "code/setup.m";
zeta:=Roots(PolynomialRing(F)!CyclotomicPolynomial(11))[1][1];
eta:=conv(4-theta);
placeIndex:=0;
for pp in Decomposition(Integers(F),11) do
 placeIndex+:=1;
 kv0,mv:=Completion(F,pp[1]:Precision:=1000);
 kv0`DefaultPrecision:=1000;
 fg:=ChangePrecision(mv(F.1),1000);
 loc0:=func<a|Evaluate(Polynomial(Eltseq(F!a)),fg)>;
 ee0:=loc0(eta); pi0:=loc0(1-zeta);
 if IsEven(Valuation(ee0)) then continue; end if;
 // The elliptic group law in this nonminimal equation loses many digits
 // during repeated doubling; retain ample precision before taking roots.
 kv:=ChangePrecision(kv0,400); lf:=func<a|kv!loc0(a)>;
 pi:=lf(1-zeta);
 PP<T>:=PolynomialRing(kv);
 bv<rho>:=TotallyRamifiedExtension(kv,T^2-kv!(ee0/pi0^4));
 rootEta:=rho*(bv!pi)^2; piB:=rho;
 residue,red:=ResidueClassField(Integers(bv));
 Ek:=EllipticCurve([kv|0,-1,1,-7,10]); Gk:=Ek![4,5];
 sk:=Ek![lf(conv(L!s[1])),lf(conv(L!s[2]))];
 for n0 in [-1,1,3] do
  idx:=n0+3; aa:=lf(conv(Deltas[idx]/(L!alpha-theta)));
  Y0:=rootEta*(bv!(aa^5*lf(conv(KnownV[idx]/beta))));
  assert Valuation(Y0) eq 1;
  for k in [2,3] do
   step:=4356*11^(k-2);
   q:=(n0+step)*Gk-3*sk;
   value:=(q[1]-lf(conv(L!alpha)))/lf(conv(L!Deltas[idx]));
   ww:=Exp(Log(value)/11);
   assert Valuation(ww-1) eq 10*k-6;
   printf "DEPTH_EXAMPLE_PRECISION n0=%o k=%o value=%o w=%o error_valuation=%o\n", n0,k,AbsolutePrecision(value),AbsolutePrecision(ww),Valuation(ww^11-value);
   assert Valuation(ww^11-value) ge 120;
   dx:=bv!(aa*(ww-1));
   assert Valuation(dx) eq 20*k-12;
   divisions:=10*k-7;
   leading:=[dx*(bv!aa)^(j-1)/(2*Y0*(bv!lf(1-zeta^j))^divisions*piB):j in [1..5]];
   assert &and[Valuation(v) eq 0:v in leading];
   direction:=[red(Integers(bv)!(v/leading[1])):v in leading];
   assert direction eq [residue!((-1)^(j-1))/(residue!j)^3:j in [1..5]];
   printf "LOCAL_DEPTH_EXAMPLE n0=%o place=%o k=%o depth_X=%o divisions=%o direction=%o\n",
    n0,placeIndex,k,Valuation(dx),divisions,direction;
  end for;
 end for;
end for;
printf "ALL_ODD_LOCAL_DEPTH_EXAMPLES_VERIFIED\n";
quit;
