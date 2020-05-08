![alt text](https://raw.githubusercontent.com/gnunn1/seating-manifests/master/docs/seating.png)

## Credits

Christina Lin (https://github.com/weimeilin79/sko2018) wrote the original version of this great demo.

## Demo

This demo uses Fuse and Kafka to manage seating reservations and allocations. The flow of the services is shown in the diagram below going from left to right.

![alt text](https://raw.githubusercontent.com/gnunn1/seating-manifests/master/docs/Fuse-Streams-3Scale-Demo-Small.png)

The intent of the demo is to highlight the Agile Integration architecture as used in an event driven architecture.

## Install demo in your OpenShift cluster

This demo uses kustomize to manage cluster specific settings. Kustomize is a patching framework that is included with kubectl/oc so there is no need to download a different tool.

To modify the settings for your cluster, clone one of the clusters in the ```cluster/overlays``` folder and then update the patch
files as needed for your environment. The most significant thing that needs updating are the route references the UI components
have to their back-end services.

## Pre-requisites

1. Install the Red Hat Jaeger operator

2. Have a 3scale admin portal installed or available. If you are a Red Hat employee you can request access to the 3scale hosted environment which is what I use for the majority of my demos.

3. This demo uses kustomize to install the components, you will need to create an overlay for settings that are specific to your cluster.

    * Copy ```cluster/overlays/ocplab``` into a new folder for your cluster, i.e. ```cluster/overlays/mycluster```

    * Update the routes to match the routes in your cluster

    * For 3scale you need to provide a secret for apicast to connect to the 3scale admin portal. I use Bitnami's SealedSecret however you can create a secret manually or add it to the apicast overlay. To create the secret manually use the following replacing ```<access-token>``` and ```<admin_portal_domain>``` for your specific 3scale instance.

        ```oc create secret generic apicast-configuration-url-secret --from-literal=password=https://<access_token>@<admin_portal_domain>  --type=kubernetes.io/basic-auth```

4. Login as a user with cluster-admin rights since this will install operators as needed.

5. Ensure the fuse7-java-openshift image is installed for Fuse 7.6, check the tags in use:

    ```oc get is -n openshift | grep fuse-java-openshift```

If there is no 1.6 tag (i.e. only 1.5 or earlier shows), import the Fuse 7.6 imagestream:

      oc apply -f https://raw.githubusercontent.com/jboss-fuse/application-templates/2.1.x.sb2.redhat-7-6-x/is-image-streams.json -n openshift

## Install Demo Application

1. Install AMQ Streams Operator first

    ```oc apply -k app/amq-streams-operator/overlays/default```

This will create a ```seating``` project, wait for the operator to be ready.

2. Install the kafka cluster, you can either install a full 3 replica cluster using:

    ```oc apply -k app/kafka/overlays/default```

    Or a minimal 1 replica instance using:

    ```oc apply -k app/kafka/overlays/minimal```

    Wait for all of the zookeeper and broker instances to be ready

3. Install the seats application:

    ```oc apply -k cluster/overlays/<your cluster>/app/seats```

    In a smallish cluster wait for all the builds to be completed and deployed before moving onto the next app. In a larger cluster
    you can deploy everything in parallel.

4. Install the registration application:

    ```oc apply -k cluster/overlays/<your cluster>/app/registration```

5. Install the Dashboard. All of the individual UIs are available, the dashboard deploys a simple iFrame application so that everything can be view in one window.

    ```oc apply -k app/dashboard/overlays/default```

6. Optionally deploy 3scale gateways. Note I use a sealed secret in my ocplab cluster, you will need to replace this your own secret in order for the gateways to connect to the 3scale admin portal. See the 3scale docs.

    ```kustomize build cluster/overlays/<your cluster>/app/apicast | oc apply -f -```

## Install Monitoring

1. Install the monitoring operators, wait for the grafana and prometheus monitors to be ready

    ```oc apply -k monitoring/operators/overlays/default```

2. Install AMQ Streams specific security requirements for their dashboards:

    ```oc apply -k monitoring/security/base```

3. Generate secret for fuse console:

    ```
    cd scripts/generate-fuse-console-cert
    ./generate.sh
    ```

4. Install the monitoring package

    ```oc apply -k cluster/overlays/<your cluster>/monitoring```

## Access rights

1. Add non-admin user to projects (user1 in ocplab example)

    ```oc apply -k cluster/overlays/<your cluster>/security```

## 3scale Developer Portal

1. A swagger file is available in the scripts/swagger directory that can be used to configure a seats as an API Product with two backends.

## Running the demo

1. Open the Dashboard in the seating project, this will give you three UI elements: a map of seats available, a form that can be filled out to register a seat and a feed of seat registrations

![alt text](https://raw.githubusercontent.com/gnunn1/seating-manifests/master/docs/dashboard.png)

2. Fill out the form to register a seat, the icon for the seat should change to black if it was successful.

3. Open Jaeger monitoring in the ```seating-monitoring``` project and look at the registration-ui service to see a trace of the services that were traversed to process the rgistration

![alt text](https://raw.githubusercontent.com/gnunn1/seating-manifests/master/docs/jaeger.png)

4. Now show a traditional integration using CSV files. Change directory to ```scripts/loader``` and look at the reservations.csv file which contains three rows. Run the upload.sh script which will copy the file to the reservation-loader pod for processing. You should see three seats be reserved.

5. Check Jaeger and look at the trace for registration-loader to see how the file was processed

6. Log into the fuse-console in ```seat-monitoring``` and connect to the registration-loader. Notice how it receives one message, the file, and then splits it into three message to process each row individually.

7. Scale up the seat-simulator to 1, this service will randomly reserve seats to generate traffic. While it is running use the grafana dashboards to monitor Kafka and Fuse.

![alt text](https://raw.githubusercontent.com/gnunn1/seating-manifests/master/docs/fuse-dashboard.png)
