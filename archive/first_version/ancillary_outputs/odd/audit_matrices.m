// Read a selmer_*_data.m followed by its formal_*_data.m before this file.
SetColumns(0);
ff:=GF(11); VV:=VectorSpace(ff,66); WW:=VectorSpace(ff,22);
globalSpace:=sub<VV|[VV!r:r in GlobalRows]>;
assert Dimension(globalSpace) eq 15;
localSpaces:=[sub<WW|[WW!r:r in rows]>:rows in LocalImageRows];
assert [Dimension(sp):sp in localSpaces] eq [5,5,5];
reconstructed:=globalSpace;
for j in [1..3] do
 constraint:=sub<VV|[VV.h:h in [1..66]|h le 22*(j-1) or h gt 22*j] cat
  [VV!([0:h in [1..22*(j-1)]] cat Eltseq(rr) cat [0:h in [1..22*(3-j)]]):rr in Basis(localSpaces[j])]>;
 reconstructed:=reconstructed meet constraint;
end for;
assert reconstructed eq sub<VV|[VV!r:r in SelmerRows]>;
assert Dimension(reconstructed) eq SelmerDimension and SelmerDimension eq 1;
assert VV!KnownPointImage in reconstructed and VV!KnownPointImage ne VV!0;
// In both completed runs, places 1 and 2 are the ramified places.
VR:=VectorSpace(ff,44);
ramified:=sub<VR|[VR!Eltseq(r)[1..44]:r in Basis(reconstructed)]>;
assert ramified eq sub<VR|[VR!r:r in SelmerRamifiedRows]>;
assert Dimension(ramified) eq SelmerDimension;
directions:=sub<VR|[VR!r:r in DirectionRows]>;
assert Dimension(directions) eq 2;
assert Dimension(ramified meet directions) eq 0;
assert WW!DirectionRows[1][1..22] in localSpaces[1];
assert WW!DirectionRows[2][23..44] in localSpaces[2];
assert &and[a eq 0:a in DirectionRows[1][23..44]];
assert &and[a eq 0:a in DirectionRows[2][1..22]];
printf "ODD_MATRIX_AUDIT_PASSED global_dim=15 local_dims=5,5,5 selmer_dim=1 ramified_kernel=0 direction_intersection=0\n";
quit;
