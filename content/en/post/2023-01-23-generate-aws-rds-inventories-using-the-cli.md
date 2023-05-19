---

date: 2023-01-23
title: 'Generate AWS RDS inventories using the AWS CLI'
tags: ['snippet']

---

<!--more-->

Let's say you got a notification from AWS saying that "a couple" of databases
will be upgraded in the upcoming maintenance window. The DBA is on PTO, and you
need to share this information more accurately up the chain of command, ideally
as a spreadsheet.

In case you already know the AWS account and the region affected, then it would
be as simple as doing the following:

```shell
aws rds describe-db-clusters \
  --region='[the region goes here]' \
  --no-paginate --output text \
  --query 'DBClusters[*].[DBClusterIdentifier,Engine,EngineVersion,Endpoint,ClusterCreateTime,DBClusterArn,Status]'
```

If you thought about copying that output directly from the terminal by clicking
and selecting, please don't and use `pbcopy` instead. You can [use this
alias](https://jossemargt.com/en/post/2022-02-13-pbpaste-pbcopy-in-gnu-linux/)
for said command if you are a GNU Linux user. In that way, it would end looking
like this:

```shell
aws rds describe-db-clusters \
  --region='[the region goes here]' \
  --no-paginate --output text \
  --query 'DBClusters[*].[DBClusterIdentifier,Engine,EngineVersion,Endpoint,ClusterCreateTime,DBClusterArn,Status]' \
  | pbcopy
```

Then it would be a matter of opening the spreadsheet application of your choice
and using the "special paste" options to fill in the values. And you are done.

## What if I don't know the region

Ah! I have been there as well. For this, we'll use our shell scripting knowledge
and the help of another AWS cli subcommand.

```shell
for region in $(aws ec2 describe-regions --output text | cut -f4); do
  echo 'Listing RDS in region: ' $region
  AWS_PAGER=cat aws rds describe-db-clusters \
    --region="$region" \
    --no-paginate --output text \
    --query 'DBClusters[*].[DBClusterIdentifier,Engine,EngineVersion,Endpoint,ClusterCreateTime,DBClusterArn,Status]'
done
```

On that snippet, we iterate per each enabled region in our account and then
query the clusters within them. At the moment, I haven't figured out how to
insert `pbcopy` in the mix without requiring temporary files, so for simplicity
I'll keep it that way.

Regarding the `AWS_PAGER=cat` you see there, it is to force the AWS cli to
simply print the output instead of opening a new buffer/pager.

## A word of caution about clusters and rogue DB instances

Ideally, all our databases should run as clusters, but in the real world, you
will find at least one DB instance that does not belong to any. These
_"cluster-less"_ instances won't appear in the queries shared above, so for
those scenarios, you could use this command instead when you know the region:

```shell
aws rds describe-db-instances \
  --region='[the region goes here]' \
  --output text --no-paginate \
  --query 'DBInstances[*].[DBInstanceIdentifier,Engine,EngineVersion,Endpoint.Address,InstanceCreateTime,DBInstanceArn,DBInstanceStatus]'
```

And this other one to iterate over all the available regions:

```shell
for region in $(aws ec2 describe-regions --output text | cut -f4); do
  echo 'Listing RDS in region: ' $region
  AWS_PAGER=cat aws rds describe-db-instances \
    --region $region \
    --output text --no-paginate \
    --query 'DBInstances[*].[DBInstanceIdentifier,Engine,EngineVersion,Endpoint.Address,InstanceCreateTime,DBInstanceArn,DBInstanceStatus]'
done
```

**Remember** that these commands will list all the database instances, including
those belonging to a cluster. So you'll need to cross check with the clusters to
spot the outliners.

## Problem solved, but before you go

I hope these snippets have helped you out with the not-so-imaginary situation we
described at the beginning, and before you go, I wanted to share this:

- Prefer `pbcopy` over clicking and copying directly from the terminal.
- Once you have the values, remember to use the "special paste" to fill out the
  spreadsheet of your choice.
- You can get more data by changing the `--query` flag value. You can find the
  available fields within the documentation for
  [rds describe-clusters](https://docs.aws.amazon.com/cli/latest/reference/rds/describe-db-clusters.html#output)
  and
  [rds describe-instances](https://docs.aws.amazon.com/cli/latest/reference/rds/describe-db-instances.html#output)
  commands.
- Personally, I prefer to set a default region before executing the snippets you
  found here with the `aws configure` command, to avoid repeating myself too
  often.
- Kudos to @[albarki](https://github.com/albarki) for sharing the
  `aws ec2 describe-regions` loop snippet
  [over here](https://gist.github.com/albarki/3588354ef11a137e199e29381fb07de1).

Happy hacking.
