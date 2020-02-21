/*
 * This is a Jenkins pipeline that relies on the Jenkins kubernetes plugin to dynamically provision agents for
 * the build containers.
 *
 * This pipeline expects three resources to be available in the namespace when it runs. See
 * terraform/scripts/create-pipeline-resources.sh for more information
 *
 * The cloudName variable is set dynamically based on the existance/value of env.CLOUD_NAME which allows this pipeline
 * to run in both Kubernetes and OpenShift environments.
 */

def buildAgentName(String jobNameWithNamespace, String buildNumber, String namespace) {
    def jobName = removeNamespaceFromJobName(jobNameWithNamespace, namespace);

    if (jobName.length() > 55) {
        jobName = jobName.substring(0, 55);
    }

    return "a.${jobName}${buildNumber}".replaceAll('_', '-').replaceAll('/', '-').replaceAll('-.', '.');
}

def removeNamespaceFromJobName(String jobName, String namespace) {
    return jobName.replaceAll(namespace + '-', '');
}

def toolsImage="ibmgaragecloud/cli-tools:0.1.1"

def buildLabel = buildAgentName(env.JOB_NAME, env.BUILD_NUMBER, env.NAMESPACE);
def namespace = env.NAMESPACE ?: "dev"
def cloudName = env.CLOUD_NAME == "openshift" ? "openshift" : "kubernetes"
def workingDir = "/home/jenkins/agent"
podTemplate(
   label: buildLabel,
   cloud: cloudName,
   yaml: """
apiVersion: v1
kind: Pod
spec:
  serviceAccountName: jenkins
  volumes:
    - name: environment-tfvars
      configMap:
        name: environment-tfvars
    - name: vlan-tfvars
      configMap:
        name: vlan-tfvars
  containers:
    - name: setup-image
      image: alpine:3.9.5
      tty: true
      command: ["/bin/bash"]
      workingDir: ${workingDir}
      env:
        - name: HOME
          value: ${workingDir}
      volumeMounts:
        - name: environment-tfvars
          mountPath: /etc/config/environment.tfvars
        - name: vlan-tfvars
          mountPath: /etc/config/vlan.tfvars
    - name: tools-image
      image: ${toolsImage}
      tty: true
      command: ["/bin/bash"]
      workingDir: ${workingDir}/terraform
      env:
        - name: HOME
          value: ${workingDir}
        - name: IBMCLOUD_API_KEY
          valueFrom:
            secretKeyRef:
              name: terraform-credentials
              key: "ibmcloud.api.key"
        - name: TF_VAR_ibmcloud_api_key
          valueFrom:
            secretKeyRef:
              name: terraform-credentials
              key: "ibmcloud.api.key"
        - name: IAAS_CLASSIC_USERNAME
          valueFrom:
            secretKeyRef:
              name: terraform-credentials
              key: "classic.username"
        - name: IAAS_CLASSIC_API_KEY
          valueFrom:
            secretKeyRef:
              name: terraform-credentials
              key: "classic.api.key"
"""
) {
    node(buildLabel) {
        container(name: 'setup-image', shell: '/bin/bash') {
            checkout scm
            stage('Copy settings') {
                sh '''#!/bin/bash
                    set +x

                    cp /etc/config/environment.tfvars ./terraform/settings
                    cp /etc/config/vlan.tfvars ./terraform/settings

                    echo "*** Terraform settings copied"
                    echo ""
                    echo "-- environment.tfvars --"
                    cat ./terraform/settings/environment.tfvars
                    echo ""
                    echo "-- vlan.tfvars --"
                    cat ./terraform/settings/vlan.tfvars
                '''
            }
        }
        container(name: 'tools-image', shell: '/bin/bash') {
            stage('Provision cluster') {
                sh '''
                    set +x

                    ./runTerraform.sh --force
                '''
            }
            stage('Validate cluster') {
                sh '''
                    echo "Nothing to do, yet"
                '''
            }
            stage('Destroy cluster') {
                sh '''
                    echo "Nothing to do, yet"
                '''
            }
        }
    }
}

