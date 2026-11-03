# Style check of the paper against the updated najman-paper-style skill, 3 November 2026

Paper: Overleaf 6ae89a4f, `main.tex` at commit 2958e5b (your AI-disclosure edit included). Line
numbers below refer to that file. Skill: `~/.claude/skills/najman-paper-style/` as updated on
3 November 2026 at 15:14. The new parts are "Lemmas and hypotheses" (from your instructions of 2 and
3 November), rule 9, self-check 12, and in `proof-structure.md` the sections "Organize the argument"
and "Keep hypotheses and notation visible". Nothing below has been applied yet.

## Verdict

The voice, lexicon, LaTeX conventions and document skeleton adhere to the skill. The paper does not
yet meet the two new rules (small self-contained lemmas, no running hypotheses), and it breaks the
"one name per object" rule in several places. The fixes are restructuring and renaming. No
mathematics and no computation changes.

## What already adheres

- Body of about 8,450 words with:
  - 0 semicolons;
  - 0 occurrences of Moreover, Indeed, Therefore, Consequently, whence, "so that", "that is,",
    Notably or Interestingly;
  - no em-dashes, `\emph`, bold, bullets in prose or exclamation marks.
- "Note that" ×6, "it follows that" ×11, "Suppose the opposite, that" in both main proofs, and
  "We compute" with hyperlinked verbs pinned to commit 380321b.
- The skeleton:
  - Intro: history, gap, "In this paper we", Theorem 1.1, method paragraphs, comparison, centered
    URL, data availability, AI disclosure.
  - Acknowledgements come before Section 2.
  - Section titles are descriptive. The paper ends with "Proof of Theorem 1.1" and "Computations".
- LaTeX: `\Cref` everywhere, `$$` displays, `\item[a)]`, `\textit` for coined terms, `\simeq`, a
  single hyphen in Mordell-Weil, `siam` bibliography style.
- Computations section: software, hardware and CPU time are given once. Replays and independent
  reconstructions are kept apart. It says candidly that the odd Selmer groups were computed only
  once. The supplementary checks are there and not in the proofs.
- The personal statements are left to you.

## A. Structure: the new rules on lemmas and hypotheses

A1. **Running hypothesis in Section 6 (l. 338).** "In this section let $l$ be a finite extension
of $\Q_{11}$ ..., $b\in\OO_l^\times$ ..." Lemmas 6.1 to 6.3 depend on it, and so does the prose
after 6.1 (the extension of log to $J(l)$, the integral formula, depth and leading vector).
Repair:
- Keep the construction of $\mathcal C$, $\Jhat$ and $H_m$ as a notation paragraph attached to a
  pair $(l,b)$.
- Begin each of Lemmas 6.1 to 6.3 with "Let $l$ be a finite extension of $\Q_{11}$ containing
  $\zeta_{11}$ with residue field $\F_{11}$, and let $b\in\OO_l^\times$."
- Move "log extends to $J(l)$, with kernel the torsion, and $\log[P-Q]=\int_Q^P\omega$" into
  Lemma 6.1 as part c).

A2. **Running hypothesis in Section 5 (l. 324).** The text reads "Suppose now that $n_0$ is odd,
let $\eta=4-\theta$ ...". It is followed by the injectivity proof of the twisted Kummer map, in
unnumbered prose. Lemma 6.3 b) then speaks of "the Kummer map of $J^\eta$ over $k$" for a general
$\eta\in k$, which Section 5 defines only for $\eta=4-\theta$ over fields containing $F$. Proposed
lemma, replacing l. 318–326:

> **Lemma 5.2.** Let $n_0\in\{-2,\ldots,4\}$ and let $k$ be a field containing $F$.
> a) The map $\mu_k\colon J(k)/\lambda J(k)\to k^\times/k^{\times 11}$, $[\sum n_iP_i]\mapsto
> \prod(Y(P_i)-b)^{n_i}$, is a well-defined injective homomorphism, and $\mu_k(T)$ is the class of
> $1/(2b)$.
> b) Let $\eta\in k^\times$ be a non-square. Then $\mu_{k(\sqrt\eta)}$ induces an injective
> homomorphism $J^\eta(k)/\lambda J^\eta(k)\to (k(\sqrt\eta)^\times/k(\sqrt\eta)^{\times11})^-$.
> c) If $k$ is a number field, then $\Sel^\lambda(J/k)\subseteq k(S_k,11)$.

Lemma 6.3 b) then cites 5.2 b). The paragraph at l. 328–330 ($[P-P_0]\in J(F)$ or $J^\eta(F)$)
becomes part c) of Prop. 5.1.

A3. **Claims in Section 7 prose (l. 415–421).** The prose proves two claims without numbered
statements:
- $\dim F(S_F,11)=19$ and $\dim B(S_B,11)^-=15$. These become Lemma 7.1 b).
- The local image dimensions (6 for $J$, 5 for $J^\eta$). Proposed lemma:

> **Lemma 7.2.** Let $v$ be a prime of $F$ above $11$. The image of the Kummer map of $J$ over $F_v$
> has dimension $6$, and the image of the Kummer map of $J^\eta$ over $F_v$, with $\eta=4-\theta$,
> has dimension $5$.

Its proof is the Schaefer96 Lemma 3.8 argument now in prose.

A4. **Prop. 8.2 (odd classes) as three lemmas plus a short proof.** The divisibility step and the
end step are facts about $J^\eta(F)$, not about the hypothetical point.

> **Lemma.** Let $n_0\in\{-1,1,3\}$, let $v$ be one of the two primes of $F$ above $11$ with
> $v(4-\theta)$ odd, and let $k=F_v$. Let $m\geq 3$ and let $D\in J^\eta(F)$ be such that its image
> in $J^\eta(k)$ lies in $H_m^-$. Then there is a unique $D_1\in J^\eta(F)$ with $\lambda D_1=D$, and
> the image of $D_1$ in $J^\eta(k)$ lies in $H_{m-2}^-$.

> **Lemma.** Let $n_0$, $v$ and $k$ be as in the previous lemma. Then there is no $D\in J^\eta(F)$
> whose image in $J^\eta(k)$ lies in $H_1^-$ and has leading vector a non-zero multiple of
> $(1,4,9,6,3)$.

The proof of Prop. 8.2 then has three steps:
1. The depth, from Lemma 8.1 and Lemma 6.2 b).
2. $r$ applications of the first lemma.
3. The leading-vector computation, which contradicts the second lemma.

The computed facts $a\equiv-1$ and $v(Y(P_0))=1$ are a single "We compute", so they can stay in the
proof.

A5. **Prop. 9.1 (even classes), the same way.**

> **Lemma.** Let $n_0\in\{-2,0,2,4\}$, let $v$ be one of the two primes of $F$ above $11$ with
> $v(4-\theta)$ odd, and let $l=F_v$. Let $m\geq 2$ and let $D\in J(F)$ be such that its image in
> $J(l)$ lies in $H_m$. Then there is a $D_1\in J(F)$ with $\lambda D_1=D$ whose image in $J(l)$ lies
> in $H_{m-1}$.

> **Lemma.** Let $n_0$, $v$ and $l$ be as in the previous lemma. If the image of $D\in J(F)$ in
> $J(l)$ lies in $H_1$ and has leading vector $(c_1,\ldots,c_5)$, then $\sum_j\ell_{j-1}c_j=0$.

Two further repairs here:
- The phrase "As in the proof of \Cref{prop:odd} we may assume ..." (l. 500) points into another
  proof. Repeat the one-line argument instead.
- "Let $P$ and $P_0$ be the points of $C(B)$ from \Cref{sec:genus5}" (l. 480) should cite
  Prop. 5.1 c) from A2.

A6. **Lemma 4.1 (Tate curve).** Its second paragraph is a fact about a fixed group.

> **Lemma.** Let $a\in\Z/121\Z$. If $\begin{pmatrix}1&a\\0&1\end{pmatrix}$ is conjugate in
> $\GL_2(\Z/121\Z)$ to an element of $N_{\ns}(121)$, then $a=0$.

Lemma 4.1 then reduces to the Tate-curve paragraph plus this lemma with $a=2v_p(q)$.

A7. **Lemma 3.3 (CM lifts).** Its second paragraph is a criterion about a fixed CM curve.

> **Lemma.** Let $\OO$ be an imaginary quadratic order in which $11$ is inert, let $E_0/\Q$ be an
> elliptic curve with CM by $\OO$, and let $A_0=\OO/121\OO\subset\End(E_0[121])$. Suppose that
> $\sigma\in G_\Q$ acts on $E_0[121]$ through an element of $A_0^\times$ whose image $g\in\F_{121}$
> satisfies $g^{5\#\OO^\times}\neq 1$. Then $\sigma$ fixes no point of $\Xns{121}$ above the image of
> $A_0$ in $\Xns{11}$ other than the point given by $A_0$.

Writing the exponent as $5\#\OO^\times$ (which equals $10$, $20$ or $30$) also removes the clash of
$e$ in B5.

A8. **Lemma 4.5 (l. 248).** "Let $\lambda$ be as above" breaks "repeat a hypothesis rather than
write as above". Write instead "Let $\mathfrak l$ be a prime of $K$ not above $11$ such that $11$
divides $\#k_{\mathfrak l}^\times$".

A9. **Optional: Cor. 4.4.** The function-field identity could become its own lemma about fixed
objects. It is one "We compute" with a pointer, so within reason it can stay.

## B. Notation: one name per object

The clashes below are ordered by how close together the two meanings appear.

| Letter | Meanings | Where they meet | Proposed fix |
|---|---|---|---|
| $\pi$ | the map $\Xns{121}\to\Xns{11}$ (13 uses); $1-\zeta_{11}$ (44 uses) | Prop. 8.2 and 9.1: $\pi(x)$ in the statement, $\pi^r$ in the proof | rename the map to $\varphi$. Then rename $\phi$ in Lemma 3.3 (to $\iota$) and $\phi(t)$ in Lemma 6.2 b) |
| $w$ | $w\in K^\times$ (Cor. 4.4); the prime of $B$ above $v$; leading-vector entries $w_j$ (Lemma 6.3) | proof of Prop. 8.2: "$l=B_w$" and "$v_l(a(w-1))$" | prime of $B$: $\tilde v$; entries: $c_j$ or similar |
| $\lambda$ | the isogeny $1-\sigma$; the sieve primes of $K$ (Section 4) | whole paper | sieve primes: $\mathfrak l$ |
| $B$ | the polynomial $B(x)$ in $j=(A+By)/u^{11}$; the field of degree 60 | Prop. 3.1 b) vs Sections 5–8 | polynomials: $\mathcal A,\mathcal B$ (3 places) |
| $\delta$ | $\delta_{n_0}\in K$; the valuations $\delta$ in Lemma 6.2 a) and Prop. 9.1 | Prop. 9.1 uses Lemma 8.1, where $\delta_{n_0}$ appears | write $d$ for the valuations, as Lemma 6.2 b) and Prop. 8.2 already do; rename $d_v$ in Prop. 7.2 |
| $e$ | ramification index $v(\pi)$; exponent $10,20,30$ in Lemma 3.3 | whole paper | $5\#\OO^\times$, see A7 |
| $r$ | $r\in R$ (squares mod 11); $r=10k_0-7$ (Prop. 8.2); $r_i\in\{2,3,4,8\}$ | Sections 4, 6, 8 | rename the number of divisions in Prop. 8.2 |
| $\mu$ | roots of unity $\mu_{11}$, $\mu_p$; the Kummer maps $\mu_k,\mu_F,\mu_l$ | l. 128, 245, 415 vs Sections 5–9 | write "$\zeta_{11}\in F$" in place of "$\mu_{11}\subset F$"; keep $\mu$ for the Kummer map |
| $t$ | $t=-x/y$ (Lemma 4.2, l. 216); $t=x/y$ (Cor. 4.4, l. 285, and the normalization at l. 221) | Section 4 | use $x/y$ throughout Section 4; integrality is unaffected |
| $H$ | $H=N_{\ns}(121)$ in $X_H$ (l. 132); the filtration $H_m$ | | write $X_{N_{\ns}(121)}$ directly |

Smaller clashes:
- $k$ is a number field, a local field, the integer in "the largest $k$" (l. 209), and the
  subscript of $k_\lambda$ and $k_0$.
- $T$ is the point $[(0,b)-\infty]$ and also the formal coordinates $T_j$ (Lemma 6.1).
- $\varepsilon=2$ and the unit $\epsilon$ (Lemma 6.1 proof).
- $A$ is the polynomial, the subring $A_0$ and the abelian variety at l. 419.
- $\kappa$ is the map of Lemma 4.3, the classes $\kappa_m$ and the class $\kappa_v$ of
  $1+\pi^{11}$.

## C. Local style (minor)

- "fibre" ×6 (l. 338, 342, 373, 375): change to "fiber". The skill defaults to American spelling.
- "Hence" ×15, "it follows that" ×11, "Thus" ×0. In his ranking "it follows that" comes before
  Thus/Hence. Change about 5 of the "Hence" to "Thus" or ", so".
- "i.e." ×10, which is about 12 per ten thousand words against his 4. Cut about half (l. 192, 209,
  268, 322, 333, 351, 400).
- The abstract has 6 sentences; his range is 2–5. Merge the first two: "We show that the modular
  curve ... has exactly $7$ rational points, all of them CM points."
- The roadmap (l. 107) has 4 sentences; his habit is 1–2 or none. Compress it or drop it.
- l. 142: "$E(\Q)=\Z G$ ... (see \cite{ST12})" is a bare cite for a specific result, against rule 6.
  Either pinpoint it in ST12 or write "We compute" and point to `code/model.m`. Note that
  `model.m` prints the rank bound 1 and the generator $(4,5)$ but does not `assert` it, so an
  assert should be added first.
- l. 468: `\gitlink{code/even_geometry.m}{that}` hyperlinks the word "that". Link the verb instead
  ("and we \gitlink{...}{compute} that ... if $n_0$ is even").
- l. 527: the code is the grammatical agent ("\githubbare{code/sieve_bruteforce.m} reduces the
  functions ... and runs through"). The skill lists this as AI drift. Rewrite as "we reduce the
  functions computed over $K$ and run through all residue classes (see ...)".
- l. 105: "What makes this work is that" can become "The method works because". At "(GRH): it is
  used only", split into two sentences.

## D. Not style, found on the way

- **AI disclosure (your text, l. 118).** It says Claude Opus 5.5 "reviewed these proofs, without
  rerunning the computations". In fact I reran every first-version script (logs in
  `archive/first_version/replay_2026-11-02/`) and independently reimplemented the sieve, the even
  Selmer groups, the CM lifts, the genus and the single-place checks. Section 11 of the paper says
  this. The sentence is yours, so I have not changed it.
- **Hardware.** Your correction (16 cores, 32 threads, 384 GB) is in the paper. `README.md` (Hardware
  section) still says 32 cores and 376 GB, and so does `~/CLAUDE.md`.

## Applied (3 November 2026, on the author's instruction)

All of A–C were applied to the Overleaf `main.tex`, in addition to the following:

- **Renames beyond the table.**
  - The rational point on `X_ns^+(121)` is now `ξ`; it clashed with the coordinate `x` in
    Cor. 4.9.
  - The sieve classes `κ_m` are now `γ_m`.
  - The class of the odd case is now `κ_v^-` (formerly `d_v`).
  - The cusps are written `rs` instead of `c`, and the number of divisions in Prop. 8.4 is `N`.
  - The point in Lemma 4.4 is `T_0`, and its parameter `t_0`.
  - `π = 1−ζ_11` is now defined in the notation section.
- **Proof of Prop. 9.3.** The induction step of the old version contained a redundant deduction
  (`μ_l(D'_{i+1}) = 0`). Lemma 9.1 omits it, because the intersection property of Prop. 7.4 b) is
  needed only in the last step (Lemma 9.2).
- **First version stated a wrong dependence.** It said that `β` depends on `n_0`, but
  `α − θ = β²` does not involve `n_0`. The paper now says "the dependence of `a` and `b`".
- **New numbering.**
  - Lemma 3.3 is the CM-lift criterion, and Lemma 3.4 is the old Lemma 3.3.
  - Lemma 4.1 is the unipotent lemma, and Lemma 4.2 is the Tate lemma.
  - Lemma 5.2 is the Kummer maps.
  - Lemma 7.1 has a new part b), and Lemma 7.2 gives the local images.
  - Lemmas 8.2 and 8.3 and Lemmas 9.1 and 9.2 are the divisibility and end-step lemmas.
  - The README table follows the new numbering.
- **E(Q) = ZG.** `code/model.m` now asserts `E(Q) = Z·G` (`MW_GROUP_VERIFIED`, using
  `MordellWeilGroup` with both proof flags true), and `logs/model.log` was regenerated.
- **AI disclosure.** At the author's request, the sentence now says that Claude Opus 5.5 reran
  all the computations and independently reimplemented the sieve, the even Selmer groups, the CM
  lifts and the genus.
- **Correction to item D.** The README hardware line was already corrected in the author's commit
  55f75ec. Only `~/CLAUDE.md` still had the old figures, and it is now updated.
- **Kept in prose.** The Selmer containment `Sel ⊆ k(S_k,11)` (good reduction away from 2 and
  11) stays a prose sentence, as in the first version. Making it a lemma would need a pinpoint
  reference for the unramifiedness of local images at primes of good reduction, which was not
  checked.
