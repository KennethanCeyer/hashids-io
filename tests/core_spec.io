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
    ),

    it("should be cfhistuCFHISTU with separators when none initial parameter given",
        h := hashids()
        expect(h separators) toBe("cfhistuCFHISTU")
    )

)

describe("encode",

    # encode() => ""
    it("should return "" for encode()",
        h := hashids()
        expect(h encode()) toBe("")
    ),

    # encode(-1) => Exception raise
    it("should raise an Exception for encode(-1)",
        failingSpec := Spec clone
        failingSpec test := method(
            h := hashids()
            h encode(-1)
        )
        failingSpec run
        expect(failingSpec message) toBe("the number must be geater or equal than zero.")
    ),

    # encode(list(-1)) => Exception raise
    it("should raise an Exception for encode(list(-1))",
        failingSpec := Spec clone
        failingSpec test := method(
            h := hashids()
            h encode(list(-1))
        )
        failingSpec run
        expect(failingSpec message) toBe("the number must be geater or equal than zero.")
    ),

    # encode(1, 2, 3, 4, 5) => "ADf9h9i0sQ"
    it("should return "ADf9h9i0sQ" for encode(1, 2, 3, 4 ,5)",
        h := hashids()
        expect(h encode(1, 2, 3, 4, 5)) toBe("ADf9h9i0sQ")
    ),

    # encode(list(6, 0, 4, 0, 0)) => "v8ujcAsxcm"
    it("should return "v8ujcAsxcm" for encode(list(6, 0, 4, 0, 0))",
        h := hashids()
        expect(h encode(list(6, 0, 4, 0, 0))) toBe("v8ujcAsxcm")
    ),

    # encode(1, 2, 3) with salt `this is my salt`, minLength 8 => "GlaHquq0"
    it("should return "GlaHquq0" for encode(1, 2, 3) with salt "this is my salt", minLength 8",
        h := hashids("this is my salt", 8)
        expect(h encode(1, 2, 3)) toBe("GlaHquq0")
    ),

    # encode(100, 200, 300, 400, 500) => "ElGh1jcQlHzYSXv"
    it("should return "ElGh1jcQlHzYSXv" for encode(100, 200, 300, 400, 500)",
        h := hashids()
        expect(h encode(100, 200, 300, 400, 500)) toBe("ElGh1jcQlHzYSXv")
    )

)

describe("decode",

    # decode() => list()
    it("should return empty list for decode()",
        h := hashids()
        expect(h decode() size) toBe(0)
    ),

    # decode("o2fXhV") => list(1, 2, 3)
    it("should return (1, 2, 3) list for decode("o2fXhV")",
        h := hashids()
        expect(h decode("o2fXhV")) toBe(list(1, 2, 3))
    )

)

describe("encode & decode",

    # encode(100, 200 , 300) decode() => list(100, 200, 300)
    it("should return list(100, 200, 300) for encode and decode of (100, 200, 300)",
        h := hashids()
        expect(h decode(h encode(100, 200, 300))) toBe(list(100, 200, 300))
    )

)