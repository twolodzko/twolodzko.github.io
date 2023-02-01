#!/usr/bin/env rust-script

fn fizz(num: i32) -> Result<i32, String> {
    if num % 3 == 0 {
        return Err(String::from("fizz"));
    }
    Ok(num + 3)
}

fn buzz(num: i32) -> Result<i32, String> {
    if num % 5 == 0 {
        return Err(String::from("buzz"));
    }
    Ok(num + 5)
}

fn fizzbuzz(num: i32) -> Result<i32, String> {
    buzz(fizz(num)?)
}

fn main() {
    for i in 1..100 {
        match fizzbuzz(i) {
            Ok(num) => println!("{i} => {num}"),
            Err(msg) => println!("{i} => Error: {msg}"),
        }
    }
}
