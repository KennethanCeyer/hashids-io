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
    separatorPadding := 3.5
    guardPadding := 12

    salt ::= ""
    minlen ::= 0
    guards ::= list()
    alphabet ::= "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
    hexAlphabet ::= "0123456789abcdef"
    separators ::= "cfhistuCFHISTU"

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
            id = _getChar(alphabet, input % alphabet size) .. id
            input = (input / alphabet size) floor
            (input <= 0) ifTrue(break)
        )
        return id
    )

    _fromAlphabet := method(input, alphabet,
        input asList \
            map(char, alphabet asList indexOf(char)) \
            reduce(carry, index, carry * alphabet size + index, 0)
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

    # splitting hashid
    _split := method(hashid, splitter,
        result := list()
        part ::= ""
        hashid asList foreach(char,
            if(splitter asString containsSeq(char),
                result append(part)
                part = "",
                part = part .. char))
        result append(part)
    )

    _encode := method(numbers,
        _alphabet ::= alphabet clone
        lotteryPos := numbers map(i, number, number % (i + 100)) sum
        lottery := _getChar(alphabet, lotteryPos % alphabet size)

        result ::= numbers map(i, number,
            buffer := lottery .. salt .. _alphabet
            _alphabet = _shuffle(_alphabet, buffer exSlice(0, _alphabet size))
            result ::= _toAlphabet(number, _alphabet)
            _toAlphabet(number, _alphabet)

            if(i + 1 < numbers size,
                number = number % (_getNumber(result, 0) + i)
                sepsIndex := number % (separators size)
                result = result .. _getChar(separators, sepsIndex)
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
        splitted_ids := _split(hashid, guards)
        hashid = if(splitted_ids size > 1 and splitted_ids size < 4,
            splitted_ids at(1),
            splitted_ids at(0))
        
        (hashid size == 0) ifTrue(return list())

        lottery := _getChar(hashid, 0)
        hashid = hashid exSlice(1)

        splitted_ids = _split(hashid, separators)
        splitted_ids map(id,
            buffer := lottery .. salt .. alphabet
            alphabet = _shuffle(alphabet, buffer exSlice(0, alphabet size))
            _fromAlphabet(id, alphabet)
        )
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

        separators foreach(i, _,
            matchIndex := alphabet asList indexOf(_getChar(separators, i))
            if(matchIndex == nil,
                separators = separators exSlice(0, i) .. " " .. separators exSlice(i + 1),
                alphabet = alphabet exSlice(0, matchIndex) .. " " .. alphabet exSlice(matchIndex + 1)
            )
        )

        separators = separators asList select(char, char != " ") reduce(..)
        separators = _shuffle(separators, salt)
        alphabet = alphabet asList select(char, char != " ") reduce(..)

        if(separators size == 0 or ((alphabet size / separators size) > separatorPadding), 
            separatorsLen := (alphabet size / separatorPadding) ceil
            if(separatorsLen > separators size,
                diff := separatorsLen - separators size
                separators = separators .. alphabet exSlice(0, diff)
                alphabet = alphabet exSlice(diff)
            )
        )

        alphabet = _shuffle(alphabet, salt)
        guardCount := (alphabet size / guardPadding) ceil

        if(alphabet size < 3,
            guards = separators exSlice(0, guardCount) asList
            separators = separators exSlice(guardCount),
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

