// Cartan action on the affine space of lifts of a fixed mod-11 Cartan.
// CM reciprocity gives the full action modulo elliptic automorphisms.
SetColumns(0);
F := GF(11^2);
g := PrimitiveElement(F)^10;
assert Order(g) eq 12;
for t in [1,2,3] do
  aut := g^(12 div t);
  orbits := {{aut^k*v : k in [0..t-1]} : v in F};
  fixed := {o : o in orbits | {g*v : v in o} eq o};
  assert fixed eq {{F!0}};
  seen := {};
  lengths := {};
  for o in orbits do
    if o in seen then continue; end if;
    k := 0; q := o;
    repeat
      Include(~seen,q);
      q := {g*v : v in q};
      k +:= 1;
    until q eq o;
    Include(~lengths,k);
  end for;
  assert lengths eq {1,12 div t};
  printf "Automorphism image order %o: one fixed orbit; other Galois orbits have length %o.\n",t,12 div t;
end for;
printf "CM_LIFTS_DONE\n";
quit;
