(lang dune 3.14)

(name cronos)

(generate_opam_files true)

(source
 (github dmmulroy/cronos))

(authors "Dillon Mulroy")

(maintainers "Dillon Mulroy")

(license MIT)

(documentation https://url/to/documentation)

(package
 (name cronos)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends ocaml dune ppx_inline_test)
 (tags
  (topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
