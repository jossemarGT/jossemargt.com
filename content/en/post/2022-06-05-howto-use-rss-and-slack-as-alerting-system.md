---

date: 2022-06-05
title: 'HowTo: Use RSS and Slack as low cost alert system for third-parties'

---

<!--more-->

Let's say you are getting ready for a product demo or routinary
deployment, and suddenly things start misbehaving without you even changing a
thing. I wouldn't blame you if your first thought was *did we release something
that went south just recently?* However, you checked with the engineering crew
that everything was nominal a few minutes ago. Then bingo, it turns out your
cloud provider was having problems in the same data center your solution is
running, but it took you about 20 minutes to get to this conclusion.

Unfortunately, there is no simple or cheap solution to defend your software when
a cloud provider or third-party integration has availability problems. Still, I
can share an inexpensive way to reduce the guesswork next time it happens as
long they publish their incidents via RSS.


## Step-by-step

In this example, we'll focus on how to set up Slack to notify AWS or GCP
incidents through RSS. However, this approach also works with several PaaS (ie,
[Github](https://www.githubstatus.com/history.atom)).

1. Make sure your Slack workspace has the [RSS Slack application installed](https://slack.com/help/articles/218688467-Add-RSS-feeds-to-Slack)
2. Get the RSS URL for the system you want to be alerted to.
    - GCP only has the [Cloud status page](https://status.cloud.google.com/) (You'll find the RSS link in the footer)
    - AWS offers a more granular RSS per service per region, and these can be found within the [AWS Health Dashboard](https://health.aws.amazon.com/health/status)
3. Configure the Slack RSS application to post every RSS update on a specific channel. 
    - I suggest having an independent channel since these notifications are pretty noisy.
4. You are set. 

Now you have a slack channel with the most recent update from your cloud
provider or third-party integration without spending any extra penny.
