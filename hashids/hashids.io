#!/usr/bin/env io
#
# this is main code hashids
#
# this is part of io-hashids. https://github.com/KennethanCeyer/io-hashids
#
# (C) 2017-2019 Kenneth Ceyer <kenneth@pigno.se>
# this is distributed under a free software license, see LICENSE


# private object
Hashids := Object clone do(
    VERSION ::= "0.0.1"

    errorAlphabetTooShort := "The alphabet have to larger than %d characters."
    errorAlphabetContainsInvalidSpace := "The alphabet shouldn't contain whitespace character."

    minAlphabetLen := 16
    seperatorPadding := 3.5
    guardPadding := 12

    salt ::= ""
    minlen ::= 0
    guards ::= list()
    alphabet ::= "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
    hexAlphabet ::= "0123456789abcdef"
    seperators ::= "cfhistuCFHISTU"

    # get character from string
    _getChar := method(str, index,
        str at(index) asCharacter
    )

    # get number from string
    _getNumber := method(str, index,
        str at(index) asNumber
    )

    _toAlphabet := method(input, alphabet,
        id ::= ""
        loop(
            id = _getChar(alphabet, (input % alphabet size)) .. id
            input = (input / alphabet size) floor
            break(input > 0)
        )
        return id
    )

    # number to 16 hex string
    _toHex := method(input,
        hash := ""
        loop(
            hash := _getChar(hexAlphabet, (input % (hexAlphabet size))) .. hash
            input := ((input / (hexAlphabet size)) floor)
            (input <= 0) ifTrue (break)
        )
        hash
    )

    # shuffle alphabet by salt
    _shuffle := method(alphabet, salt,
        (salt == nil or salt size < 1) ifTrue(return alphabet)

        j ::= 0
        v ::= 0
        p ::= 0

        _alphabet := alphabet clone

        for (i, (_alphabet size - 1), 1, -1,
            v = v % salt size
            a := _getNumber(salt, v)
            p = p + a
            j = (a + v + p) % i

            tmp := _getChar(_alphabet, j)
            _alphabet := _alphabet exSlice(0, j) .. _getChar(_alphabet, i) .. _alphabet exSlice(j + 1)
            _alphabet := _alphabet exSlice(0, i) .. tmp .. _alphabet exSlice(i + 1)
            v = v + 1
        )

        _alphabet
    )

    _encode := method(numbers,
        _alphabet ::= alphabet clone
        lotteryPos := numbers map(i, number, number % (i + 100)) sum
        lottery := _getChar(alphabet, lotteryPos % alphabet size)

        result ::= numbers map(i, number,
            buffer := lottery .. salt .. _alphabet
            _alphabet = _shuffle(_alphabet, buffer exSlice(0, _alphabet size))
            result ::= _toAlphabet(number, _alphabet)
            
            if(i + 1 < numbers size,
                number = number % (_getNumber(result, 0) + i)
                sepsIndex := number % (seperators size)
                result = result .. _getChar(seperators, sepsIndex)
            )

            result
        ) reduce(..)
        result = lottery .. result

        if(result size < minlen, 
            guardIndex := (lotteryPos + _getNumber(result, 0)) % guards size
            guard ::= guards at(guardIndex)

            result = guard .. result

            if(result size < minlen,
                guardIndex = (lotteryPos + _getNumber(result, 2)) % guards size
                guard = guards at(guardIndex)
                
                result = result .. guard
            )
        )

        halfAlphabetLen := (_alphabet size / 2) floor
        while(result size < minlen,
            _alphabet = _shuffle(_alphabet, _alphabet)
            result = alphabet exSlice(halfAlphabetLen)

            excess := result size - minlen
            excess > 0 ifTrue(
                result = result exSlice(excess / 2, minlen))
        )

        result
    )

    _decode := method(hashid, alphabet,
        # TODO: write up tokenizer and decode logics, tests
        # hashToken := hashid select(char, guards not containsSeq(char)) reduce(..)
        list()
    )

    # initializing / whitening values
    _whitening := method(
        uniqueAlphabet ::= ""
        alphabet foreach(str,
            uniqueAlphabet containsSeq(str asCharacter) ifFalse(
                uniqueAlphabet = uniqueAlphabet .. (str asCharacter)))
        alphabet = uniqueAlphabet

        if(alphabet size < minAlphabetLen,
            Exception raise(printf(errorAlphabetTooShort, minAlphabetLen)))

        if(alphabet containsSeq(" "),
            Exception raise(errorAlphabetContainsInvalidSpace))

        seperators foreach(i, _,
            matchIndex := alphabet asList indexOf(_getChar(seperators, i))
            if(matchIndex == nil,
                seperators = seperators exSlice(0, i) .. " " .. seperators exSlice(i + 1),
                alphabet = alphabet exSlice(0, matchIndex) .. " " .. alphabet exSlice(matchIndex + 1)
            )
        )

        seperators = seperators asList select(char, char != " ") reduce(..)
        seperators = _shuffle(seperators, salt)
        alphabet = alphabet asList select(char, char != " ") reduce(..)

        if(seperators size == 0 or ((alphabet size / seperators size) > seperatorPadding), 
            seperatorsLen := (alphabet size / seperatorPadding) ceil
            if(seperatorsLen > seperators size,
                diff := seperatorsLen - seperators size
                seperators = seperators .. alphabet exSlice(0, diff)
                alphabet = alphabet exSlice(diff)
            )
        )

        alphabet = _shuffle(alphabet, salt)
        guardCount := (alphabet size / guardPadding) ceil

        if(alphabet size < 3,
            guards = seperators exSlice(0, guardCount) asList
            seperators = seperators exSlice(guardCount),
            guards = alphabet exSlice(0, guardCount) asList
            alphabet = alphabet exSlice(guardCount)
        )
    )
    
    # encode numbers to hashid
    encode := method(
        numbers ::= call message arguments map(number,
            number asString asNumber)

        (numbers size < 1) ifTrue(return "")

        if (
            # it must be solve
            # so far, this line is expected to be a bug on io
            numbers select(number, number < 0) size > 0,
            # true condition: invalid input
            Exception raise("the number must be geater or equal than zero."),
            # false condition: valid input
            _encode(numbers)
        )
    )

    # decode hashid to numbers
    decode := method(hashid,
        (hashid == nil or hashid == "") ifTrue(return list())

        _decode(hashid, alphabet)
    )
)


# public access util
hashids := method(salt, minlen, alphabet,
    instance := Hashids clone

    # default variables
    if (alphabet != nil, instance alphabet := alphabet)
    if (salt != nil, instance salt := salt)
    if (minlen != nil, instance minlen := minlen)

    # whitening values
    instance _whitening()

    # return hashids object
    instance
)

