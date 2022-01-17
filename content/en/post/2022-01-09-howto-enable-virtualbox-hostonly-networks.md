---

date: 2022-01-09
title: 'HowTo: Enable all IP ranges for VirtualBox host-only adapters'

---

<!--more-->

Let's say you need to spin up a VirtualBox machine that requires a Class A IP
for its host-only network. All the sudden, it halts the provisioning process and
prints out the following message:

```
The IP address configured for the host-only network is not within the
allowed ranges. Please update the address used to be within the allowed
ranges and run the command again.

  Address: 10.135.135.100
  Ranges: 192.168.56.0/21

Valid ranges can be modified in the /etc/vbox/networks.conf file. For
more information including valid format see:

  https://www.virtualbox.org/manual/ch06.html#network_hostonly
```

You glanced at the suggested
[documentation](https://www.virtualbox.org/manual/ch06.html#network_hostonly),
but since you are in a hurry missed the part where it clearly says how to enable
all IP ranges for the host-only adapters. So, you just google it, and here we
are :)

## Step-by-Step solution

1. As super user (root or sudoer), ensure the `/etc/vbox` directory exists
2. As super user (root or sudoer), write  `* 0.0.0.0/0 ::/0` into the `/etc/vbox/networks.conf` file 
3. Done. No restart is required

```shell
# tl;dr give me the code!
$ sudo mkdir /etc/vbox
$ echo '* 0.0.0.0/0 ::/0' | sudo tee /etc/vbox/networks.conf
```

## Side note

It might look dumb that I wrote a post about something that is already
[documented](https://www.virtualbox.org/manual/ch06.html#network_hostonly). But
I was that hasty person googling this issue hoping to get lucky back then, so I
felt the need to spell it out to anyone else in the same situation. "Homies help
homies, always."

PS: The `*` at the beginning of every entry in the `networks.conf` file is
**mandatory**. In my rush, I overlooked it and it gave me a mild headache for
free.



