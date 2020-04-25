## Install demo in your OpenShift cluster

This demo uses kustomize to manage cluster specific settings. Kustomize is a patching framework that is included with kubectl/oc so there
is no need to download a different tool.

To modify the settings for your cluster, clone one of the clusters in the ```cluster/overlays``` folder and then update the patch
files as needed for your environment. The most significant thing that needs updating are the route references the UI components
have to their back-end services.

## Install Demo

1. Install AMQ Streams Operator first

```oc apply -k cluster/overlays/operators/default```

This will create a ```seating``` project, wait for the operator to be ready.

2. Install the kafka cluster

```oc apply -k app/kafka/overlays/default```

Wait for all of the zookeeper and broker instances to be ready

3. Install the seats application:

```oc apply -k cluster/overlays/ocplab/app/seats```

In a smallish cluster wait for all the builds to be completed and deployed before moving onto the next app. In a larger cluster
you can deploy everything in parallel.

4. Install the registration application:

```oc apply -k cluster/overlays/ocplab/app/registration```

<!-- 5. Install the analytics application:

```oc apply -k cluster/overlays/ocplab/app/analytics``` -->