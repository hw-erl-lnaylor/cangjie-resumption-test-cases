package cangjie_test_cases

// EXEC: %compiler %enableEH %core_cmp_opt  %f -o %output
// EXEC-PIPE-0: %run %set_stdx_path %output | compare %f
// ASSERT: scan-not core dumped
// ASSERT: scan-not stack trace

import stdx.effect.*
// ^ Requires switching many internal things in stdx.effect to public

class Deferred3 <: Command<Unit> {}
class Immediate3 <: Command<Unit> {}

class MyException2 <: Exception {}

func main3() {
    try {
        let frame2 = DeferredFrame<Int64> {
            let frame = DeferredFrame<Int64> {
                HandlerFrame.perf(Immediate3())
                return 34
            }
            let handler: HandlerFn<Immediate3, Unit, Int64> = { _: Immediate3, _: ResumptionInternal<Unit, Int64> =>
                return 42
            }
            frame.setDeferredHandler<Immediate3, Unit>(handler) 
            33
        }
        frame2.setImmediateHandler<Immediate3, Unit, Int64> {_: Immediate3 =>
            //43
            ImmediateHandlerReturn.Exc(MyException2())
        }
        let x: Int64 = frame2.start()
        0
    } catch(_: MyException2) {
        println("caught exception successfully")
        return 0
    }
}
