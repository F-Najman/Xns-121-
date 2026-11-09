# Hexagon submission, 9 November 2026

The paper was submitted to Hexagon (hexagonmath.org) through its API on 9 November 2026, with the
author's approval at each step. It was committed as **hexagon:2611.00231 (2611.00231v1)** at
07:04:32 UTC, draft `d49f3f53-1c57-4893-9720-badfc3987481`. At commit time its status was
"processing" (screening and moderation). The record is not public until a moderator accepts it.

## Source

- The ZIP contained `main.tex` and `refs.bib`, identical to Overleaf commit 33012ec (SHA-256
  prefixes 42edb3142ca5 and 98b2923cddb8, confirmed by Hexagon's expand step).
- The code is not bundled. The paper links to this repository at revision c12c8c3.
- Hexagon compiles with TeX Live 2025 (pdfTeX 1.40.28, latexmk). With that version, `\Cref` named
  every lemma, proposition, corollary and remark "Theorem", because of the shared theorem counter.
  The fix is aliased counters (`\sharedtheorem` with `aliascnt`, as in the S(d) paper), in Overleaf
  33012ec. The local tectonic build did not show the problem.
- Hexagon's preview had no errors, 19 pages, and no undefined references in the final pass. Its
  text and its 39 link targets are identical to the local TeX Live 2025 build
  (`~/localpkgs/texlive/2025`).

## Metadata (as approved by the author)

- Title: "Rational points on the non-split Cartan modular curve of level $121$". The abstract is
  the paper's, with its macros expanded.
- Authors, in this order:
  - Santiago Arango-Piñeros (University of Massachusetts Amherst, ORCID 0000-0002-7224-6777);
  - Filip Najman (University of Zagreb, submitter);
  - David Zureick-Brown (Amherst College, ORCID 0000-0002-2025-3836).
  - The server dropped the submitter's ORCID from the author entry, as it did in the S(d)
    submission.
  - The two co-authors agreed to the submission (author's confirmation, 9 November 2026).
- Subject math.NT, no cross-lists. MSC 11G05, 11G18, 14G05, 11F80. License CC BY 4.0.
- Tags: modular curves, non-split Cartan subgroups, Galois representations, Selmer groups, Chabauty
  method.
- Text origin: primarily AI-generated. Human understanding: some.
- Tools: Claude Opus 5.5, GPT 6.1 Sol, GPT 6 Astra, Magma V2.30-1.
- Comment: "19 pages. Code, logs and certificates: https://github.com/F-Najman/Xns-121-"
- All four confirmations (correctness, community interest, citations, rights) were set by the
  author.
- Provenance, in the author's words:

  > The mathematical content of this paper was produced by AI models. Anthropic's Claude Opus 5.5,
  > OpenAI's GPT-6.1 Sol and GPT-6 Astra produced almost all of the mathematics of the first
  > versions of the proofs and carried out the computations. Anthropic's Claude Opus 5.5 reviewed
  > these proofs, checked the references, wrote the manuscript and organized the code repository.
  > We have not yet fully checked the proofs.

  The AI disclosure in the paper was aligned with this text first (Overleaf 02b9909).

## Still to do

- Once the record is published, check it (in particular the author ORCID iDs), and add the
  identifier to the README citation.
