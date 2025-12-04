package cangjie_test_cases

import stdx.effect.*
import std.collection.*

class One <: Command<Unit> {}

// stateful handler that counts the number of occurences inside fn?
func severalEffs(): Unit {
    perform One()
    perform One()
    println("hehe")
    perform One()
}

// R ! Effs -> R ! Effs
func countEffs<Cmd, Res, R>(_: Res, rInit: R, fn: () -> R): R where Cmd <: Command<Res> {
    let count : Box<Int> = Box(0)
    let rv : Box<R> = Box(rInit);
    try {
        rv.value = fn()
        println("counted ${count.value} of One effects.")
    } handle (e: Cmd) {
        count.value = count.value + 1
        // reperform the effect
        let o = perform e
        // let o2: Res = countEffs<Cmd, Res, Res>(def, { => e.defaultImpl() })
        resume with o
    }
    return rv.value
}

// R ! (One : Effs) -> R ! Effs
func interpOne<R>(fn: () -> R) {
    try {
        fn()
    } handle (_ : One) {
        resume 
    }
}

main() {
    interpOne { 
        countEffs<One, Unit, Unit>((), (), { => severalEffs() })
    }
    // expected: counted 3 of One effects

    // main1() // outputs Hello
    // println("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
    // main2() // outputs Hello
    // println("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
    // main3() // times out (FAIL)
    // println("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
    // main4() // outputs tasks. (FIXED)
    // println("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
    // main5() // times out (FAIL)
    // println("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
    // main6() // doesn't and shouldn't compile (FAIL)
    // println("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
    // main7() // times out (FAIL)
    // println("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
    // main8() // outpus Hello world!
    // println("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
}