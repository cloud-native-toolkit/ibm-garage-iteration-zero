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


### Deploying Code into Pipelines

Now you have a working development environment on the IBM Public Cloud. You can now start working with code to deploy into your cluster using Jenkins pipelines. The following instructions help describe this process.

You can click on the `Starter Kits` tab on the Development Cluster Dashboard and follow the instructions for provisioning a new microservice into your development cluster. You can easily create an microservice by using the github templates listed below:

* [12 UI Patterns with React and Node.js](https://github.com/ibm-garage-cloud/template-node-react)
* [TypeScript Microservice or BFF with Node.js](https://github.com/ibm-garage-cloud/template-node-typescript)
* [GraphQL BFF with Node.js](https://github.com/ibm-garage-cloud/template-graphql-typescript)
* [Spring Boot Java Microservice](https://github.com/ibm-garage-cloud/template-java-spring)

Click on the `Use this template` button to create a repo in your git organisation. Then follow the pipeline registration instructions below, you will need to be logged into the OpenShift Console or IKS clusters on the command line. You will also need a [Personal Access Token](https://help.github.com/en/articles/creating-a-personal-access-token-for-the-command-line) from your git organistaion.

```bash
git clone <generated startkit template>
cd <generated startkit template>
vi package.json ! rename template
git add .
git commit -m "Rename project"
git push
igc register ! register pipeline with Jenkins
? Please provide the username for https://github.com/mjperrins/hello-world-bff.git: mperrins
? Please provide your password/personal access token: [hidden]
? Please provide the branch the pipeline should use: master
Creating git secret
Copying 'ibmcloud-apikey' secret to dev
Registering pipeline
? The build pipeline (mjperrins.hello-world-bff) already exists. Do you want to update it? (Y/n)
```

The pipeline will be created in the `dev` namespace in OpenShift and IKS, it will create any necessary secrets required to run the pipeline. The app image will be stored in the IBM Container Registry and deployed into the `dev` name space. You can use the Argo CD Template to help define a deployment configuration from `dev` to `test` and `staging`

If you want to get easy access to your application routes or ingress end points for your apps run the following command. All the `igc` commands run the same on IKS and OpenShift.
```bash
igc ingress -n dev
```


