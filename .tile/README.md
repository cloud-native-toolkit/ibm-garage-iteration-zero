# Private Catalog tiles

One of the features of the IBM Cloud Catalog is support for private catalog tiles. These can contain custom Terraform 
definitions that can accelerate an SRE teams in the execution of common and repetitive tasks. The Cloud-Native Toolkit
provides a number of tiles to simplify Toolkit installation in IBM Cloud accounts.

## Available tiles

- [SRE Tools](./tiles/sre-tools)
- [VPC Cluster](./tiles/cluster-vpc)
- [Classic Cluster](./tiles/cluster-classic)
- [Cloud-Native Toolkit](./tiles/cloudnative-toolkit)
- [All-in-one Toolkit](./tiles/cloudnative-toolkit-all-in-one)

## Install the Cloud-Native Toolkit tiles in an account

### Create a catalog

IBM Cloud organizes service offerings into catalogs. In addition to the provided catalogs, custom catalogs can be 
created to manage additional offerings. The first step is to create a private catalog. 

1. Click **Manage->Catalogs** from the top menu.
2. Click on **Create Catalog** and provide a name for the catalog. For example, `Team Catalog`.
3. Click **Update** to change the default resource group for the catalog.
4. Click **Create** to complete the catalog creation process.

### Config Private Catalog Offering

Once a catalog has been created, offerings can be added to the catalog. 

---

**Prerequisites:**

1. In order to add offerings to the catalog, an IBM Cloud API Key is required.
2. The command-line scripts depend on [jq](https://stedolan.github.io/jq/download/)  

---

Run the following command to install the offering tiles into an existing catalog. You will be prompted for your catalog name
and IBM Cloud API Key. Alternatively, the values can be provided to the script by setting the value in environment variables named `CATALOG_NAME` and `API_KEY`.

```shell
bash -c "$(curl -Ls tiles.cloudnativetoolkit.dev)"
```

```shell
CATALOG_NAME="Team Catalog" API_KEY="xxxx" bash -c "$(curl -Ls tiles.cloudnativetoolkit.dev)"
```

## Install using a Private Catalog tile

Once a tile has been installed into the IBM Cloud account, it can be executed to provision services and/or 
configure different aspects of the account.

1. Click **Catalog** in the top menu.
2. Select your catalog from the drop-down in the left menu.
3. Select **Private** from the left menu to see the private catalog tiles.
4. Click one of the provided tiles to begin the installation process. The detailed information required to install each tile can be accessed from the `Readme` tab of the tile.

### Getting Started

Read the [Developer Guide](https://cloudnativetoolkit.dev/getting-started-day-1/deploy-app) to get more information about using the Tools now they are running in your cluster

### Possible issues

If you find that the Terraform provisioning has failed, try deleting the workspace and configuring it again
