package cangjie_test_cases

// EXEC: %compiler %enableEH %core_cmp_opt %f -o %output
// EXEC-PIPE-0: %run %set_stdx_path %output | compare %f
// ASSERT: scan Hello, world!
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace

import stdx.effect.{Command, Resumption}

func main8() {
    let message = "Hello, world!"
    try {
        println(message)
    } handle(cmd: Command<Unit>, next: Resumption<Unit, Unit>) {
        resume next with ()
    }
}
