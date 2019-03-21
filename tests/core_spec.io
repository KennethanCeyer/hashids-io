#!/usr/bin/env io
#
# this is test code for testing the core of hashids
#
# this is part of io-hashids. https://github.com/KennethanCeyer/io-hashids
#
# (C) 2017-2019 Kenneth Ceyer <kenneth@pigno.se>
# this is distributed under a free software license, see LICENSE

# import hashids
doRelativeFile("../hashids/hashids.io")

describe("core",

    # _getChar("hello world", 4) => "o"
    it("should return "o" for _getChar(hello world, 4)", 
        h := hashids()
        expect(h _getChar("hello world", 4)) toBe("o")
    ),

    # _getNumber("hello world", 6) => 119
    it("should return 119 for _shuffle(\"119\")",
        h := hashids()
        expect(h _getNumber("hello world", 6)) toBe(119)
    )

)

describe("encode",

    # encode() => nil
    it("should return "" for encode()",
        h := hashids()
        expect(h encode()) toBe("")
    ),

    # encode() => Exception raise
    it("should raise an Exception for encode(-1)",
        failingSpec := Spec clone
        failingSpec test := method(
            h := hashids()
            h encode(-1)
        )
        failingSpec run
        expect(failingSpec message) toBe("the number must be geater or equal than zero.")
    ),

    # encode(1, 2, 3) with salt `this is my salt`, minLength 8 => "GlaHquq0"
    it("should return "GlaHquq0" for encode(1, 2, 3) with salt "this is my salt", minLength 8",
        h := hashids("this is my salt", 8)
        expect(h encode(1, 2, 3)) toBe("GlaHquq0")
    )

)