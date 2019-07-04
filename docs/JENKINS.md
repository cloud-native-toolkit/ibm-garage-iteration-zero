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
    kubectl get secret --namespace tools jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode
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
- First change directory to `/terraform/stages/stage3/tools_helm_releases/` this is where the `jenkins-access` helm chart is located

```bash
helm install \
  jenkins-config \
  --name jenkins-config \
  --namespace tools \
  --set jenkins.password={jenkins_password},jenkins.api_token={api_token},jenkins.url={jenkins_ingress}
```

## Register a pipeline for a project/repo

1. Install the IBM Garage Cloud cli: `npm i -g @garage-catalyst/ibm-garage-cloud-cli`
2. Open a terminal and change to the directory into which the repository was cloned.
3. Use the cli to register the pipeline:
```bash
igc register 
```

## TODO

* Automate creation of Git webhook and include with Jenkins pipeline registration
* Incorporate additional Jenkins configuration into terraform build
* Figure out how to automate the API_TOKEN generation
* Generalize the Jenkins pipeline a bit more and create some naming conventions for secret names
