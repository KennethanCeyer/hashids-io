#!/usr/bin/env io
#
# this is custom test code for testing hashids
#
# this is part of io-hashids. https://github.com/KennethanCeyer/io-hashids
#
# (C) 2017-2019 Kenneth Ceyer <kenneth@pigno.se>
# this is distributed under a free software license, see LICENSE

# import hashids
doRelativeFile("../hashids/hashids.io")

# custom test codes
# honestly it is not a test spec
h := hashids()
h decode("GZgIW9I09") println
// h decode("Ggh9T9") println
// id := h decode("o2fXhV")
// id println