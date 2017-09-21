#!/usr/bin/env io
#
# this is custom test code for testing hashids
#
# this is part of io-hashids. https://github.com/KennethanCeyer/io-hashids
#
# (C) 2017-2017 Kenneth Ceyer <kennethan@nhpcw.com>
# this is distributed under a free software license, see LICENSE

# import hashids
doRelativeFile("../hashids/hashids.io")

# custom test codes
# honestly it is not a test spec
h := hashids("salt")
id := h encode(1, 2, 3, -1)
id println
