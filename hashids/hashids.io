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
    version := "0.0.1"
    alphabet := "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
    hexAlphabet := "0123456789abcdef"
    alphabetLength := alphabet size
    hexAlphabetLength := hexAlphabet size

    # number to 16 hex string
    _toHex := method(input,
        hash := ""
        loop(
            hash := (hexAlphabet at(input % hexAlphabetLength) asCharacter) .. hash
            input := ((input / hexAlphabetLength) floor)
            (input <= 0) ifTrue (break)
        )
        hash
    )
    
    # encode plain text to unique string
    encode := method(plain,
        return
    )
)


# public access util
hashids := method(salt, len, alphabet,
    instance := Hashids clone

    # default variables
    if (alphabet != nil, instance alphabet := alphabet)

    # return hashids object
    instance
)

