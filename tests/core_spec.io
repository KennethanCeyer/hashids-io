#!/usr/bin/env io
#
# this is test code for testing the core of hashids
#
# this is part of io-hashids. https://github.com/KennethanCeyer/io-hashids
#
# (C) 2017-2017 Kenneth Ceyer <kennethan@nhpcw.com>
# this is distributed under a free software license, see LICENSE

# an io-hashids object
h := hashids()

describe("core",

    # _getChar("hello world", 4) => "o"
    it("should return "o" for _getChar(hello world, 4)", 
        expect(h _getChar("hello world", 4)) toBe("o")
    ),

    # _getNumber("hello world", 6) => 119
    it("should return 119 for _shuffle(\"119\")",
        expect(h _getNumber("hello world", 6)) toBe(119)
    )

)