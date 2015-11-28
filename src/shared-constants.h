#ifndef _shared_constants_h_
#define _shared_constants_h_

#include "emscripten-optimizer/optimizer.h"

namespace wasm {

cashew::IString GLOBAL("global"),
                NAN_("NaN"),
                INFINITY_("Infinity"),
                TOPMOST("topmost"),
                INT8ARRAY("Int8Array"),
                INT16ARRAY("Int16Array"),
                INT32ARRAY("Int32Array"),
                UINT8ARRAY("Uint8Array"),
                UINT16ARRAY("Uint16Array"),
                UINT32ARRAY("Uint32Array"),
                FLOAT32ARRAY("Float32Array"),
                FLOAT64ARRAY("Float64Array"),
                IMPOSSIBLE_CONTINUE("impossible-continue"),
                MATH("Math"),
                IMUL("imul"),
                CLZ32("clz32"),
                FROUND("fround"),
                ASM2WASM("asm2wasm"),
                F64_REM("f64-rem"),
                F64_TO_INT("f64-to-int"),
                GLOBAL_MATH("global.Math"),
                ABS("abs"),
                FLOOR("floor"),
                SQRT("sqrt"),
                I32_TEMP("asm2wasm_i32_temp"),
                DEBUGGER("debugger"),
                GROW_WASM_MEMORY("__growWasmMemory"),
                NEW_SIZE("newSize"),
                MODULE("module"),
                FUNC("func"),
                PARAM("param"),
                RESULT("result"),
                MEMORY("memory"),
                SEGMENT("segment"),
                EXPORT("export"),
                IMPORT("import"),
                TABLE("table"),
                LOCAL("local"),
                TYPE("type"),
                CALL("call"),
                CALL_IMPORT("call_import"),
                CALL_INDIRECT("call_indirect"),
                BR_IF("br_if"),
                NEG_INFINITY("-infinity"),
                NEG_NAN("-nan"),
                CASE("case"),
                BR("br"),
                FAKE_RETURN("fake_return_waka123");

}

#endif // _shared_constants_h_

