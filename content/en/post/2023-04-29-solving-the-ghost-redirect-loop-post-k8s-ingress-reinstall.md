---

date: 2023-04-29
title: "Solving the Ghost redirect loop post Ingress Controller re-install"
tags: ['learnings']

---

<!--more-->

after migration the blog didn't work it was on a "redirect loop"

<https://ghost.org/docs/faq/proxying-https-infinite-loops/>

one of the things migrated was the ingrss controller

it was a big jump from a 3yrs old one to the latest and greates

I ovelooked a single configuration

Googled for solutions and only found Ghost configurations

These configurations work for "classic" blog hosting

nginx-ingress is not one of their objectives

googled more and alld the rows lead me to nginx-ingress documentation

the documentation is not frased on a way one can say "oh Iḿ  missing this thatś  why this doesnt work"

It's clear and extensive but you need to know what you're looking for

Read nginx controller logs. Read ghost logs. 

One shows the request, the other shows the redirect

redirect loop happens when the request gets into Ghost without the proper headers,

So Ghost replies 301 even though the proxy in front of it is serving the certs

But ghost still "thinks" the request goes in a insecure way

```
Browser -- HTTPS --> AWS ELB -- HTTP --> NGINX -- HTTP ---> Ghost
```

after pain, I stumbled with these very old tickets

with someone trying to do the same as me, forcing said headers through annotations

<https://github.com/kubernetes/ingress-nginx/issues/8195#issuecomment-1326425677>

when in reality it was matter of adding a global configuration

frankly I passed trhough that comment several times until I read it

<https://github.com/kubernetes/ingress-nginx/issues/1957#issuecomment-462826897>

This was introduced since v0.22.0 ... ... ... now using  v1.5.1, it was a default setting in the past

<https://kubernetes.github.io/ingress-nginx/>
