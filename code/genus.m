// genus.m -- Claim G1: X_ns^+(121) has genus 511 (index 6655, 55 cusps).
// Computed from the action of SL_2(Z) on GL_2(Z/121)/N_ns(121).
SetColumns(0);
R := Integers(121);
GL2 := GL(2,R);
eps := 2;                                         // non-square mod 11
assert not IsSquare(GF(11)!eps);
SetSeed(1);
Cns := [GL2![a,eps*b,b,a] : a,b in [0..120] | GCD(a^2-eps*b^2,121) eq 1];
assert #Cns eq 121^2-121;
gens := [Random(Cns) : i in [1..6]];
H := sub<GL2 | gens cat [GL2![1,0,0,-1]]>;
assert &and[g in H : g in Cns];
assert #H eq 2*(121^2-121);
idx := #GL2 div #H;
assert idx eq 6655;
f, Img := CosetAction(GL2, H);
S := f(GL2![0,-1,1,0]); T := f(GL2![1,1,0,1]);
fix := func< g | #[x : x in [1..idx] | x^g eq x] >;
nu2 := fix(S); nu3 := fix(S*T); cusps := #Orbits(sub<Img|T>);
g := 1 + idx/12 - nu2/4 - nu3/3 - cusps/2;
printf "G1 index=%o nu2=%o nu3=%o cusps=%o genus=%o\n", idx, nu2, nu3, cusps, g;
assert g eq 511 and cusps eq 55;
quit;
