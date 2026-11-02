"""Generate a local Magma descent with a global-basis certificate and raw maps.

Requires the previous retry files and the user's licensed Magma installation.
The installed Magma source is never modified or redistributed.
"""
from pathlib import Path
import subprocess
import sys

subprocess.run([sys.executable, 'outputs/retry/create_fast_descent.py'], check=True)
text = Path('work/retry/picndescent_fast.m').read_text()
text = text.replace('RetryPicnDescent(', 'ContinuationPicnDescent(')
text = text.replace('FastPrecision := 80) -> Tup',
                    'FastPrecision := 160, CertifySplitGlobal := false) -> Tup')
marker = 'NASqmodktokq := NormAndPreimc[1];'
assert text.count(marker) == 1
certificate = r'''
if CertifySplitGlobal then
  // Caller has proved Cl(F)[11]=0 using the S_3 subfields.
  // For the two split components, dim A(S,11)=2*(14+1+4)=38.
  assert q eq 11 and Degree(k) eq 30 and Degree(f) eq 2;
  assert #Roots(f) eq 2 and #S eq 4;
  assert Ngens(ASqmodk) eq 38 and Exponent(ASqmodk) eq 11;
  assert #repAs eq 38;
  for aa in repAs do
    comps:=AtoAflds(aa);
    for jj in [1..2] do
      bb:=comps[jj];
      for pe in Factorisation(bb*Integers(Parent(bb))) do
        assert pe[2] mod 11 eq 0 or Norm(pe[1]) mod 2 eq 0 or Norm(pe[1]) mod 11 eq 0;
      end for;
    end for;
  end for;
  commonKernel:=ASqmodk;
  for rr in respGrps do commonKernel:=commonKernel meet Kernel(rr); end for;
  assert #commonKernel eq 1;
  printf "GLOBAL_BASIS_CERTIFIED: 38 independent classes in A(S,11), expected dimension 38\n";
end if;
'''
text = text.replace(marker, certificate+'\n'+marker)
ret = 'return dimSel, SelfakeJ, SelfakePic1, ranktorsglobal, ASqmodktoA, muJktors, toVec, FB ;'
assert text.count(ret) == 1
text = text.replace(ret,
    'return dimSel, SelfakeJ, SelfakePic1, ranktorsglobal, ASqmodktoA, muJktors, toVec, FB, '
    '<S,ASqmodk,AtoASqmodk,respGrps,AtoLocs,CompletionsOfk,AtoAflds,repAs>;')
dest=Path('work/continuation/picndescent.m')
dest.parent.mkdir(parents=True,exist_ok=True)
dest.write_text(text)
print(f'Created {dest}')
