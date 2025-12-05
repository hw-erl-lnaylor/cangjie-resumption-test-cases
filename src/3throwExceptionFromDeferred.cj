package cangjie_test_cases

// EXEC: %compiler %enableEH %core_cmp_opt  %f -o %output
// EXEC-PIPE-0: %run %set_stdx_path %output | compare %f
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace

import stdx.effect.*

class Deferred3 <: Command<Unit> {}
class Immediate3 <: Command<Unit> {}

class MyException2 <: Exception {}

func main3() {
    try {
        try {
            let x = try {
                perform Immediate3()
                34
            } handle (_: Deferred3, res: Resumption<Unit, Int64>) {
                42
            }
            33
        } handle (_: Immediate3) {
            throw MyException2()
        }
    } catch(_: MyException2) {
        return 0
    }
}
