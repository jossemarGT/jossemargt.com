---

date: 2022-02-13
title: 'Alias for pbcopy and pbpaste in GNU Linux'
tags: ['snippet']

---

<!--more-->

You got me, I've been a MacOS user for quite a while now, and I've grown
accustomed to `pbcopy` and `pbpaste`. However, I'm still a Linux user and
whenever I do a fresh GNU Linux install, I always end up googling the following
aliases:

```sh
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'
```
