---

date: 2022-01-16
title: 'HowTo: Set contextual git configurations'
tags: ['git']

---

<!--more-->

Let's say you already have all the git set up on your workstation done. But by
the whims of fate, you are about to contribute to several git projects with a
different email address. Since you are unwilling to manually set said override
per repository or replace your email address globally, you wonder if we instruct
git to use different email addresses depending on the working directory?

The answer is **yes**, and it already lingers on the official
[documentation](https://git-scm.com/docs/git-config#_conditional_includes).
Still, here you can find a quick guide for it.

## Step-by-step guide

For simplicity, we will assume all the projects with different email addresses
are under the **same** directory `$HOME/not-batman`, and the email address in
question is `lucius.fox@wayne.net`

1. Create a git configuration file, preferably within your `$HOME`. For example `$HOME/not-batman/.gitconfig`
2. Set the alternative email address on the new git configuration file, using the `git config` command with the `-f` flag followed by the alternative configuration file path.
3. Using your preferred editor, add the following `includeIf` statement  (use code snippet below) to your global git configuration. 
4. Done! 

```shell
# Create git config override file
$ touch $HOME/not-batman/.gitconfig
# Add alternative email to git config override file
$ git config -f $HOME/not-batman/.gitconfig user.email "lucius.fox@wayne.net"
# Add contextual (or conditional) configuration to global git config
$ cat << EOF >> $HOME/.gitconfig
[includeIf "gitdir:~/not-batman/"]
  path = ~/not-batman/.gitconfig
EOF
```

You can query the git configuration values on any git repository within the
alternative path to verify it is working correctly.

```shell
$ cd $HOME/not-batman/bat-goggles
$ git config --get user.email
lucius.fox@wayne.net
```

## Side note

Confession time! I wrote this post primarily for my future self since it is
pretty easy to google this, but everybody calls it differently. Let me prove my
point with a couple of links, remember we all are talking about the same thing:

- [Set git config values for all child folders](https://stackoverflow.com/questions/21307793/set-git-config-values-for-all-child-folders/)
- [Is it possible to have different git configuration for different projects?](https://stackoverflow.com/questions/8801729/is-it-possible-to-have-different-git-configuration-for-different-projects)
- [How to handle multiple git configurations in one machine](https://www.freecodecamp.org/news/how-to-handle-multiple-git-configurations-in-one-machine/)
