// Run after odd_selmer.m in the same process.
// The odd rational-image locus has final direction (-1)^(j-1)/j^3.
ramifiedIndices:=[j:j in [1..3]|Locals[j][8] eq 2];
assert #ramifiedIndices eq 2;
Vram:=VectorSpace(GF(11),44);
for ii in [1..3] do
 n0:=[-1,1,3][ii]; idx:=n0+3;
 a:=conv(Deltas[idx]/(L!alpha-theta)); b0:=a^5;
 directionRows:=[];
 for j in ramifiedIndices do
  loc:=Locals[j]; kv:=loc[1]; bv:=loc[2]; lf:=loc[3]; mu:=loc[5];
  pi:=loc[7]; piB:=loc[6]/(bv!pi)^2;
  assert Valuation(piB) eq 1;
  assert Valuation(loc[9](piB)+piB) ge PADPREC-15;
  bb:=lf(b0); ff,red:=ResidueClassField(Integers(kv));
  assert #ff eq 11;
  residues:=[0,2,3,4,8]; ybases:=[];
  for xx in residues do
   ok,yy:=IsSquare((kv!xx)^11+bb^2); assert ok;
   if xx eq 0 then yy:=-bb; end if;
   Append(~ybases,yy);
  end for;
  tangentMatrix:=Matrix(ff,[[(ff!residues[k])^(h-1)/(2*red(Integers(kv)!ybases[k])):h in [1..5]]:k in [1..5]]);
  target:=Vector(ff,[ff!((-1)^(h-1))/(ff!h)^3:h in [1..5]]);
  shifts:=Solution(tangentMatrix,target);
  image:=Codomain(mu)!0;
  for k in [1..5] do
   xx:=bv!residues[k]; dx:=piB*(bv!(Integers()!shifts[k]));
   ybase:=bv!ybases[k]; bbb:=bv!bb;
   ok,yp:=IsSquare((xx+dx)^11+bbb^2); assert ok;
   ok,ym:=IsSquare((xx-dx)^11+bbb^2); assert ok;
   if Valuation(yp-ybase) eq 0 then yp:=-yp; end if;
   if Valuation(ym-ybase) eq 0 then ym:=-ym; end if;
   assert RelativePrecision(yp-bbb) ge 2*Valuation(bv!11)+2;
   assert RelativePrecision(ym-bbb) ge 2*Valuation(bv!11)+2;
   image+:=6*(mu(yp-bbb)-mu(ym-bbb));
  end for;
  VV:=VectorSpace(GF(11),22); imageVector:=VV!Eltseq(image);
  assert imageVector ne VV!0;
  assert imageVector in allLocalImages[ii][j];
  Append(~directionRows,Eltseq(imageVector));
  printf "ODD_FORMAL_DIRECTION n=%o place=%o nonzero=true exponent_mod_10=3\n",n0,j;
 end for;
 sel:=allSelmerSpaces[ii];
 selRamRows:=[&cat[Eltseq(v)[22*(j-1)+1..22*j]:j in ramifiedIndices]:v in Basis(sel)];
 selRam:=sub<Vram|[Vram!r:r in selRamRows]>;
 dirs:=[Vram!(directionRows[1] cat [0:h in [1..22]]),Vram!([0:h in [1..22]] cat directionRows[2])];
 directionSpace:=sub<Vram|dirs>;
 assert Dimension(sel) eq 1;
 assert Dimension(selRam) eq Dimension(sel);
 assert Dimension(directionSpace) eq 2;
 assert Dimension(selRam meet directionSpace) eq 0;
 printf "ODD_FORMAL_INTERSECTION n=%o selmer_dim=%o ramified_localization_kernel_dim=%o independent_directions_dim=%o intersection_dim=%o\n",
  n0,Dimension(sel),Dimension(sel)-Dimension(selRam),Dimension(directionSpace),Dimension(selRam meet directionSpace);
 outfile:="outputs/odd/formal_" cat IntegerToString(n0) cat "_" cat OUTTAG cat "_data.m";
 Write(outfile,"SelmerDimension := " cat IntegerToString(Dimension(sel)) cat ";\n" : Overwrite:=true);
 Write(outfile,"SelmerRamifiedRows := " cat Sprint(selRamRows) cat ";\n");
 Write(outfile,"DirectionRows := " cat Sprint([Eltseq(v):v in dirs]) cat ";\n");
end for;
printf "ODD_FORMAL_DIRECTION_TESTS_DONE\n";
quit;
