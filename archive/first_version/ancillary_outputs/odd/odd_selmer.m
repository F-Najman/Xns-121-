// Independent 11-isogeny descent upper bounds for all three odd classes.
// No degree-60 unit or completion calculation is used.
SetColumns(0); SetMemoryLimit(6*10^9); SetSeed(20261029);
load "outputs/retry/verify_genus5.m";
if not assigned PADPREC then PADPREC:=80;
elif Type(PADPREC) eq MonStgElt then PADPREC:=StringToInteger(PADPREC); end if;
if not assigned OUTTAG then OUTTAG:="p" cat IntegerToString(PADPREC); end if;
BB:=AbsoluteField(B); OBB:=Integers(BB);
assert Abs(Discriminant(OBB)) eq 2^60*11^56;
assert 2^60*11^56 lt 19^60 and 2^20*11^27 lt 19^30;
assert 20710*(330000-24001) gt 19000*330000;
assert #Decomposition(OBB,2) eq 1 and #Decomposition(OBB,11) eq 3;
assert #Decomposition(Integers(F),2) eq 1 and #Decomposition(Integers(F),11) eq 3;
printf "ODLYZKO_INPUTS_VERIFIED; Cl(B)[11]=Cl(F)[11]=0; global norm kernel dimension=15\n";
eta:=conv(4-theta);
zeta:=Roots(PolynomialRing(F)!CyclotomicPolynomial(11))[1][1];
conjB:=func<a|Evaluate(Polynomial(Eltseq(B!a)),-B.1)>;

// Each local record: base field, branch field, F->base, B->branch,
// branch Kummer map, sqrt(eta), 1-zeta, relative ramification, conjugation.
Locals:=[**];
for pe in Decomposition(Integers(F),11) do
 kv0,mv:=Completion(F,pe[1]:Precision:=3*PADPREC+40);
 kv0`DefaultPrecision:=3*PADPREC+40;
 fg0:=ChangePrecision(mv(F.1),3*PADPREC+40);
 loc0:=func<a|Evaluate(Polynomial(Eltseq(F!a)),fg0)>;
 ee0:=loc0(eta); pi0:=1-loc0(zeta);
 kv:=ChangePrecision(kv0,PADPREC);
 locF:=func<a|kv!loc0(a)>;
 ee:=locF(eta); pi:=locF(1-zeta);
 PP<t>:=PolynomialRing(kv);
 if IsOdd(Valuation(ee)) then
  bv<rho>:=TotallyRamifiedExtension(kv,t^2-kv!(ee0/pi0^4));
  rootEta:=rho*(bv!pi)^2;
  erel:=2;
 else
  bv<rho>:=UnramifiedExtension(kv,2);
  ok,unitRoot:=IsSquare(bv!(kv!(ee0/pi0^10))); assert ok;
  rootEta:=unitRoot*(bv!pi)^5;
  erel:=1;
 end if;
 assert Valuation(rootEta^2-bv!ee) ge PADPREC-10;
 assert BaseRing(bv) cmpeq kv;
 otherRoot:=-bv.1-bv!Coefficient(DefiningPolynomial(bv),1);
 tauLocal:=func<a|Evaluate(Polynomial(Eltseq(bv!a)),otherRoot)>;
 assert Valuation(tauLocal(rootEta)+rootEta) ge PADPREC-10;
 function toBranch(a)
  cc:=Eltseq(B!a);
  return &+[bv|(bv!locF(cc[j]))*rootEta^(j-1):j in [1..#cc]];
 end function;
 GG,mu:=pSelmerGroup(11,bv);
 assert Ngens(GG) eq 22;
 Append(~Locals,<kv,bv,locF,toBranch,mu,rootEta,pi,erel,tauLocal>);
 printf "LOCAL_TOWER_READY index=%o e_B=%o residue_size=%o precision=%o\n",#Locals,Valuation(bv!11),#ResidueClassField(Integers(bv)),PADPREC;
end for;
function globalLocalRow(a)
 row:=[];
 for loc in Locals do
  aa:=loc[4](a);
  assert RelativePrecision(aa) ge 2*Valuation(Parent(aa)!11)+2;
  row cat:=Eltseq(loc[5](aa));
 end for;
 return row;
end function;

// GRH is used only to discover candidate S-classes in smaller fields.
// Membership plus 15 independent local images certifies the entire
// anti-invariant global space, whose dimension was proved above.
SetClassGroupBounds("GRH");
yes,rootMinus11:=IsSquare(F!(-11)); assert yes;
Vall:=VectorSpace(GF(11),66); GlobalSpace:=sub<Vall|>;
GlobalRepresentatives:=[]; GlobalRows:=[];
for twist in [1,-11] do
 PS<t>:=PolynomialRing(LS);
 Jrel<r>:=NumberField(t^2-twist*toLS(LA!(4-theta)));
 Jabs:=AbsoluteField(Jrel); JJ,optJJ:=OptimisedRepresentation(Jabs);
 OJJ:=Integers(JJ);
 rootInB:=B.1*(twist eq 1 select B!1 else B!rootMinus11);
 function intoB(x)
  cc:=Eltseq(Jrel!(x@@optJJ));
  return &+[B|B!conv(L!(cc[j]@@toLS))*rootInB^(j-1):j in [1..#cc]];
 end function;
 assert Evaluate(DefiningPolynomial(JJ),intoB(JJ.1)) eq 0;
 SS:=Seqset([a[1]:a in Decomposition(OJJ,2)] cat [a[1]:a in Decomposition(OJJ,11)]);
 time GS,mm,toVec,baseUnits:=pSelmerGroup(11,SS:Raw);
 printf "SUBFIELD_CANDIDATES twist=%o count=%o\n",twist,Ngens(GS);
 for jj in [1..Ngens(GS)] do
  exps:=Eltseq(toVec(GS.jj));
  elt:=&*[JJ|JJ!baseUnits[h]^(exps[h] mod 11):h in [1..#exps]];
  for fac in Factorisation(elt*OJJ) do
   assert fac[2] mod 11 eq 0 or Norm(fac[1]) mod 2 eq 0 or Norm(fac[1]) mod 11 eq 0;
  end for;
  cc:=intoB(elt); aa:=cc/conjB(cc);
  assert Norm(aa) eq F!1;
  row:=Vall!globalLocalRow(aa);
  if row notin GlobalSpace then
   Append(~GlobalRows,row); Append(~GlobalRepresentatives,aa);
   GlobalSpace:=sub<Vall|GlobalSpace,row>;
   printf "GLOBAL_ANTI_GENERATOR twist=%o candidate=%o dimension=%o\n",twist,jj,Dimension(GlobalSpace);
  end if;
  if Dimension(GlobalSpace) eq 15 then break; end if;
 end for;
end for;
assert Dimension(GlobalSpace) eq 15;
printf "GLOBAL_ANTI_BASIS_CERTIFIED dimension=15 GRH_required=false\n";
basisFile:="outputs/odd/global_basis_" cat OUTTAG cat "_data.m";
Write(basisFile,"FDefiningCoefficients := " cat Sprint(Eltseq(DefiningPolynomial(F))) cat ";\n" : Overwrite:=true);
Write(basisFile,"EtaCoefficients := " cat Sprint(Eltseq(eta)) cat ";\n");
Write(basisFile,"AntiRepresentatives := " cat Sprint([[Eltseq(c):c in Eltseq(a)]:a in GlobalRepresentatives]) cat ";\n");
Write(basisFile,"GlobalRows := " cat Sprint([Eltseq(r):r in GlobalRows]) cat ";\n");

allSelmerSpaces:=[**]; allLocalImages:=[**];
for n0 in [-1,1,3] do
 idx:=n0+3; a:=conv(Deltas[idx]/(L!alpha-theta)); b0:=a^5;
 localImages:=[**]; localRows:=[**];
 for j in [1..3] do
  loc:=Locals[j]; kv:=loc[1]; bv:=loc[2]; lf:=loc[3]; mu:=loc[5];
  rt:=loc[6]; pi:=loc[7]; aa:=lf(a); bb:=bv!lf(b0); ee:=lf(eta);
  tau:=loc[9]; OBv:=Integers(bv); residue,red:=ResidueClassField(OBv);
  piB:=bv!UniformizingElement(OBv);
  VV:=VectorSpace(GF(11),22); imageSpace:=sub<VV|>;
  for attempt in [1..1000] do
   // A branch-field point P gives the anti-invariant Jacobian class
   // (P-tau(P))/2 on the quadratic twist. This supplies degree-two
   // divisors even when rational points alone do not span the image.
   xx:=&+[bv|(Random(residue)@@red)*piB^h:h in [0..16]];
   rhs:=xx^11+bb^2;
   if IsWeaklyZero(rhs) then continue; end if;
   ok,yy:=IsSquare(rhs); if not ok then continue; end if;
   for sign in [1,-1] do
    ym:=sign*yy-bb;
    ymt:=sign*tau(yy)-bb;
    assert RelativePrecision(ym) ge 2*Valuation(bv!11)+2;
    assert RelativePrecision(ymt) ge 2*Valuation(bv!11)+2;
    rr:=VV!Eltseq(6*(mu(ym)-mu(ymt)));
    if rr notin imageSpace then
     imageSpace:=sub<VV|imageSpace,rr>;
     printf "ODD_LOCAL_IMAGE n=%o place=%o dimension=%o attempt=%o\n",n0,j,Dimension(imageSpace),attempt;
    end if;
   end for;
   assert Dimension(imageSpace) le 5;
   if Dimension(imageSpace) eq 5 then break; end if;
  end for;
  assert Dimension(imageSpace) eq 5;
  knownY:=B.1*(B!(a^5*conv(KnownV[idx]/beta)));
  knownImage:=VV!Eltseq(mu(loc[4](knownY-B!b0)));
  assert knownImage in imageSpace;
  Append(~localImages,imageSpace);
 end for;
 sel:=GlobalSpace;
 for j in [1..3] do
  constraint:=sub<Vall|[Vall.h:h in [1..66]|h le 22*(j-1) or h gt 22*j] cat
   [Vall!([0:h in [1..22*(j-1)]] cat Eltseq(rr) cat [0:h in [1..22*(3-j)]]):rr in Basis(localImages[j])]>;
  sel:=sel meet constraint;
 end for;
 knownY:=B.1*(B!(a^5*conv(KnownV[idx]/beta)));
 knownGlobal:=Vall!globalLocalRow(knownY-B!b0);
 assert knownGlobal in sel and knownGlobal ne Vall!0;
 printf "ODD_SELMER_UPPER_BOUND n=%o dimension=%o rank_over_L_le=%o\n",n0,Dimension(sel),5*Dimension(sel);
 Append(~allSelmerSpaces,sel); Append(~allLocalImages,localImages);
 output:="outputs/odd/selmer_" cat IntegerToString(n0) cat "_" cat OUTTAG cat "_data.m";
 Write(output,"GlobalRows := " cat Sprint([Eltseq(r):r in GlobalRows]) cat ";\n" : Overwrite:=true);
 Write(output,"SelmerRows := " cat Sprint([Eltseq(r):r in Basis(sel)]) cat ";\n");
 Write(output,"LocalImageRows := " cat Sprint([[Eltseq(r):r in Basis(im)]:im in localImages]) cat ";\n");
 Write(output,"KnownPointImage := " cat Sprint(Eltseq(knownGlobal)) cat ";\n");
end for;
printf "ODD_SELMER_BOUNDS_DONE\n";
// Leave fields and maps available for the subsequent local-direction test.
