// even_selmer.m -- lambda-Selmer data for the even classes n0 in {-2,0,2,4},
// using only public Magma intrinsics (pSelmerGroup, Completion, IsSquare).
// This replaces the draft's run of a locally patched copy of Magma's
// PicnDescent package; the two computations are compared in the README.
//
// Curve: C : Y^2 = X^11 + b^2 over F, b = a^5, a = delta_{n0}/(alpha-theta).
// lambda = 1 - sigma, sigma(X,Y) = (zeta X, Y);  J[lambda] = <T>,
// T = [(0,b) - oo].  Kummer map: D |-> (Y-b)(D) in F^*/F^*11, with value 1
// at oo (Y-b has leading coefficient 1 at oo); mu(T) = 1/(2b).
//
// Claims (n0 even):
//  E1  F(S,11) has dimension 19 (S = primes above 2 and 11; Cl(F)[11]=0 by
//      Odlyzko), and 19 explicit classes have independent images at 11,
//      so they form a basis (GRH only used to find them).
//  E2  at each v|11 the image of J(F_v)/lambda has dimension 6 and is
//      spanned by explicit points; at w|2 it is spanned by mu_w(T) (dim 1).
//  E3  the Selmer upper bound Sel (conditions at 11, and at 2) contains
//      mu(P0) and mu(T); its localisation at 11 is injective;
//      U cap Tloc = 0 and Sel_11 cap (U + Tloc) = Tglob.
//  E4  the residues a = 8, Y0 <> 0, b^2 = 1 mod v at all v|11.
//
// Usage: magma -b NN:=0 code/even_selmer.m   (NN in {-2,0,2,4})
SetMemoryLimit(16*10^9);
load "code/setup.m";
if not assigned NN then NN := 0; elif Type(NN) eq MonStgElt then NN := StringToInteger(NN); end if;
if not assigned PREC then PREC := 160; elif Type(PREC) eq MonStgElt then PREC := StringToInteger(PREC); end if;
if not assigned SEED then SEED := 1; elif Type(SEED) eq MonStgElt then SEED := StringToInteger(SEED); end if;
SetSeed(SEED);
assert NN in [-2,0,2,4];
idx := NN+3;
OF := Integers(F);
a := conv(Deltas[idx]/(L!alpha-theta));
b := a^5;
Y0 := a^5*conv(KnownV[idx]/beta);
assert Y0^2 eq a^11 + b^2;                 // the known point P0 = (a,Y0)
S2 := [pp[1] : pp in Decomposition(OF,2)];
S11 := [pp[1] : pp in Decomposition(OF,11)];
assert #S2 eq 1 and #S11 eq 3;
// Cl(F)[11]=0 (unconditional): root discriminant of F is < 19, and by
// Odlyzko's Table 4 (b=9) every field of degree >= 330 has rd > 19.
assert 2^20*11^27 lt 19^30;
assert 20710*(330000-24001) gt 19000*330000;

// ---------- local fields
LocalData := [* *];
for v in S11 cat S2 do
  kv0, mv := Completion(F, v : Precision := 3*PREC+40);
  kv0`DefaultPrecision := 3*PREC+40;
  g0 := ChangePrecision(mv(F.1), 3*PREC+40);
  kv := ChangePrecision(kv0, PREC);
  locv := func< c | kv!Evaluate(Polynomial(Eltseq(F!c)), g0) >;
  GG, muv := pSelmerGroup(11, kv);
  Append(~LocalData, <kv, locv, GG, muv>);
end for;
nloc := [Ngens(D[3]) : D in LocalData];
assert nloc eq [12,12,12,2];
dimLoc := &+nloc;
Vall := VectorSpace(GF(11), dimLoc);
offs := [0, 12, 24, 36];
locRow := function(c)
  row := [];
  for j in [1..4] do
    D := LocalData[j]; cc := D[2](c);
    assert RelativePrecision(cc) ge 2*Valuation(D[1]!11)+2;
    row cat:= Eltseq(D[4](cc));
  end for;
  return Vall!row;
end function;
embed := func< j, w | Vall!([0 : h in [1..offs[j]]] cat Eltseq(w) cat [0 : h in [offs[j]+nloc[j]+1..dimLoc]]) >;

// ---------- E1: global F(S,11)
SetClassGroupBounds("GRH");
time GS, mm, toVec, baseUnits := pSelmerGroup(11, Seqset(S2 cat S11) : Raw);
assert Ngens(GS) eq 19;
GlobalSpace := sub<Vall|>; GlobalReps := [];
for jj in [1..Ngens(GS)] do
  exps := Eltseq(toVec(GS.jj));
  elt := &*[F | F!baseUnits[h]^(exps[h] mod 11) : h in [1..#exps]];
  for pe in Factorisation(elt*OF) do
    assert pe[2] mod 11 eq 0 or pe[1] in S2 cat S11;
  end for;
  r := locRow(elt);
  GlobalSpace := sub<Vall | GlobalSpace, r>;
  Append(~GlobalReps, elt);
end for;
assert Dimension(GlobalSpace) eq 19;
V36 := VectorSpace(GF(11),36);
proj11 := hom< Vall -> V36 | [V36.h : h in [1..36]] cat [V36!0, V36!0] >;
assert Dimension(proj11(GlobalSpace)) eq 19;
printf "E1 n0=%o GLOBAL_BASIS_CERTIFIED dim F(S,11)=19, injective at 11\n", NN;

// ---------- E2: local images
muT := locRow(1/(2*b));
images := [];
for j in [1..3] do
  D := LocalData[j]; kv := D[1]; locv := D[2]; muv := D[4];
  Ov := Integers(kv); res, red := ResidueClassField(Ov);
  pv := UniformizingElement(kv);
  bv := locv(b);
  VV := VectorSpace(GF(11), 12);
  img := sub<VV | VV![Eltseq(muT)[offs[j]+h] : h in [1..12]]>;
  attempts := 0;
  while Dimension(img) lt 6 and attempts lt 3000 do
    attempts +:= 1;
    vx := [-2,0,1,2][1 + (attempts mod 4)];
    xx := pv^vx * &+[kv | (Random(res)@@red)*pv^h : h in [0..20]];
    if Valuation(xx) ne vx then continue; end if;
    rhs := xx^11 + bv^2;
    if IsWeaklyZero(rhs) then continue; end if;
    ok, yy := IsSquare(rhs); if not ok then continue; end if;
    for sg in [1,-1] do
      w := sg*yy - bv;
      if IsWeaklyZero(w) or RelativePrecision(w) lt 2*Valuation(kv!11)+2 then continue; end if;
      img := sub<VV | img, VV!Eltseq(muv(w))>;
      assert Dimension(img) le 6;
    end for;
  end while;
  assert Dimension(img) eq 6;
  printf "E2 n0=%o place=%o local image dimension=6 after %o attempts\n", NN, j, attempts;
  Append(~images, img);
end for;
// 2-adic place: the image has order #J[lambda](F_w)=11 and contains mu_w(T)
muT2 := VectorSpace(GF(11),2)![Eltseq(muT)[36+h] : h in [1..2]];
assert muT2 ne 0;
image2 := sub<VectorSpace(GF(11),2) | muT2>;
printf "E2 n0=%o place=2-adic local image = <mu(T)>, dimension 1\n", NN;

// ---------- E3: Selmer bounds
localSpace := sub<Vall | &cat[[embed(j, w) : w in Basis(images[j])] : j in [1..3]] cat [embed(4,w) : w in Basis(image2)]>;
localSpaceNo2 := sub<Vall | &cat[[embed(j, w) : w in Basis(images[j])] : j in [1..3]] cat [Vall.(36+h) : h in [1..2]]>;
Sel := GlobalSpace meet localSpace;
SelNo2 := GlobalSpace meet localSpaceNo2;
muP0 := locRow(Y0 - b);
assert muP0 in Sel and muT in Sel;
assert muP0 notin sub<Vall|muT>;
Sel11 := proj11(Sel);
assert Dimension(Sel11) eq Dimension(Sel);
printf "E3 n0=%o dim Sel(with 2)=%o dim Sel(without 2)=%o; localisation at 11 injective\n",
  NN, Dimension(Sel), Dimension(SelNo2);
// formal lines: displacement at the section through (0,-b)
Urows := []; Trows := [];
for j in [1..3] do
  D := LocalData[j]; kv := D[1]; locv := D[2]; muv := D[4];
  Ov := Integers(kv); res, red := ResidueClassField(Ov);
  piv := locv(1 - zetaF);
  assert Valuation(piv) eq 1 and #res eq 11 and Valuation(kv!11) eq 10;
  bv := locv(b);
  ys := [];
  for xx in [piv, 2*piv] do
    ok, yy := IsSquare(xx^11 + bv^2); assert ok;
    if Valuation(yy + bv) eq 0 then yy := -yy; end if;      // branch Y = -b
    Append(~ys, yy);
  end for;
  uline := muv((ys[2]-bv)/(ys[1]-bv));
  assert uline ne Parent(uline)!0;
  // it is the class of 1 + pi^11 c (the unramified Kummer line)
  assert sub<D[3] | uline> eq sub<D[3] | muv(1 + piv^11)>;
  assert VectorSpace(GF(11),12)!Eltseq(uline) in images[j];
  Append(~Urows, V36!([0 : h in [1..offs[j]]] cat Eltseq(uline) cat [0 : h in [offs[j]+13..36]]));
  Append(~Trows, V36!([0 : h in [1..offs[j]]] cat [Eltseq(muT)[offs[j]+h] : h in [1..12]] cat [0 : h in [offs[j]+13..36]]));
  // E4: residues
  assert red(Ov!locv(a)) eq 8 and red(Ov!locv(b)^2) eq 1 and Valuation(locv(Y0)) eq 0;
  printf "E4 n0=%o place=%o a=8 b^2=1 Y0=%o mu(T) nonzero=%o\n", NN, j, red(Ov!locv(Y0)), Trows[j] ne 0;
end for;
UU := sub<V36 | Urows>; TT := sub<V36 | Trows>; Tglob := sub<V36 | &+Trows>;
assert Dimension(UU) eq 3 and Dimension(TT) eq 3;
assert Dimension(UU meet TT) eq 0;
assert (Sel11 meet (UU + TT)) eq Tglob;
SelNo2_11 := proj11(SelNo2);
assert Sel eq SelNo2;          // the condition at 2 imposes nothing new
printf "E3 n0=%o U cap Tloc = 0, Sel cap (U+Tloc) = Tglob; without the 2-adic condition: injective=%o, intersection=Tglob: %o\n",
  NN, Dimension(SelNo2_11) eq Dimension(SelNo2), (SelNo2_11 meet (UU+TT)) eq Tglob;
// save the matrices
out := "data/even_selmer_" cat (NN lt 0 select "m" cat IntegerToString(-NN) else IntegerToString(NN)) cat ".m";
// Selmer bound with local conditions at the places above 11 only
Write(out, "SelmerLocalRows := " cat Sprint([Eltseq(w) : w in Basis(SelNo2_11)]) cat ";" : Overwrite := true);
Write(out, "FormalRows := " cat Sprint([Eltseq(w) : w in Urows]) cat ";");
Write(out, "LocalTorsionRows := " cat Sprint([Eltseq(w) : w in Trows]) cat ";");
Write(out, "KnownPointRow := " cat Sprint(Eltseq(proj11(muP0))) cat ";");
printf "EVEN_SELMER_DONE n0=%o dimSel=%o\n", NN, Dimension(Sel);
quit;
