package cangjie_test_cases

// EXEC: %compiler %enableEH %core_cmp_opt %f -o %output
// EXEC-PIPE-0: %run %set_stdx_path %output | compare %f
// ASSERT: scan Hello
// ASSERT: scan-not Never
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace

import stdx.effect.{Command, Resumption}

class Get1 <: Command<Int64> {}
class Eff1 <: Command<Unit> {}

func main1() {
    try {
        try {
            try {
                try {
                    perform Get1()
                } handle (_: Eff1) {
                    println("never handled")
                }
            } catch (e: Exception) {
                println("Never caught by internal catch")
            }
            ()
        } handle (_: Get1) {
            throw Exception("Hello")

            resume with 1
        }
    } catch (e: Exception) {
        println(e.message)
    }
    0
}
