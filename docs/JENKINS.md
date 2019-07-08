# Jenkins setup

*A good description*

## Create Jenkins environment in Kubernetes

Can be done either with Terraform script (preferred) or by running the helm chart

### Using Terraform

Read the `README.md` for instructions

If necessary, run the following command to set up the jenkins access secrets:

#### Run 'jenkins-auth' command

1. Install the 'ibm-garage-cloud-cli'
    ```bash
    npm i -g @garage-catalyst/ibm-garage-cloud-cli
    ```
2. Log in to the ibmcloud and configure the cluster
    ```bash
    ibmcloud login -r {REGION} -g {RESOURCE_GROUP} [--sso] [--apiKey {API_KEY}]
    ibmcloud ks cluster-config --cluster {CLUSTER_NAME}
    ```
3. Get the Jenkins admin password by running the following command or by looking at the pod in thee kube dashboard
    ```bash
    kubectl get secret --namespace tools jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode
    ```
4. Run the cli to generate the jenkins-access secret
    ```bash
    igc jenkins-auth \
      -u admin \
      -p $(kubectl get secret --namespace tools jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode) \
      --host jenkins.{region}.containers.appdomain.cloud
    ```

For reference, the following steps can be used to generate the Jenkins API token and can be optionally
passed into `jenkins-auth` command with the `--jenkinsApiToken` argument.

#### Log into Jenkins and generate an api token

1. Get the Jenkins admin password by running the following command or by looking at the pod in thee kube dashboard
    ```bash
    kubectl get secret --namespace tools jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode
    ```
2. Go to the Jenkins dashboard - http://jenkins.{cluster}.{region}.containers.appdomain.cloud
3. Log in as user 'admin' and password from the first step
4. Click on the 'admin' link in the top-right corner to open the user profile page
5. Click on `Configure` from the left menu
6. In the `API Token` section click on `Add new Token` button
7. Give the token a name and press `Generate`
8. Save the generated token. Once you leave the page it won't be visible again

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
