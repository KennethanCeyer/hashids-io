
[![hashids](http://hashids.org/public/img/hashids.gif "Hashids")](http://hashids.org/)

[![License][license-image]][license-url]

What is io-hashids
------------------

io-hashid is an implementation of [hashids](http://hashids.org/) for io language.

this libary can be helped to get a unique string from the number.

**beware** this project is not completed yet.

Usage
-----

Install from Git

```bash
$ git clone git@github.com:KennethanCeyer/io-hashids.git
```

```io
# get hashids object
h = hashids()

# encode
id = h encode("1234")
id print # 9xABBQAv

# decode
h decode(id) # 1234
```

Test
----

io-hashid supports the unit test using by [jasmine](https://github.com/bekkopen/jasmineio).

```bash
# current path is io-hashids
pwd
> {path}/io-hashids

# install jasmine from Git
$ git clone git@github.com:bekkopen/jasmineio.git

# test using jasmine
io ./jasmineio/jasmine.io ./tests/main_spec.io
```

License
-------

MIT License. See the [LICENSE](LICENSE) file. You can use Hashids in open source projects and commercial products. Don't break the Internet. Kthxbye.

[license-url]: https://github.com/ivanakimov/hashids.js/blob/master/LICENSE
[license-image]: https://img.shields.io/packagist/l/hashids/hashids.svg?style=flat
