---
name: Bug report
about: Create a report to help us improve
title: ''
labels: ''
assignees: ''

---

**Describe the bug**
A clear and concise description of what the bug is.

**Version**
What version of Iteration Zero are you using? If you are running from the cloned repo, then
provide the latest commit hash from cloud-native-toolkit/ibm-garage-iteration-zero or the tag if
working off of a tagged version. If you are running from a tile, provide the tile version. 

**Environment configuration**
Provide the contents of the `environment.tfvars` file here

**Stages**
Provide the stages that were run

**Terraform log**
Provide the full terraform log. This file could be big so compress it in a zip or tgz file, upload
it to some network storage location (like Box) and provide the url here. (Be sure to give us access
to the file.)

The best way to collect the logs is to set the following values prior to running the script:

```shell script
export TF_LOG=TRACE
export TF_LOG_PATH=./terraform.trace
``` 

**To Reproduce**
Steps to reproduce the behavior:
1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

**Expected behavior**
A clear and concise description of what you expected to happen.

**Screenshots**
If applicable, add screenshots to help explain your problem.

**Desktop (please complete the following information):**
 - OS: [e.g. iOS]
 - Browser [e.g. chrome, safari]
 - Version [e.g. 22]

**Additional context**
Add any other context about the problem here.
