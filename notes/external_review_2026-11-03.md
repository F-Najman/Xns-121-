# External review of 3 November 2026 and the changes made in response

Review: `~/Documents/Codex/2026-10-29/can-you-find-the-rational-points/outputs/review_20261103/`
(`review.pdf`, `suggested_revisions.pdf`, `validation.json`, `check_certificates.py`). Its replay is
in `.../work/review_20261103/replay`. It covered both the 17-page version and the 19-page
revision (Overleaf 146a061).

The reviewer found no substantive gap. It replayed all 19 jobs and checked 20 finite-field matrix
conditions with its own Gaussian elimination. It did not reimplement the odd Selmer computation, so
the odd Selmer groups remain replayed only.

## Points, how they were checked, and what was done

1. **Lemma 6.3 b) used `v(η)` odd.** With `v = v_l`, `v_l(η) = 2 v_k(η)` is even. Correct.
   - Fixed: the lemma now says `v_k(η)` odd, which implies `e = 2`.
   - `J^η` is now defined in the lemma itself, with the identification of `J^η(k)`.
2. **Level 49 literature.** Checked on arXiv and Crossref on 3 November 2026.
   - Arango-Piñeros and Zureick-Brown, arXiv:2610.06521 (5 October 2026), show that the two
     level-49, genus-9 curves have no non-CM rational points. Added to the intro as `APZB26`.
   - Furio–Lombardo is published: Proc. Lond. Math. Soc. (3) 133 (2026), no. 2, e70193,
     doi:10.1112/plms.70193 (Crossref, August 2026). The bib entry is updated. One web-search
     summary claimed Proc. Roy. Soc. Edinburgh; Crossref contradicts it, so it is wrong.
   - The intro now says that this leaves only `X_ns^+(25)`, and that Eray Karabıyık has determined
     its rational points (private communication). The author supplied this information on
     3 November 2026. No public preprint was found: the only recent arXiv paper by (Emir) Eray
     Karabıyık is arXiv:2609.03946, on `SL_2(F_13)` and `SL_2(F_19)` as Galois groups.
   - No public paper on `X_ns^+(25)` was found. The arXiv API title search was run on
     3 November 2026. The reviewer's "companion paper" is presumably the author's own level-25
     work in `~/Documents/Codex/2026-10-27/can-you-review-the-xns-25/`; whether to cite it is the
     author's decision.
3. **`run_all.sh` did not check success markers.** Confirmed: Magma exits with status 0 after a
   failed `assert`, tested on a toy script.
   - Fixed: every job now has its success markers, and its log is scanned for Magma error
     messages.
   - `logs/run_all.status` ends with `ALL_PASSED` or `FAILED`; in the second case the script
     exits with status 1.
   - A full rerun on 3 November 2026 gives `ALL_PASSED` (19/19). The logs differ from the
     previous run only in timings and in the numbers of random local points tried.
4. **AI disclosure.** Already corrected in 146a061.

## Simplifications adopted

- **Prop. 7.4 b)** is now "`loc_v` is injective on `𝒮` and `κ_v ∉ loc_v(𝒮)`". This is equivalent
  to the old conditions, because `μ_v(T) ∈ loc_v(𝒮)`.
  - `code/single_place.m` now asserts it directly (marker `E6`), together with
    `⟨μ_v(T)⟩ ⊆ loc_v(𝒮)`.
  - The old checks (`E5`) are kept.
- **Common lifting lemma (Lemma 7.6).** If `A(k)/ψA(k) → A(k_v)/ψA(k_v)` is injective and
  `A[ψ](k_v) = A[ψ](k)`, then every local `ψ`-preimage of a global point is global.
  - Lemma 7.7 checks the hypotheses: for `J` (even classes), from Prop. 7.4 b) and
    `J[λ] = ⟨T⟩`; for `J^η` (odd classes), from Prop. 7.3 and `J^η[λ] = 0`.
  - It replaces the former Lemmas 8.2 and 9.1 (`lem:odd_divide`, `lem:even_divide`).
  - The induction no longer needs `μ(H_2) = 0`. Lemma 6.3 is used only in the final steps.
- **`b̄² = ā^{10} = 1`.** The proofs now derive this from `b = a^5` with `a` a unit, where the
  previous text said only "`b` is a unit".
- **Serre's question.** Now stated as uniformity, with the bound 37 described as expected (see
  Zywina).
- **Remark 5.3 (ranks).** It now justifies rank 5 over `L` by Galois descent for the semilinear
  action of `Gal(F/L)`. The reviewer suggested citing "Schaefer's Proposition 3.8"; that pinpoint
  is UNVERIFIED and was not used.

## New numbering (Overleaf 401db9d)

- Lemma 7.6 is the lifting lemma, and Lemma 7.7 checks its hypotheses.
- Lemma 8.1 is the depth lemma, and Lemma 8.2 is the odd end step.
- Prop. 8.3 is the odd classes (formerly 8.4).
- Lemma 9.1 is the even end step, and Prop. 9.2 is the even classes (formerly 9.3).

The paper's links point to revision c12c8c3.

## Not done (the author's decision)

- Deleting Remark 5.3 (ranks).
- Citing the level-25 companion paper.
- Possibly citing related 2026 work that the earlier literature check did not list:
  - Hashimoto, Lido, Lombardo, Mascot and Parent, arXiv:2608.10919: equationless quadratic
    Chabauty for `X_ns^+(p)`, which also works with the moduli interpretation instead of a model;
  - Bisatt, Furio and Lombardo, arXiv:2603.04021: if the mod `p` image is non-split Cartan, the
    `p`-adic image is the full preimage of `N_ns(p^n)`.

  Neither determines `X_ns^+(121)(Q)`.
