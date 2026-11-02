SetColumns(0);
load "code/setup.m";
pk:=Decomposition(K,11)[1][1]; u:=2-z;
assert Valuation(u,pk) eq 1;
Emin:=EllipticCurve([K|0,11/u^2,0,33/u^4,121/(4*u^6)]);
assert Valuation(Discriminant(Emin),pk) eq 3;
T2:=-((2*G)[1]-4)*u/((2*G)[2]+1/2);
assert T2 eq 4*u;
for i in [1,3,5,7] do
 n0:=i-3; q0:=n0*G-3*s;
 assert Valuation(q0[1]-4,pk) eq 2;
 assert Valuation(q0[2]+1/2,pk) eq 3;
 assert Valuation(Deltas[i],pk) eq 2;
 r0:=(n0 div 2)*GL+4*sL;
 r0K:=(n0 div 2)*G+4*s;
 assert Valuation((r0K[1]-4)/u^2,pk) ge 0;
 assert Valuation((r0K[2]+1/2)/u^3,pk) ge 0;
 vcanonical:=((r0[1]-theta)^2-(3*theta^2-2*theta-7))/(2*r0[2]+1);
 assert vcanonical eq KnownV[i];
 // On a translate by a formal point of depth at least 22 over F_v,
 // these bounds force the canonical square root to keep its local sign.
 for pp in Decomposition(F,11) do
  vx:=Valuation(conv(r0[1]-theta),pp[1]);
  vd:=Valuation(conv(2*r0[2]+1),pp[1]);
  vv:=Valuation(conv(KnownV[i]),pp[1]);
  assert vx ge 4 and vx le 6 and vd le 8 and vv eq 2;
  assert 22+4+vx-vd-vv ge 20;
  assert 22+6-vd ge 20;
 end for;
 printf "EVEN_GEOMETRY n=%o v(x(q0)-4)=2 v(y(q0)+1/2)=3 v(delta)=2; canonical square root verified\n",n0;
end for;
ff:=GF(11); RR<X>:=PolynomialRing(ff);
ell:=&*[X-ff!a:a in [2,3,4,8]];
ell/:=Evaluate(ell,0);
weights:=Coefficients(ell);
assert weights eq [ff|1,2,2,1,9];
assert &+[weights[j]*ff!8^(j-1)/(ff!j):j in [1..5]] eq 5;
printf "LAGRANGE_WEIGHTS=%o H_1(8)=5\n",weights;
zeta:=Roots(PolynomialRing(F)!CyclotomicPolynomial(11))[1][1];
for pp in Decomposition(F,11) do
 kv,toKV:=Completion(F,pp[1]:Precision:=100);
 kg:=ChangePrecision(toKV(F.1),100);
 loc:=func<a|Evaluate(Polynomial(Eltseq(F!a)),kg)>;
 pi:=1-loc(zeta); assert Valuation(pi) eq 1;
 O:=Integers(kv); ff,red:=ResidueClassField(O);
 assert #ff eq 11 and Valuation(kv!11) eq 10;
 assert red(O!(11/pi^10)) eq -1;
 for i in [1,3,5,7] do
  aa:=loc(conv(Deltas[i]/(L!alpha-theta)));
  bb:=aa^5; yp:=aa^5*loc(conv(KnownV[i]/beta));
  assert red(O!aa) eq 8 and Valuation(yp) eq 0;
  printf "EVEN_POINT_REDUCTION n=%o X=8 Y=%o\n",i-3,red(O!yp);
 end for;
 aa:=loc(conv(Deltas[3]/(L!alpha-theta))); bb:=aa^5;
 for r in [0,2,3,4,8] do
  xx:=kv!r;
  yes,yy:=IsSquare(xx^11+bb^2); assert yes;
  if r eq 0 then yy:=-bb; end if;
  yes,yy1:=IsSquare((xx+pi)^11+bb^2); assert yes;
  if Valuation(yy1-yy) eq 0 then yy1:=-yy1; end if;
  ratio:=(yy1-bb)/(yy-bb);
  assert Valuation(ratio-1) ge 11;
  coef:=red(O!((ratio-1)/pi^11));
  assert coef eq (r eq 0 select 1/(4*red(O!bb)^2) else ff!0);
 end for;
end for;
printf "EVEN_BRANCH_FORMAL_INPUTS_VERIFIED\n";
quit;
