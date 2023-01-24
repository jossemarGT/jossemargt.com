---

date: 2023-01-23
title: 'Generate reports of AWS DB clusters with the AWS CLI'
tags: ['snippet']

---

<!--more-->

Let's say, you got a notification from AWS telling that "a couple" of databases
will be upgraded in the upcoming maintenance window. The DBA is on PTO and you
need to share this information more accuarately up the chain of command, ideally
as a spreadsheet.

Well, this snippet might help you on that:

```shell
aws rds describe-db-clusters --no-paginate --output text \
    --query 'DBClusters[].{DBClusterIdentifier:DBClusterIdentifier,EngineVersion:EngineVersion,ClusterCreateTime:ClusterCreateTime}' \
    | pbcopy
```

Things to have in mind:

1. I have previously set the default region for all API queries using
   `aws configure`, so you might want to that or add `--region` flag right after
   the `aws` command
2. All the "collums" we need are being listed within the `--query` value. You
   can read more about the output values
   [over here](https://docs.aws.amazon.com/cli/latest/reference/rds/describe-db-clusters.html#output)
3. This command won't exactly generate a spreadsheet for you, but its output can
   be easily pasted within one as long you select "paste special"
4. In case the command above fails with `pbcopy command not found`, it means you
   don't have `pbcopy` installed or the `xsel` alias in GNU Linux environments ([ref](https://jossemargt.com/en/post/2022-02-13-pbpaste-pbcopy-in-gnu-linux/))

I hope this helps. Happy hacking.

PS: This snippet and other variations of it are already published in AWS
documentation
([ref](https://docs.aws.amazon.com/cli/latest/reference/rds/describe-db-clusters.html#examples)),
perhaps you should take a look there as well.
