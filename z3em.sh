#!/usr/bin/env bash

cd z3/

emconfigure python scripts/mk_make.py --staticlib --staticbin --noomp --x86

emmake make -C build -j4

emcc -s INVOKE_RUN=0 -O3 -s MODULARIZE=1 -s EXPORT_NAME="'Z3Em'" -s STRICT=1 -s ERROR_ON_UNDEFINED_SYMBOLS=1 -s DISABLE_EXCEPTION_CATCHING=0 -s ABORTING_MALLOC=0 -s ALLOW_MEMORY_GROWTH=1 -s EXPORTED_FUNCTIONS='["_Z3_mk_config", "_Z3_mk_context", "_Z3_mk_config", "_Z3_del_config", "_Z3_eval_smtlib2_string", "_Z3_del_context"]' -s EXTRA_EXPORTED_RUNTIME_METHODS='["ccall", "cwrap"]' -fPIC -s WASM=1 -s BINARYEN_ASYNC_COMPILATION=0 build/libz3.a -o ../z3em.js

