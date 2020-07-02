# CNCF Cloud Native Toolkit 

![CI For Cloud-Native Toolkit Private Catalog](https://github.com/ibm-garage-cloud/cloudnative-toolkit/workflows/CI%20For%20Cloud-Native%20Toolkit%20Private%20Catalog/badge.svg)

## Install CNCF Cloud-Native Toolkit using IBM Private Catalogs or IBM Schematics

This git repository is a derivative of the **Iteration Zero** project from
 the **IBM Garage Cloud Native Toolkit**. It has been created to make the
  installation of the CNCF Cloud-Native DevSecOps tools very
   easy using IBM Cloud. You can use a Private Catalog Tile or
    the IBM Schematics services. The Toolkit installs a number of common CNCF
     tools that enable a robust DevSecOps model with CI/CD with
     IBM Manage clusters Red Hat OpenShift and IBM Kubernetes. 
   
You can find out more information about the toolkit and the iteration zero
 terraform here:
    
- [IBM Garage Cloud Native Toolkit](https://cloudnativetoolkit.dev/)
- [Toolkit Iteration Zero Terraform](https://github.com/ibm-garage-cloud/ibm-garage-iteration-zero)

Follow the instructions below to install these common cloud native tools
 into a managed cluster on IBM Cloud. These tools support both OpenShift and
  Kubernetes and clusters in VPC or Class infrastructure 
  
### Prerequisites

The Developer Tools are installed by an cloud account
 administrator, who will run the IasC to create the environment in an IBM Cloud account. 
 The scripts will run as the environment administrator's user. These instructions explain how to configure and run the Terraform (IasC) scripts to create the <Globals name="env" />.

**Note**: The Terraform scripts will clean up the cluster to remove any existing installation that may have been previously been installed.

### Confirm permissions

Optional: To help confirm that the scripts will have the permissions they'll require, the environment administrator may log into the account and test creating a couple of resources:
- [Create a cluster](https://cloud.ibm.com/kubernetes/catalog/cluster/create) -- Make it single-zone, and specify the proper data center and resource group
- Create a namespace in the image registry

As long as the user can create these resources successfully the terraform script will be able to apply its state to the cluster.

### Config Private Catalog Offering

One of the features of the IBM Cloud Catalog is support for private catalog
 tiles. These can contain custom Terraform definitions that can accelerate an
  SRE teams in the execution of common and repetitive tasks. The CNCF DevOps
   tools installation can be configured as a private catalog tile. This is
    the recommend approach for using this asset multiple times. This asset
     enables the easy transition of a default cluster into a cluster that
      supports Cloud-Native CI/CD development tools.
      
- First step is to create a Catalog, Click **Manage->Catalogs**
- Click on **Create Catalog** , provide a name for example `Team Catalog`
- Click **Update** to change the default resource group for the Catalog 
- Click **Create** to complete the Catalog Creation
    
- Next step is to run the following script to register Cloud-Native Toolkit
 tile into the Catalog as an offering. You will need an IBM Cloud API Key
 
- Clone this repository to the Cloud Shell or you local workstation
- Run the `offering.sh` scripts passing in the API Key and the name of the
 Catalog that you created
- If you are not running this from the [Cloud Shell](https://www.ibm.com/cloud/cloud-shell) you will need to install `jq` into you command line environment [jq downloads](https://stedolan.github.io/jq/download/)  
 
 ```bash
git clone https://github.com/ibm-garage-cloud/cloudnative-toolkit
cd cloudnative-toolkit
./offering.sh {API_KEY} "Team Catalog"
```

## Install Toolkit into Cluster using Private Catalog Tile

- Once you have completed the Offering Tile configuration, navigate to the new
 Catalog. You can do this from the IBM Cloud Console select you Catalog ie
 . `Team Catalog`and click on the **Private** menu on the on the left you can
  select the catalog you have created `Team Catalog`
- Select the **Cloud Native Toolkit** tile
- Enter values for the variables list , these can be customized depending
 on the type of cluster and if its in classic or VPC

    | **Variable**   | **Description**  | **eg. Value**  |
    |---|---|---|
    | `ibmcloud_api_key` | The API key from IBM Cloud Console that support service creation access writes  | `{guid API key from Console}`  |
    |  `resource_group_name` | The name of the resource group where the cluster is created  | `dev-team-one`  |
    |  `cluster_type`       |  The name of the IKS cluster |  `kubernetes` or `ocp4` |
    |  `cluster_name`       |  The name of the IKS cluster |  `dev-team-one-iks-117-vpc` |
    |  `cluster_exists`     |  Does the cluster exist already | `true`  |
    |  `vpc_cluster`        | Is the cluster created in VPC  | `true`  |

- Input the Environment variables

    - Set them based on the existing cluster:
    - `resource_group_name` -- The existing cluster's resource group
    - `cluster_exists` -- Set to `true` for an existing cluster
    - `cluster_type` -- Specify the existing cluster's type
        - **kubernetes** -- Kubernetes
        - **openshift** -- OpenShift v3
        - **ocp3** -- OpenShift v3
        - **ocp4** -- OpenShift v4
    - `cluster_name` -- The existing cluster's name
    - `vpc_cluster` -- true of false if the cluster is inside a VPC

- Accept the License which is **Apache 2** license
- Click **Install**

- This will kick off the installation of the CNCF Cloud-Native DevOps tools
 into a development cluster using Private Catalog Tile.

- Once complete you can now start to use the development tools in your cloud
 native project.
 
### Post Installation steps

- Two of the default tools that were installed **Artifactory** and **ArgoCD** require some post installation configuration.
- Complete these steps documented here for [Artifactory Configuration](https://cloudnativetoolkit.dev/admin/artifactory-setup)
- Complete these steps documented here for [ArgoCD Configuration](https://cloudnativetoolkit.dev/admin/argocd-setup)

### Getting Started

- Read the [Developer Guide](https://cloudnativetoolkit.dev/getting-started
/deploy-app) to get more information about using the Tools now they are
 running in your cluster

### Setup Schematics

Configure IBM Cloud Schematics with Terraform infrastructure-as-code (IasC) scripts that will install the tools into your IBM Cloud managed cluster

- Create a workspace in IBM Schematics service and call it `cloud-native-toolkit` and place it in your nominate resource group.

- On the Settings view import your terraform template
    ```bash
    https://github.com/ibm-garage-cloud/cloudnative-toolkit
    ```
- select `terraform_v0.12` version from the Terraform version drop down

- click **Save template information**

### Variables 

To support the running of the Terraform for the CNCF DevSecOps installation configure your variables

The installation requires a set of terraform variables to be set for your environment. The Terraform assumes that a cluster has already been created and the CNCF tools are installed into an existing cluster.

| **Variable**   | **Description**  | **eg. Value**  |
|---|---|---|
| `ibmcloud_api_key` | The API key from IBM Cloud Console that support service creation access writes  | `{guid API key from Console}`  |
|  `resource_group_name` | The name of the resource group where the cluster is created  | `dev-team-one`  |
|  `cluster_type`       |  The name of the IKS cluster |  `kubernetes or ocp4` |
|  `cluster_name`       |  The name of the IKS cluster |  `dev-team-one-iks-117-vp` |
|  `cluster_exists`     |  Does the cluster exist already | `true`  |
|  `vpc_cluster`        | Is the cluster created in VPC  | `true`  |

### Environment variables

Set them based on the existing cluster:
- `resource_group_name` -- The existing cluster's resource group
- `cluster_exists` -- Set to `true` for an existing cluster
- `cluster_type` -- Specify the existing cluster's type
    - **kubernetes** -- Kubernetes
    - **openshift** -- OpenShift v3
    - **ocp3** -- OpenShift v3
    - **ocp4** -- OpenShift v4
- `cluster_name` -- The existing cluster's name

**Note**: The values for `resource_group_name` and `cluster_name` can be found on the Resource List
page in the IBM Cloud Console - https://cloud.ibm.com/resources


### Apply the Terraform Schematics workspace

- Having configured the variables for the workspace you can now apply it

**Note**: If you run this approach multiple times remember to delete any pre existing cloud services that were created previously

- Navigate to the Workspace you have configured `cloud-native-toolkit`
- Click on the **Apply**

- Installing the tools into an existing cluster takes about 30 minutes. You
 can view the workspace logs to see the progress of the execution of the Schematics Terraform scripts

-   You should now have your Development Tools fully provisioned and
 configured. Enjoy!

Once the Schematics scripts have finished, you can see the resources that the scripts created in IBM Cloud:
- In the IBM Cloud console, open the [Resource List](https://cloud.ibm.com/docs/overview?topic=overview-ui#dashboardview "Managing resources in the resource list")
- On the Resource List page, filter by your Resource Group (e.g. `dev-team-one`)
- You should see these resources listed:
    - **Clusters**: 1, either Kubernetes or OpenShift
- Select the cluster and open the Kubernetes dashboard or OpenShift web console. You should see:
    - Namespaces: `tools`, `dev`, `test`, and `staging`
    - Deployments in the `tools` namespace: `developer-dashboard`, `jenkins`, etc.

To get started open the Developer Dashboard or navigate to the tools using the OpenShift Tools menu.

- To complete the setup install the Developer tools into the IBM Cloud Shell [Cloud Native - Developer Tools](/ci-cd/cloud-native-setup-tools)


### Possible issues

If you find that that the Terraform provisioning has failed, try deleting the workspace and configuring it again
