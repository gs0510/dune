FROM ocaml/opam:debian-10-ocaml-4.12

RUN sudo apt-get update && sudo apt-get install -qq -yy libffi-dev \
        liblmdb-dev m4 pkg-config gnuplot-x11 libgmp-dev libssl-dev \
        libpcre3-dev

COPY --chown=opam:opam . bench-dir

WORKDIR  bench-dir

RUN opam remote add origin https://opam.ocaml.org

RUN opam pin add dune.3.0 https://github.com/ocaml/dune.git#main

RUN eval $(opam env)

RUN opam install ./dune-bench.opam -y --deps-only  -t

ADD  --chown=opam . .

RUN eval $(opam env)
