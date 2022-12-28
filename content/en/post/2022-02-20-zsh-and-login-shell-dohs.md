---

date: 2022-02-20
title: "zsh and the login shell d'ohs"
tags: ['learnings']

---

<!--more-->

So, here I was doing a Debian-based GNU Linux fresh install. I set up my
UI-based tools, picked KDE as my desktop environment, and then moved to set up
my command-line tools when I installed my preferred shell `zsh` from the package
manager, all the sudden **d'oh!** The UI-based application launchers (AKA
desktop icons) stopped working after a quick reboot.

To make the long story short, I realized that the problem boiled down to the
`zsh` package taking the liberty of setting itself as the default login shell as
a post-install step. Since `zsh` does not support some `bash` specific features,
the scripts that used to load the `XDG_*` environment variables upon session
login never ran, and everything else in UI land went south from there.

I never looked up how to disable these post-install scripts, and I bet the
answer is a few google searches away. Anywho, I preferred to fix this problem by
updating my user login shell through `chsh`, which did the trick. In case you
were wondering, it looks like something like this.

```sh
chsh --shell /bin/bash <username>
```

It's funny how now I can tell this as a matter of a quick post, but believe me,
this was a quite annoying head-scratcher back then 😅
