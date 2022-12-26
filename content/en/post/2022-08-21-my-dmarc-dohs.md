---

date: 2022-08-21
title: "My DMARC d'ohs"

---

<!--more-->

This entry will be more informal since I want to share what I have learned about
DMARC so far, with stumbles and all.

## What is DMARC?

DMARC stands for "Domain-based Message Authentication, Reporting & Conformance,"
which is best explained [here](https://dmarc.org/)

However, to my understanding, DMARC allows a domain owner/administrator to
signal to the email providers which emails sent on "your domain's behalf" are
legit and which aren't.

## Should I enable DMARC for my domain?

Well, it depends.

Technically, we should always enable it since anybody could send emails saying
they represent said domain by adding some extra metadata fields on their end,
[AKA email spoofing](https://support.google.com/a/answer/2466580?hl=en#:~:text=DMARC%20is%20a%20standard%20email,an%20email%20message%20is%20forged).
Also, as long you have admin powers over said domain records, it is trivial to
enable it.

The golden question is, *do you know which services you or your company are
emailing on your behalf?* (ie: mailgun, Shopify, any CRM) If the answer is no,
then don't do it yet, and if the answer is yes, please double-check your
assumptions.

Why should I be that careful? Mainly because it is so tempting and easy to jump
to enforce the most strict policy from the beginning and **d'oh!** Suddenly, your
clients/subscribers stopped receiving emails with a simple DNS record update.

## Then, how can I safely enable it?

To answer that we need to cover the DMARC levels of enforcement at your disposal:

- **none** - Do nothing but notify the domain administrator email (RUA)
- **quarantine** - Flag any email from "unauthenticated" senders as spam
- **reject** - Bounce any email from "unauthenticated" senders

Having that in mind, we can talk about tactics. The best approach is to start
from "none" enforcement and, when you have a better understanding, move to the
next enforcement level, "quarantine", then rinse and repeat. While doing this,
you will start noticing which services or third-party integrations are sending
emails on your domain's behalf and act accordingly. Most of the time, they
already have a knowledge base article stating what needs to be configured, so
they comply with the DMARC policies under your domain.

Now you would be thinking *«but you didn't share how to actually enable this»*,
and you'd be right. Unfortunately, the procedure varies depending on your domain
registrar/provider and the third-party integrations you want to continue letting
send emails on your domain's behalf. But it can be summarized as adding or
updating a txt DNS record under your domain, then adding extra fields on said
record per third-party integration.

## How can I check the existing DMARC policies for my domain?

Let's think your domain is `mydomain.tld`, and since all the DMARC
configurations end up being published as a `TXT` record pointing to the `_dmarc`
subdomain, you can use tools like `nslookup`. It would look like this:

```sh
$ nslookup -type=mx -type=txt _dmarc.mydomain.tld
Server:		192.168.86.1
Address:	192.168.86.1#53

Non-authoritative answer:
_dmarc.mydomain.tld	text = "v=DMARC1; p=none; pct=100; rua=mailto:domainadmin@mydomain.tld
```

What this response says is:

- There is a TXT record enabling DMARC
- The existing enforcement policy is none
- All DMARC reports must be sent to `domainadmin@mydomain.tld`

## Why is the RUA email receiving so many reports?

Well, that's part of the DMARC specification. All the email providers should
report the summary of email traffic received on your domain's behalf to the
email address you advertised as the RUA.

The idea behind these reports is to give enough monitoring data to the domain
administrator; still, this is a lot of raw data in a not-so-human-friendly
format. Because of that, plenty of third-party platforms offer a more
straightforward way to digest these reports, but if you are looking for
something that runs locally, you could experiment with the
[dmarc-visualizer](https://github.com/debricked/dmarc-visualizer).

Technically, with these reports, you can tell which other when to move from one
policy into another instead of smoke/scream testing and then rolling back. But
that call it's up to you.

## My two cents

- Enabling DMARC is relatively trivial. The catch comes when determining which
  third-party integrations you want to keep sending emails on your domain's
  behalf.
- When adding these configurations to a company's domain, communication is vital
  since you could break any undocumented third-party email integration.
- The amount of data sent to the RUA email is overwhelming, but there are tools
  to simplify digesting it.
- When in doubt, it is best to implement this policy with `p=none` so you can
  start reading the reports and then know where to move.
