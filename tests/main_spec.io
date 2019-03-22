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

# test core
doRelativeFile("./core_spec.io")

# test implementations
doRelativeFile("./impl_spec.io")
