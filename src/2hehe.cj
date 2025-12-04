package cangjie_test_cases

import stdx.effect.{Command, Resumption}

class Get2 <: Command<String> {}

func stackOverFlow(): Int64 {
    stackOverFlow() + 1
}

func main2() {
    try {
        try {
            stackOverFlow()
            ()
        } handle (_: Get2, next: Resumption<String, Unit>) {
            println("Never")
        }
    } catch (_: Error) {
        println("Hello")
    }
    0
}