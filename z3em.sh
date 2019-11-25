#!/usr/bin/env bash

cd z3/

# Default case for Linux sed, just use "-i" and "-r"
sedi="-i"
sedr="-r"
noomp="--noomp"
case "$(uname)" in
  # For macOS, use "-i ''" and "-E"
  Darwin*)
  	sedi="-i ''"
  	sedr="-E"
	noomp=""
esac

emconfigure python scripts/mk_make.py --staticlib --staticbin "$noomp" --x86

# Expand the parameters in the actual call to "sed"
sed "$sedi" 's/-D_LINUX_//g' build/config.mk

emmake make -C build -j4

emcc -s INVOKE_RUN=0 -O3 -s MODULARIZE=1 -s EXPORT_NAME="'Z3Em'" -s STRICT=1 -s ERROR_ON_UNDEFINED_SYMBOLS=1 -s DISABLE_EXCEPTION_CATCHING=0 -s ABORTING_MALLOC=0 -s ALLOW_MEMORY_GROWTH=1 -s EXPORTED_FUNCTIONS='["_Z3_mk_config", "_Z3_mk_context", "_Z3_mk_config", "_Z3_del_config", "_Z3_eval_smtlib2_string", "_Z3_set_error_handler", "_Z3_global_param_set", "_Z3_del_context"]' -s EXTRA_EXPORTED_RUNTIME_METHODS='["ccall", "cwrap", "addFunction", "removeFunction"]' -s RESERVED_FUNCTION_POINTERS=1 -fPIC -s WASM=1 -s BINARYEN_ASYNC_COMPILATION=1 build/libz3.a -o ../z3em.js

# receiveInstance(instance,module){Module["wasmModule"]=module;
sed "$sedi" "$sedr" 's/(receiveInstance\(instance,module\)\{)/\1if(Module["onReceiveInstance"]){Module["onReceiveInstance"](instance,module)}/g' ../z3em.js
