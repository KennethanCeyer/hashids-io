
[![hashids](http://hashids.org/public/img/hashids.gif "Hashids")](http://hashids.org/)

[![License][license-image]][license-url] [![Build Status](https://travis-ci.org/KennethanCeyer/hashids-io.svg?branch=master)](https://travis-ci.org/KennethanCeyer/hashids-io)

What is hashids-io
------------------

hashid-io is an implementation of [hashids](http://hashids.org/) for io language.

this libary can be helped to get a unique string from the number.

**beware** this project is not completed yet.

## Getting Started

Install from Git

```bash
$ git clone https://github.com/KennethanCeyer/hashids-io.git
```

## Quick example

```io
# get hashids object
h := hashids()

# encode
id := h encode(1, 2, 3, 4)
id println # v2fWhzi1

# also you can packing param numbers (salt sugaring)
id := h encode(list(1, 2, 3, 4))
id println # v2fWhzi1

# decode
numbers := h decode(id)
numbers println # list(1, 2, 3, 4)
```

## Advanced example

### encode/decode with salt

```io
salt := "this is my salt key"
h := hashids(salt)

# encode
id := h encode(1, 2, 3, 4)
id println # zZHmu0hB

# decode
numbers := h decode(id)
numbers println # list(1, 2, 3, 4)
```

### encode/decode with minLength padding

```io
h := hashids(nil, 8)

# encode
id := h encode(1, 2, 3, 4)
id println #v2fWhzi1

# decode
numbers := h decode(id)
numbers println # list(1, 2, 3, 4)
```

## Test

hashid-io supports the unit test using by [jasmine](https://github.com/bekkopen/jasmineio).

```bash
# test using shell
$ sh ./run_test.sh
```

License
-------

The MIT License (MIT)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

---

MIT License. See the LICENSE file. You can use Hashids in open source projects and commercial products. Don't break the Internet. Kthxbye.

[license-url]: https://github.com/ivanakimov/hashids.js/blob/master/LICENSE
[license-image]: https://img.shields.io/packagist/l/hashids/hashids.svg?style=flat
