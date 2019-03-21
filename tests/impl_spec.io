#!/usr/bin/env io
#
# this is test code for testing the fundamental of hashids
#
# this is part of io-hashids. https://github.com/KennethanCeyer/io-hashids
#
# (C) 2017-2019 Kenneth Ceyer <kenneth@pigno.se>
# this is distributed under a free software license, see LICENSE

# import hashids
doRelativeFile("../hashids/hashids.io")
h := hashids()

describe("implementations",

    # _toHex(1234) => "4d2"
    it("should return \"4d2\" for _toHex(1234)", 
        expect(h _toHex(1234)) toBe("4d2")
    ),

    # _shuffle("abc1") => "cUpI6isqCa0brWZnJA8wNTzDHEtLXOYgh5fQm2uRj4deM91oB7FkSGKxvyVP3l"
    it("should return cUpI6isqCa0brWZnJA8wNTzDHEtLXOYgh5fQm2uRj4deM91oB7FkSGKxvyVP3l for _shuffle(\"abc1\")",
        alphabet := "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        expect(h _shuffle(alphabet, "abc1")) toBe("cUpI6isqCa0brWZnJA8wNTzDHEtLXOYgh5fQm2uRj4deM91oB7FkSGKxvyVP3l")
    )

)