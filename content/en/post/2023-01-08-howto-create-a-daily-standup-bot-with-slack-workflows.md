---

date: 2023-01-08
title: 'HowTo: Create a daily standup bot with Slack workflows'
tags: ['slack']

---

<!--more-->

I recall long ago when I struggled to justify a "standup bot" Slack integration
in our team expenses, pushing us to axe it 🤷. The fun part is that since we were
already on a Slack paid subscription, we didn't need such thing since I could have
used
[Slack workflows](https://slack.com/help/articles/360053571454-Set-up-a-workflow-in-Slack)
to replicate this bot behavior.

Before jumping into the solution, let's talk about the features I needed to replicate:

- I need a _thing_ that reminds the team to write down their Standup updates
  within the same thread
- I need this _thing_ to put such reminders on a specific Slack channel
- I need this _thing_ to share these reminders only on working days

## Step-by-step solution

- On the Slack desktop client, click your workspace name in the top left
- Select `Tools` > `Workflow Builder`, which opens a new window
- Click on `Create new workflows`
- Name the workflow the way you like (I often go with _standup bot_ or similar)
- Select the `Scheduled date & time` trigger
- Fill in the requested information for this trigger and make sure that the
  `Frequency` field is set to `Every weekday`
- Once you get back to the workflow window, select `Add step` > `Send a message`
- On the new window, select the target channel and the message to be displayed
  by the workflow, which should include instructions for the standup
- And that's it! Enjoy your "standup bot" workflow

If you don't get it the way you like the first time, it is okay you can tweak it
as much as you like. In the end, what matters is having the proper interactions
within your team, and the tools are just a means to facilitate them
([Agile manifesto](https://agilemanifesto.org/)).
