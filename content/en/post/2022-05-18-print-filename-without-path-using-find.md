---

date: 2022-05-18
title: 'Print filename without the path when using find'
tags: ['snippet']

---

<!--more-->

Have you written a clever script that relies on the `find` command output, and
you wish you could get rid of the parent path for one reason or another?

If you remove it manually with another GNU util or even manually, I don't blame
you since I have done the same thing more than once. However, the funny thing is
that find already offers this out of the box, which is
[documented already](https://www.gnu.org/software/findutils/manual/html_mono/find.html#Name-Directives),
it just happens not to be that obvious.

So let's say you are looking for all the GNU Linux binaries **names** which do
not have any extension and you don't want their path.

```sh
$ find dist/bundle -type f -not -name '*.exe' -not -name '*.ps*' -printf '%P\n'
binary-one
binary-two
binary-three
```

And in case you were wondering this is how the output would look like without
the `-printf '%P\n'` operator

```sh
$ find dist/bundle -type f -not -name '*.exe' -not -name '*.ps*'
dist/bundle/binary-one
dist/bundle/binary-two
dist/bundle/binary-three
```
