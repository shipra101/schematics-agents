# Enabling tls for the internal communication between job-runner and job of the remote agents

## Introduction
Schematics Agent has two micro services running in your cluster. This guide describes the steps to enable the tls/mtls between these two. Although this communication is internal, tls can add additional security. You can chose to run the agent [without tls](#running-without-tls) for internal communication but it is not recommended.

## Summary of steps
#### Using secrets manager
* Provision a secrets manager instance and create tls secrets.
* Create secrets for server tls and optionally client tls
* Configure variables for secrets from secrets manager
#### Using externally generated certificates
* Or Bring self signed or externally signed certificates.
* Configure values for external/self signed certificates

## Steps for using secrets manager :

1. **Provision a secrets manager instance**
   1. Create a secrets manager instance in your account if you don't have one already. Refer to [this](https://cloud.ibm.com/docs/secrets-manager?topic=secrets-manager-create-instance)
   2. To the get the CRN and guid, you can visit the [resources page](cloud.ibm.com/resources) and find your secrets-manager instance in the 'Services and software' section. You can filter with 'Secrets Manager' in the product column, if there are many resources. Click on the name of the instance
   3. Go to settings in the resource page to find out the CRN. The guid is the value at the end before two colons. The region is available after the fifth colon. For example in the CRN `crn:v1:bluemix:public:secrets-manager:us-east:a/123477194bb748cdb1d45671234abcd:08abcdd0-1960-8afa-4854--3babcdefg44e::` region is us-east and guid is `08abcdd0-1960-8afa-4854--3babcdefg44e`. Keep guid and region of the secrets manager instance handy

2. **Create/Import tls secrets**
   1. To create and sign certificates in SM, a root ca is needed. Please follow [this article](https://www.ibm.com/cloud/blog/announcements/create-private-tls-certificates-with-ibm-cloud-secrets-manager) to create a root certificate authority and an intermediate certificate authority to sign certificates. [Docs for creation of intermediate CA](https://cloud.ibm.com/docs/secrets-manager?topic=secrets-manager-intermediate-certificate-authorities&interface=ui)
   2. For the above created intermediate CA, [Create a certificate template](https://cloud.ibm.com/docs/secrets-manager?topic=secrets-manager-certificate-templates&interface=ui) for the server side in the agent. When creating the server ceritificates,  // todo: @srikar - 
   3. After creating a template for server, [Create the server certificate](https://cloud.ibm.com/docs/secrets-manager?topic=secrets-manager-certificates&interface=ui#create-certificates). When creating the cert secret,  // todo: @srikar - . The secret will contain the needed combination of a private key and a certificate.
   4. After the secret is created, Keep the secret id handy.
   5. If you want to enable mtls, the client in the agent will also need its certificates. [Create another certificate template](https://cloud.ibm.com/docs/secrets-manager?topic=secrets-manager-certificate-templates&interface=ui) for the client side. When creating the client certificates,  // todo: @srikar - . Note that you can create this template in the same intermediate CA as above, or you can choose to create a new intermediate CA for client, in which case you have to create another CA as explained in point 1.
   6. Now [Create the client certificate](https://cloud.ibm.com/docs/secrets-manager?topic=secrets-manager-certificates&interface=ui#create-certificates). When creating the cert,  // todo: @srikar - 

3. **Configure variables for secrets from secrets manager**
   
   1. TLS with secrets from secrets manager 

      | variable   | value  |
      |-------------|---------|
      | tls_level | tls |
      | tls_cert_source | secrets-manager |
      | sm_instance_guid | guid from step 1 |
      | sm_job_tls_id | server tls secret id from step 2 |

   2. MTLS with secrets from secrets manager 

      | variable   | value  |
      |-------------|---------|
      | tls_level | mtls |
      | tls_cert_source | secrets-manager |
      | sm_instance_guid | guid from step 1 |
      | sm_job_tls_id | server tls secret id from step 2 |
      | sm_job_runner_tls_id | client tls secret id from step 2 |

   Refer [below table](#variables-explained) for all the terraform variables related to tls


## Steps for self-signed/external certificates :
1. **Bring Self signed certificates or external certificates**
   <!-- Create the self signed certs - explain it. -->
   <!-- explain external certs as well -->
   When running the agent, you can bring your own certificates/keys as well if you're not using IBM secrets manager. You can get the certificates signed from any CA or generate self-signed certificates. 

2. **Configure values for external/self signed certificates**


## Variables explained:

| Input variables      | Description                             | Example             |
|----------------------|-----------------------------------------|---------------------|
| tls_level | This is the level of tls between job-runner and job. For `tls`, server certificate and key are needed, while client certificate and key are also needed for `mtls` | `tls` or `mtls` or `disabled` |
| tls_cert_source | Source of the certificates if tls_level is not disabled. `self-signed` if you bring the certificate values. | `secrets-manager` or `self-signed` |
| sm_instance_guid | Instance ID of the secrets manager. This is needed, if tls_cert_source is `secrets-manager`.  | e4a2f0a4-3c76-4bef-b1f2-fbeae11c0f21 |
| sm_job_tls_id | Secret ID of the server side certificate and key. This is needed if tls_level is not `disabled` and tls_cert_source is `secrets-manager` | cb7a2502-8ede-47d6-b5b6-1b7af6b6f563 |
| sm_job_runner_tls_id | Secret ID of the client side certificate and key. This is needed if tls_level is `mtls` and tls_cert_source is `secrets-manager` | b7a2502s-8ede-47d6-b5b6-1b7af6b6f563 |

All the below variables are needed if tls_level is `mtls`. First two and root_ca are needed, if tls_level is `tls` 

| Input variables      | Description                             | Example             |
|----------------------|-----------------------------------------|---------------------|
| job_tls_self_crt | PEM format certificate value for server side | -----BEGIN CERTIFICATE-----\nMI..i\n-----END CERTIFICATE----- |
| job_tls_self_key  | PEM format key value for server side | -----BEGIN CERTIFICATE-----\nMI..i\n-----END CERTIFICATE----- |
| job_runner_tls_self_crt | PEM format certificate value for client side, if mtls | -----BEGIN CERTIFICATE-----\nMI..i\n-----END CERTIFICATE----- |
| job_runner_tls_self_key | PEM format key value for client side, if mtls | -----BEGIN CERTIFICATE-----\nMI..i\n-----END CERTIFICATE----- |
| root_ca | PEM format ca value. Same ca should be used sign both client and server certs, if mtls | -----BEGIN CERTIFICATE-----\nMI..i\n-----END CERTIFICATE----- |


## Running without tls
Set the value of the terraform variable tls_level to `disabled`. The rest of the values are not needed.

## Configure and Run
Configure the template variables to enable tls and provide ceritificates and [provision the Schematics agent microservices](https://github.ibm.com/schematics-solution/schematics-remote-agents/blob/master/docs/03-remoteagent-service-workspace.md). You will be using these above values in the step 1 there.