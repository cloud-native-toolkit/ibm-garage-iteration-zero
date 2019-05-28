# Jenkins setup

*A good description*

## Create Jenkins environment in Kubernetes

Can be done either with Terraform script (preferred) or by running the helm chart

### Using Terraform

Read the `README.md` for instructions

### Using Helm

```bash
helm repo add stable-rbac https://seansund.github.io/charts/

helm install \
  stable-rbac/jenkins
  --name jenkins \
  --values jenkins-values.yaml \
  --namespace {namespace} \
  --set master.ingress.hostName="jenkins.{namespace}.{cluster}.{region}.containers.appdomain.cloud"
```

```bash
helm install \
  ibmcloud-apikey
  --name ibmcloud-apikey \
  --namespace {namespace} \
  --set ibmcloud.apikey="{ibmcloud_api_key}"
```

The following two steps (generate the api token and run the helm chart to create the secret)
are automated as part of the terraform scripts but must be manually run if the Jenkins
deployment is done with Helm directly.

#### Log into Jenkins and generate an api token

1. Get the Jenkins admin password by running the following command or by looking at the pod in thee kube dashboard
    ```bash
    kubectl get secret --namespace {namespace} jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode
    ```
2. Go to the Jenkins dashboard - http://jenkins.{namespace}.{cluster}.{region}.containers.appdomain.cloud
3. Log in as user 'admin' and password from the first step
4. Click on the 'admin' link in the top-right corner to open the user profile page
5. Click on `Configure` from the left menu
6. In the `API Token` section click on `Add new Token` button
7. Give the token a name and press `Generate`
8. Save the generated token. Once you leave the page it won't be visible again

#### Run the jenkins-access helm chart

- Creates a secret with the Jenkins access credentials

```bash
helm install \
  jenkins-access
  --namespace {namespace} \
  --set jenkins.password={password},jenkins.api_token={api_token},jenkins.url={jenkins_ingress}
```

## Run the registration script

1. Open a terminal and navigate to the directory of the repository that will be registered.
2. Run `{iteration-zero-terraform root}/scripts/launch.sh {IBM Cloud API key} 1 2`
3. Start the registration process for the repo with `./bin/reg-pipeline.sh`. An interactive script
will collect/confirm the values for the git repo and register the pipeline.

== TODO

* Automate creation of Git webhook and include with Jenkins pipeline registration
* Incorporate additional Jenkins configuration into terraform build
* Figure out how to automate the API_TOKEN generation
* Generalize the Jenkins pipeline a bit more and create some naming conventions for secret names
