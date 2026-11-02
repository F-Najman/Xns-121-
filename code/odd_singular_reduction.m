SetColumns(0);
load "code/setup.m";
eta:=conv(4-theta);
for pp in Decomposition(F,11) do
 kv,toKV:=Completion(F,pp[1]:Precision:=100);
 O:=Integers(kv); ff,red:=ResidueClassField(O);
 ee:=toKV(eta);
 assert not IsSquare(ee);
 ve:=Valuation(ee); assert ve in [5,10];
 relativeE:=IsOdd(ve) select 2 else 1;
 printf "ODD_BRANCH_EXTENSION v(eta)=%o relative_ramification=%o relative_residue_degree=%o\n",ve,relativeE,2 div relativeE;
 for i in [2,4,6] do
  a:=conv(Deltas[i]/(L!alpha-theta));
  // After adjoining sqrt(eta), the model is Y^2=X^11+a^10.
  ySquared:=a^10*eta*conv(KnownV[i]/beta)^2;
  assert ySquared eq a^11+a^10;
  assert red(O!toKV(a)) eq -1;
  vy2:=Valuation(toKV(ySquared));
  assert relativeE*vy2 eq 2;
  printf "ODD_POINT n=%o Xbar=-1 Ybar=0 v_B(Y)=1\n",i-3;
 end for;
end for;
printf "ODD_SINGULAR_REDUCTION_VERIFIED\n";
quit;
