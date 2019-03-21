
[![hashids](http://hashids.org/public/img/hashids.gif "Hashids")](http://hashids.org/)

[![License][license-image]][license-url] [![Build Status](https://travis-ci.org/KennethanCeyer/io-hashids.svg?branch=master)](https://travis-ci.org/KennethanCeyer/io-hashids)

What is hashids-io
------------------

hashid-io is an implementation of [hashids](http://hashids.org/) for io language.

this libary can be helped to get a unique string from the number.

**beware** this project is not completed yet.

Usage
-----

Install from Git

```bash
$ git clone git@github.com:KennethanCeyer/hashids-io.git
```

```io
# get hashids object
h := hashids()

# encode
id := h encode(1, 2, 3, 4)
id println # 9xABBQAv

# decode
h decode(id) # list(1, 2, 3, 4)
```

Test
----

hashid-io supports the unit test using by [jasmine](https://github.com/bekkopen/jasmineio).

```bash
# test using shell
$ sh ./run_test.sh
```

License
-------

MIT License. See the [LICENSE](LICENSE) file. You can use Hashids in open source projects and commercial products. Don't break the Internet. Kthxbye.

[license-url]: https://github.com/ivanakimov/hashids.js/blob/master/LICENSE
[license-image]: https://img.shields.io/packagist/l/hashids/hashids.svg?style=flat
