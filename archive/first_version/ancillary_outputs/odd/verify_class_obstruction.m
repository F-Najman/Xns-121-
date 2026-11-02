// Odlyzko, Table 4, b=9: A=53.047, B=20.710, E=24.001.
// For every degree n>=330 field, rd > 20.710 exp(-24.001/n) > 19.
// A degree-11 unramified extension of a field of degree >=30 and rd<19
// is therefore impossible. This proves trivial 11-primary class group.
SetColumns(0);
load "outputs/retry/verify_genus5.m";
assert 20710*(330000-24001) gt 19000*330000;
assert 53047 gt 20710;
BB:=AbsoluteField(B);
assert Degree(BB) eq 60;
assert Abs(Discriminant(Integers(BB))) eq 2^60*11^56;
assert 2^60*11^56 lt 19^60;
assert 2^20*11^27 lt 19^30;
for twist in [1,-11] do
 PP<t>:=PolynomialRing(LS);
 Jrel:=NumberField(t^2-twist*toLS(LA!(4-theta)));
 JJ:=AbsoluteField(Jrel);
 DD:=Abs(Discriminant(Integers(JJ)));
 assert DD eq 2^30*11^(twist eq 1 select 28 else 27);
 assert DD lt 19^30;
 printf "ODLYZKO_11_CLASS_OBSTRUCTION twist=%o degree=30 discriminant=%o\n",twist,Factorisation(DD);
end for;
printf "ODLYZKO_11_CLASS_OBSTRUCTION F_degree=30 B_degree=60; all root discriminants <19; unramified degree-11 extensions excluded unconditionally\n";
quit;
