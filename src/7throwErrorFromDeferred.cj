package cangjie_test_cases

// EXEC: %compiler %enableEH %core_cmp_opt  %f -o %output
// EXEC-PIPE-0: %run %set_stdx_path %output | compare %f
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace

import stdx.effect.*

class Deferred2 <: Command<Unit> {}
class Immediate <: Command<Unit> {}

class MyException <: Exception {}

func stackOverFlow2(): Int64 {
    stackOverFlow2() + 1
}

func main7() {
    try {
        try {
            let x = try {
                perform Immediate()
                34
            } handle (_: Deferred2, res: Resumption<Unit, Int64>) {
                42
            }
            33
        } handle (_: Immediate) {
            stackOverFlow2()
            43
        }
    } catch(_: Error) {
        return 0
    }
}
