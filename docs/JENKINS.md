# Registering code into a Jenkins pipeline

*add good description*

## TODO

* Automate creation of Git hook and include with Jenkins pipeline registration
* Incorporate additional Jenkins configuration into terraform build
* Figure out how to automate the API_TOKEN generation
* Generalize the Jenkins pipeline a bit more and create some naming conventions for secret names

## Create Jenkins environment in Kubernetes

Can be done either with Terraform script (preferred) or by running the helm chart

### Terraform

Read the `README.md` for instructions

### Helm

```bash
helm install \
  stable/jenkins
  --name jenkins \
  --values jenkins-values.yaml \
  --namespace {namespace} \
  --set master.ingress.hostName="jenkins.{namespace}.{cluster}.{region}.containers.appdomain.cloud"
```

### Add the Git credentials as a Kubernetes secret


**Note:** This should probably be included in the `jenkins-register-pipeline.sh` script and also include the repo url in the secret


A note about credential types
****
Jenkins credentials can be provided in a number of different forms:

* certificate
* secretFile
* secretText
* usernamePassword
* basicSSHUserPrivateKey

These instructions assume that usernamePassword will be used and that the Git username and personal access token are
provided. In this case, the `https` endpoint for the Git repo would be used. If the SSH link to the repo would be used,
then the `basicSSUserPrivateKey` type would be needed. In that case, see
https://jenkinsci.github.io/kubernetes-credentials-provider-plugin/examples/ for details on how to update the yaml file
to use `basicSSUserPrivateKey`
****

Copy the `jenkins-credential-secret.yaml` to `git-credential.yaml` (you can name it whatever but for the purposes
of these steps we'll use this name)
. Update the `{{NAME}}`, `{{USERNAME}}`, and `{{PASSWORD}}` for the credential with a meaningful name for the secret
and the username and personal access token for Git.

Create the secret

```bash
kubectl create -f git-credential.yaml --namespace {namespace}
```

## Patch the Jenkins security role

**Note:** This should be automated as part of the create Jenkins cluster step


The `kubernetes-credentials-provider` plugin allows credentials to be stored as kubernetes
secrets and used within the pipeline (instead of needing to configure credentials in Jenkins).
In order for the plugin to work, the `jenkins-schedule-agents` role created by the helm chart
needs to be patched so that it has access to `secrets` resources.

**Note:** This patch grants Jenkins full rights to read/write all secrets within the namespace.
It is **highly** advised that the Jenkins pods run in a separate namespace from the runtime components
so as not to have unnecessary access to application level secrets.

```bash
kubectl patch role/jenkins-schedule-agents \
  --namespace {namespace}
  --patch "$(cat jenkins-role-patch.yaml)"
```

(Jenkins may need to be restarted)

## Log into Jenkins and generate an api token

**Note:** If possible, this should be automated as part of the Create Jenkins cluster step

Get the Jenkins admin password by running the following command or by looking at the pod in thee kube dashboard

```bash
kubectl get secret --namespace {namespace} jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode
```
1. Go to the Jenkins dashboard - http://jenkins.{namespace}.{cluster}.{region}.containers.appdomain.cloud
2. Log in as user 'admin' and password from the first step
3. Click on the 'admin' link in the top-right corner to open the user profile page
4. Click on `Configure` from the left menu
. In the `API Token` section click on `Add new Token` button
5. Give the token a name and press `Generate`
Save the generated token. Once you leave the page it won't be visible again

## Add the api token as a Kubernetes secret?

**Note:** If possible (depending on previous step), this should be automated as part of the Create Jenkins cluster step


Update the `jenkins-access-secret.yaml` with the following values:
* Username
* Password/API token
* Jenkins url
```bash
kubectl create \
  -f jenkins-access-secret.yaml \
  --namespace {namespace}
```

## Run the register script

**Note:** The script and template config file are provided here in this repo for completeness and to have
a single place to find them. Ultimately they will live in the starter kits.

Two scripts for Jenkins registration
****
Two scripts are provided to register the pipeline:

* `jenkins-register-pipeline-kube.sh`

Registers the Jenkins pipeline and gets many of the values from kubernetes secrets (created in previous steps). It uses
`kubectl` and therefore requires that the kube environment be set up. After getting the parameters from kubernetes
secrets it passes the values to the other registration script. There are three required parameters:
+
** JENKINS_NAMESPACE
** JENKINS_ACCESS_SECRET
** GIT_CREDENTIALS

* `jenkins-register-pipeline.sh`

Registers the Jenkins pipeline. It doesn't depend on `kubectl` but it requires more required parameters:

** JENKINS_HOST
** USER_NAME
** API_TOKEN
** GIT_REPO
** GIT_CREDENTIALS

****

. Run the `jenkins-register-pipeline.sh` script. It requires the the following values:
* Jenkins url
* Jenkins user name
* Jenkins api token
* Git url
* Git credential secret name (from previous step)
* *optional* branch name (if not using master)
* *optional* job name (will default to repo name and branch name)
