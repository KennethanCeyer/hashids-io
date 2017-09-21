#!/usr/bin/env io
#
# this is main code hashids
#
# this is part of io-hashids. https://github.com/KennethanCeyer/io-hashids
#
# (C) 2017-2017 Kenneth Ceyer <kennethan@nhpcw.com>
# this is distributed under a free software license, see LICENSE


# private object
Hashids := Object clone do(
    VERSION ::= "0.0.1"

    salt ::= nil
    minlen ::= nil
    alphabet ::= "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
    hex_alphabet ::= "0123456789abcdef"
    alphabet_len ::= alphabet size
    hex_alphabet_len ::= hex_alphabet size

    # get character from string
    _getChar := method(str, index,
        str at(index) asCharacter
    )

    # get number from string
    _getNumber := method(str, index,
        str at(index) asNumber
    )

    # number to 16 hex string
    _toHex := method(input,
        hash := ""
        loop(
            hash := _getChar(hex_alphabet, (input % hex_alphabet_len)) .. hash
            input := ((input / hex_alphabet_len) floor)
            (input <= 0) ifTrue (break)
        )
        hash
    )

    # shuffle alphabet by salt
    _shuffle := method(salt,
        v := 0
        p := 0

        _alphabet := alphabet clone

        for (i, (alphabet_len - 1), 1, -1,
            v = v % salt size
            a := _getNumber(salt, v)
            p = p + a
            j := (a + v + p) % i

            tmp := _getChar(_alphabet, j)
            _alphabet := _alphabet exSlice(0, j) .. _getChar(_alphabet, i) .. _alphabet exSlice(j + 1)
            _alphabet := _alphabet exSlice(0, i) .. tmp .. _alphabet exSlice(i + 1)
            v = v + 1
        )

        _alphabet
    )
    
    # encode numbers to hashid
    encode := method(
        numbers ::= call message arguments
        if (
            # it must be solve
            # so far, this line is expected to be a bug on io
            numbers select(number, number asString asNumber < 0) size > 0,
            return ""
        )
        numbers
    )

    # decode hashid to numbers
    decode := method(hashid,
        hashid
    )
)


# public access util
hashids := method(salt, minlen, alphabet,
    instance := Hashids clone

    # default variables
    if (alphabet != nil, instance alphabet := alphabet)
    if (salt != nil, instance salt := salt)
    if (minlen != nil, instance minlen := minlen)

    # return hashids object
    instance
)

