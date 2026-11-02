// Run after compute_selmer.m in the same Magma process. Even cases only.
assert IsEven(NN);
SelLocalMatrices:=[]; FormalRows:=[]; TorsionRows:=[];
localSizes:=[]; goodIndices:=[]; formalVectors:=[]; torsionVectors:=[];
torsionGen:=Gglob!OrderedGenerators(mt)[1];
for j in [1..#S] do
 if Norm(S[j]) mod 11 ne 0 then continue; end if;
 Append(~goodIndices,j);
 kv:=Codomain(completions[j][1]); mapToKV:=completions[j][1];
 kv`DefaultPrecision:=160;
 kg:=ChangePrecision(mapToKV(F.1),160);
 loc:=func<a|Evaluate(Polynomial(Eltseq(F!a)),kg)>;
 pi:=ChangePrecision(UniformizingElement(kv),160);
 bb:=loc(c0^5); assert Valuation(bb) eq 0;
 // A point near the negative branch point has descent coordinate Y-b
 // a unit, and produces the unramified Kummer line.
 xx:=pi; yes,yy:=IsSquare(xx^11+bb^2); assert yes;
 if Valuation(yy+bb) eq 0 then yy:=-yy; end if;
 xx1:=2*pi; yes,yy1:=IsSquare(xx1^11+bb^2); assert yes;
 if Valuation(yy1+bb) eq 0 then yy1:=-yy1; end if;
 assert RelativePrecision(yy+bb) gt 30 and RelativePrecision(yy1+bb) gt 30;
 // Lift finite-precision local elements to representatives in F.
 ylift:=yy@@mapToKV; ylift1:=yy1@@mapToKV;
 aa:=(A!ylift1-A.1)/(A!ylift-A.1);
 fv:=muLocals[j](aa);
 assert fv ne Parent(fv)!0;
 tv:=restrictions[j](torsionGen);
 printf "LOCAL_FORMAL_LINE prime_index=%o dimension=1 torsion_image_nonzero=%o\n",j,tv ne Parent(tv)!0;
 Append(~formalVectors,Eltseq(fv)); Append(~torsionVectors,Eltseq(tv));
 Append(~localSizes,#Eltseq(fv));
 Append(~SelLocalMatrices,[Eltseq(restrictions[j](Gglob!a)):a in OrderedGenerators(SJ)]);
 // Residues needed for the leading formal-log calculation.
 O:=Integers(kv); FF,red:=ResidueClassField(O);
 xbar:=red(O!loc(X0)); ybar:=red(O!loc(Y0));
 printf "KNOWN_POINT_RESIDUE prime_index=%o X=%o Y=%o\n",j,xbar,ybar;
end for;
ambientDimension:=&+localSizes; VV:=VectorSpace(GF(11),ambientDimension);
selRows:=[&cat[SelLocalMatrices[j][i]:j in [1..#goodIndices]]:i in [1..Ngens(SJ)]];
SelLoc:=sub<VV|[VV!r:r in selRows]>;
for j in [1..#goodIndices] do
 fr:=[];tr:=[];
 for k in [1..#goodIndices] do
  fr cat:=k eq j select formalVectors[j] else [0:l in [1..localSizes[k]]];
  tr cat:=k eq j select torsionVectors[j] else [0:l in [1..localSizes[k]]];
 end for;
 Append(~FormalRows,VV!fr); Append(~TorsionRows,VV!tr);
end for;
UU:=sub<VV|FormalRows>; TT:=sub<VV|TorsionRows>;
globalTorsion:=sub<VV|&+TorsionRows>;
assert Dimension(UU meet TT) eq 0;
assert (SelLoc meet (UU+TT)) eq globalTorsion;
printf "SELMER_DIM=%o FORMAL_DIM=%o LOCAL_TORSION_DIM=%o\n",Dimension(SelLoc),Dimension(UU),Dimension(TT);
printf "SELMER_INTERSECT_FORMAL_DIM=%o\n",Dimension(SelLoc meet UU);
printf "SELMER_INTERSECT_LOCAL_TORSION_DIM=%o\n",Dimension(SelLoc meet TT);
printf "SELMER_INTERSECT_FORMAL_PLUS_TORSION_DIM=%o\n",Dimension(SelLoc meet (UU+TT));
out2:="outputs/continuation/formal_" cat TAG cat "_data.m";
Write(out2,"SelmerLocalRows := " cat Sprint(selRows) cat ";\n" : Overwrite:=true);
Write(out2,"FormalRows := " cat Sprint([Eltseq(v):v in FormalRows]) cat ";\n");
Write(out2,"LocalTorsionRows := " cat Sprint([Eltseq(v):v in TorsionRows]) cat ";\n");
printf "FORMAL_INTERSECTION_TEST_DONE\n";
quit;
