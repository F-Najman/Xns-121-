// Run this file after one formal_*_data.m file on Magma's command line.
V:=VectorSpace(GF(11),#FormalRows[1]);
SS:=sub<V|[V!a:a in SelmerLocalRows]>;
UU:=sub<V|[V!a:a in FormalRows]>;
TT:=sub<V|[V!a:a in LocalTorsionRows]>;
Tglobal:=sub<V|&+[V!a:a in LocalTorsionRows]>;
assert Dimension(UU) eq 3 and Dimension(TT) eq 3;
assert Dimension(Tglobal) eq 1;
assert Dimension(UU meet TT) eq 0;
assert SS meet (UU+TT) eq Tglobal;
printf "MATRIX_CERTIFICATE_VERIFIED selmer=%o formal=3 local_torsion=3 intersection=global_torsion\n",Dimension(SS);
quit;
