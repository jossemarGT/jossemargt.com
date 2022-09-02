---

date: 2022-02-06
title: 'HowTo: Set contextual git identities'

---

<!--more-->

This post is a follow-up to the
[HowTo: Set contextual git configurations](en/post/2022-01-16-howto-set-contextual-git-configurations/)
one. And it won't be a surprise, but I chose to share it primarily for my future
self since the topic is pretty easy to find using a search engine, but everybody
calls it differently.

## The problem

If you didn't know, services like GitHub and GitLab associate the private
encryption key you provided to them in a 1-to-1 relationship with your account.
In other words, if you have multiple accounts on said platform and your
preferred git transport is SSH, you must create and upload a key pair for each
account.

Honestly, creating and uploading key pairs is a trivial process. However, from
time to time, you could forget to set the correct identity on your ssh-agent
before doing a `git push`, and then you have the unsettling situation where your
PR looks like *someone else tried to hijack your work*.

<!-- TODO: Image of me screwing up a PR -->

The good thing is that we have ways to work around this.

## Solution 1 - Override the ssh-agent configurations

Let's say you have two GitHub (or GitLab) accounts `iDev` and `iCorpDev`
respectively, from which you want to use the latter as the default one.

1. Create the ssh key pair for each account. (ie: `id_rsa_me` and `id_rsa_corp`)
2. Upload the respective private key to each of the GitHub accounts
3. Create an ssh configuration file (`~/.ssh/config`) if there isn't one already
4. Add ssh configuration entries for each of those GitHub accounts (see the code snippet below)
  a. Make sure each uses a different `Host` identifier, which must be an FQDN
  b. Make sure both have github.com as its `Hostname`
5. You are set! But remember to use the correct URLs when cloning
  a. The URI `git@github.com:an-owner/a-repository.git` will make the ssh-agent to use `id_rsa_corp`
  b. The URI `git@me.github.com:an-owner/a-repository.git` will make the ssh-agent to use `id_rsa_me`

```ssh-config
# Identify as iCorpDev
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_rsa_corp

# Identify as iDev
Host me.github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_rsa_me
```

If you haven't spotted the *trick* yet, it is on the domain your git remote is
using when cloning personal projects, which for the example above, will be
`me.github.com`. Worth noting that the domain you'll use does not even have to
exist as long we have the correct one in the `Hostname` field, and its only
purpose is to let the ssh-agent know the configuration we are requesting it to
use.

## Solution 2 - Use HTTPS and GitHub Personal Access Tokens

First, this only works for GitHub, and for this scenario, let's say you have two
accounts `iDev` and `iCorpDev` respectively, from which you want to use the
latter as the default one.

1. On GitHub, create a personal access token **only for your personal account**. [(reference)](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
2. On your terminal, configure git to use the `iDev` user and the Access Token as its password (see the code snippet below) every time you interact with a repository with a remote prefixed with `https://github.com/iDev`.
3. Try it out! Once you clone over HTTPS transport, git will automatically know which credentials to use.

```shell
# For this example the user will be "iDev" and the token "a-fake-token".
# Please update them accordingly
$ GH_USER='iDev'
$ GH_TOKEN='a-fake-token'
$ git config --global --add url."https://${GH_USER}:${GH_TOKEN}@github.com/${GH_USER}".insteadOf "https://github.com/${GH_USER}"
```

For anything else that is not your `iDev` account, git will ask you for
credentials. Still, for that matter, you could either configure the other
account credentials globally or use the SSH key as usual.

## Conclusion

I don't think either solution is a clear-cut one, so it is up to you to pick the
one that fits better with you. Before I forget, let me share the credit with the
following posts that allowed me to learn about these approaches:

- [Using Multiple SSH keys - Beginner Friendly.md](https://gist.github.com/aprilmintacpineda/f101bf5fd34f1e6664497cf4b9b9345f)
- [Use multiple ssh-keys for different git accounts on the same computer](https://vanthanhtran245.github.io/use-multiple-ssh-key-for-different-git-accounts/)
- [Multiple SSH Keys settings for different github account](https://gist.github.com/jexchan/2351996)
