package cangjie_test_cases

import stdx.effect.*

class Deferred <: Command<Unit> {}
class Immediate2 <: Command<Unit> {}

func main5() {
    try {
        let x = try {
            perform Immediate2()
            34
        } handle (_: Deferred, res: Resumption<Unit, Int64>) {
            42
        }
        33
    } handle (_: Immediate2) {
        0
    }
}
