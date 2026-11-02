// single_place.m -- Claims O3 and E5: the Selmer arguments work at a single
// place v of F above 11, for either of the two places with v(4-theta) odd.
// Run after odd_selmer.m/odd_directions.m (PADPREC 160) and even_selmer.m,
// whose matrices it reads from data/.
//
// O3 (odd n0): the image of the Selmer bound S^+ (dimension 1) in the local
//    Kummer group at v is nonzero, and does not contain the final formal
//    direction d_v.
// E5 (even n0): the localisation of the Selmer bound at v is injective, the
//    formal line U_v does not contain mu_v(T), and
//    loc_v(Sel) meet (U_v + <mu_v(T)>) = <mu_v(T)>.
load "code/setup.m";
OF := Integers(F);
eta := conv(4-theta);
places := [pp[1] : pp in Decomposition(OF,11)];
oddPlaces := [j : j in [1..3] | IsOdd(Valuation(eta, places[j]))];
assert oddPlaces eq [1,2];
printf "valuations of 4-theta at the places above 11: %o\n", [Valuation(eta,p) : p in places];
for n0 in [-1,1,3] do
  load_file := "data/odd_formal_" cat IntegerToString(n0) cat "_p160_data.m";
  eval_str := Read(load_file);
  // the file assigns SelmerDimension, SelmerRamifiedRows, DirectionRows
  SelmerDimension := eval eval_str cat "return SelmerDimension;";
  SelmerRamifiedRows := eval eval_str cat "return SelmerRamifiedRows;";
  DirectionRows := eval eval_str cat "return DirectionRows;";
  assert SelmerDimension eq 1;
  V := VectorSpace(GF(11),22);
  for j in [1,2] do                    // the ramified places, in this order
    s := V![SelmerRamifiedRows[1][22*(j-1)+h] : h in [1..22]];
    d := V![DirectionRows[j][22*(j-1)+h] : h in [1..22]];
    assert s ne 0 and d ne 0 and Dimension(sub<V|s,d>) eq 2;
    printf "O3 n0=%o place=%o: loc_v(S+) nonzero, d_v not in loc_v(S+)\n", n0, j;
  end for;
end for;
for n0 in [-2,0,2,4] do
  load_file := "data/even_selmer_" cat (n0 lt 0 select "m" cat IntegerToString(-n0) else IntegerToString(n0)) cat ".m";
  eval_str := Read(load_file);
  SelmerLocalRows := eval eval_str cat "return SelmerLocalRows;";
  FormalRows := eval eval_str cat "return FormalRows;";
  LocalTorsionRows := eval eval_str cat "return LocalTorsionRows;";
  V := VectorSpace(GF(11),12);
  for j in oddPlaces do
    S := sub<V | [V![r[12*(j-1)+h] : h in [1..12]] : r in SelmerLocalRows]>;
    U := sub<V | V![FormalRows[j][12*(j-1)+h] : h in [1..12]]>;
    T := sub<V | V![LocalTorsionRows[j][12*(j-1)+h] : h in [1..12]]>;
    assert Dimension(S) eq #SelmerLocalRows;
    assert Dimension(U) eq 1 and Dimension(T) eq 1 and Dimension(U meet T) eq 0;
    assert (S meet (U+T)) eq T;
    printf "E5 n0=%o place=%o: dim Sel=%o, localisation injective, Sel_v cap (U_v+T_v) = T_v\n",
      n0, j, #SelmerLocalRows;
  end for;
end for;
// For comparison (not used): the third place above 11, where v(4-theta) is even.
for n0 in [-2,0,2,4] do
  load_file := "data/even_selmer_" cat (n0 lt 0 select "m" cat IntegerToString(-n0) else IntegerToString(n0)) cat ".m";
  eval_str := Read(load_file);
  SelmerLocalRows := eval eval_str cat "return SelmerLocalRows;";
  V := VectorSpace(GF(11),12);
  S := sub<V | [V![r[24+h] : h in [1..12]] : r in SelmerLocalRows]>;
  printf "THIRD_PLACE even n0=%o: dim Sel=%o, dim of its localisation=%o\n", n0, #SelmerLocalRows, Dimension(S);
end for;
printf "SINGLE_PLACE_VERIFIED\n";
quit;
