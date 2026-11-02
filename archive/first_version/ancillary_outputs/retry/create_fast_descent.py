"""Create a local Magma descent variant from the user's installed package.

The installed package is read, never modified. Its source is not redistributed.
Only the new point-sampling block below is part of this deliverable.
Run from the workspace root before compute_rank.m with FAST:=1.
"""
from pathlib import Path
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--source', default='/opt/magma-2.30-1/package/Geometry/CycCov/picndescent.m')
args = parser.parse_args()
src = Path(args.source)
text = src.read_text()
text = text[:text.index('end intrinsic; //PicnDescents')+len('end intrinsic; //PicnDescents')]
start = text.index('intrinsic MonicModel(')
end = text.index('end intrinsic;', start)+len('end intrinsic;')
text = text[:start]+text[end:]
text = text.replace('intrinsic PicnDescent(', 'intrinsic RetryPicnDescent(')
text = text.replace('Safety := 0, Fields := {}) -> Tup',
                    'Safety := 0, Fields := {}, FastPrecision := 80) -> Tup')
for relative in ['../CrvG2/selmer.m', '../Algaem/resolvent.m', 'localfieldsDB.m']:
    text = text.replace('"'+relative+'"', '"'+str((src.parent/relative).resolve())+'"')
text = '\n'.join(line for line in text.splitlines()
                 if not line.startswith('declare attributes ')
                 and not line.startswith('declare verbose '))

marker = '  nzs := [ c : c in Coefficients(f_global) | c ne 0 ];'
assert text.count(marker) == 1
block = r'''
  // Custom shortcut for the hyperelliptic presentation X^11=Y^2+c.
  // Sample X, take a square root for Y, and evaluate the original descent
  // map at Y. Full dimension certifies completeness of the local image.
  if q eq 11 and d eq 1 and Degree(f_global) eq 2 and
     Coefficient(f_global,1) eq 0 and Coefficient(f_global,2) eq 1 and
     Valuation(k_v!11) gt 0 and Foundim1 then
    assert FastPrecision ge 80;
    printf "FAST_LOCAL_SAMPLING_STARTED precision=%o\n",FastPrecision;
    oldFastPrecision := k_v`DefaultPrecision;
    k_v`DefaultPrecision := FastPrecision;
    kgenFast := ChangePrecision(ktok_v(BaseRing(f_global).1),FastPrecision);
    cc := Evaluate(Polynomial(Eltseq(Coefficient(f_global,0))),kgenFast);
    piFast := ChangePrecision(UniformizingElement(k_v),FastPrecision);
    assert #ResidueClassField(Integers(k_v)) eq 11;
    Wfast := {};
    checksAfterFull := 0;
    splitFast,bFast := IsSquare(-cc);
    for attempt in [1..2000] do
      valuationX := [-2,0,1,2][1+(attempt mod 4)];
      xx := piFast^valuationX * (k_v!Random(1,10)+&+[k_v|Random(0,10)*piFast^j:j in [1..15]]);
      assert Valuation(xx) eq valuationX;
      if IsWeaklyZero(xx) then continue; end if;
      rhs := xx^11-cc;
      if IsWeaklyZero(rhs) then continue; end if;
      yes,yy := IsSquare(rhs);
      if not yes then continue; end if;
      assert RelativePrecision(yy) ge 35;
      if splitFast then
        // The descent coordinates are Y-b and Y+b. Their unit precision
        // must exceed the local eleventh-power stability bound.
        assert not IsWeaklyZero(yy-bFast) and not IsWeaklyZero(yy+bFast);
        assert Min(RelativePrecision(yy-bFast),RelativePrecision(yy+bFast)) gt 2*Valuation(k_v!11)+1;
      end if;
      for yy1 in [yy,-yy] do
        imptFast := mu_1(yy1);
        Include(~Wfast,imptFast);
        imageFast := imptFast-im1;
        if not imageFast in SpaceGenerated then
          SpaceGenerated := sub<Avqmodk_v|Generators(SpaceGenerated) join {imageFast}>;
          printf "FAST_LOCAL_GENERATOR dimension=%o target=%o attempt=%o\n",Ngens(SpaceGenerated),dimim,attempt;
        end if;
        error if Ngens(SpaceGenerated) gt dimim,"Spurious local point image";
      end for;
      if Ngens(SpaceGenerated) eq dimim then
        checksAfterFull +:= 1;
        if checksAfterFull ge 20 then
          printf "FAST_LOCAL_IMAGE_CERTIFIED dimension=%o\n",dimim;
          k_v`DefaultPrecision := oldFastPrecision;
          return Wfast,im1,Foundim1,SpaceGenerated;
        end if;
      end if;
    end for;
    error "Fast local sampling did not fill the expected image; no bound certified";
  end if;
'''
text = text.replace(marker, block+'\n'+marker)
dest = Path('work/retry/picndescent_fast.m')
dest.parent.mkdir(parents=True, exist_ok=True)
dest.write_text(text+'\n')
print(f'Created {dest}; the installed Magma package is unchanged.')
