---

date: 2021-10-06
title: 'Artifactory yum repolists metadata troubleshoot'

---

<!--more-->

This is a long overdue post dating from 2017. But to make the troubleshooting
interesting, I would like to do it in an **informal** [Root Cause Analysis (RCA)](https://en.wikipedia.org/wiki/Root_cause_analysis).

**Disclaimer**: To keep this post digestible for most of the audiences, I will
ignore the following aspects of an RCA:

- It must thrive to have a detailed sequence of events, ideally with timestamps
- It should be written formally and neutrally
- It should include the business impact (time, users and losses)

Please bear that in mind if you would like to use this post as a guide for some
reason.

## Artifactory yum errors - Informal RCA

### Issue

- In 2017, we did a significant update on [JFrog Artifactory](https://jfrog.com/artifactory/) on-premise services
- The new services passed all our validations, and the monitoring marked it as "ok"
- Compute and IOPS quotas are on their expected ranges
- The new Artifactory was promoted "as live", no error was reported from the users immediately
- After a couple of hours, several yum-related errors were reported. Having the following error strings in common:

```log
...
error getting update info: Cannot retrieve repository metadata (repomd.xml) for repository: repo. Please verify its path and try again
...
Error: requested datatype filelists not available
```

### Root cause

Starting from the Artifactory version we migrated on, the filelists.xml (yum file list) indexing is disabled by default since it is resource-intensive.

This breaking change was apparent until the yum cache expired on the machines
that reported the problems with yum commands that rely on file metadata
(makecache, search, install).

### Immediate fix

After identifying this was an [intended Artifactory change](https://www.jfrog.com/confluence/display/JFROG/RPM+Repositories#RPMRepositories-IndexingtheFileList), we followed the
manual to [re-enable the file list indexing](https://www.jfrog.com/confluence/display/JFROG/RPM+Repositories#RPMRepositories-EnableFileListIndexing). Then trigger a manual yum repository
re-index.

### Long-standing fix

- Although expensive, continue using a blue/green strategy for core services, with a greater grace window (over 24hrs)
- Explore forcing yum metadata expiration on canary environments to test the new service

## Closing thoughts

I hope you find this post helpful either on the JFrog pointers or the
pseudo-RCA.

By the way, if you are in charge of a productive service that goes south,
remember "keep calm and push forward". We have been there and it happens #hugops.