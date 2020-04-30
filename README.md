## Credits

Based on a demo from Christina Lin (https://github.com/weimeilin79/sko2018)

## Install demo in your OpenShift cluster

This demo uses kustomize to manage cluster specific settings. Kustomize is a patching framework that is included with kubectl/oc so there
is no need to download a different tool.

To modify the settings for your cluster, clone one of the clusters in the ```cluster/overlays``` folder and then update the patch
files as needed for your environment. The most significant thing that needs updating are the route references the UI components
have to their back-end services.

## Install Demo

1. Install AMQ Streams Operator first

```oc apply -k app/amq-streams-operator/overlays/default```

This will create a ```seating``` project, wait for the operator to be ready.

2. Install the kafka cluster, you can either install a full 3 replica cluster using:

```oc apply -k app/kafka/overlays/default```

Or a minimal 1 replica instance using:

```oc apply -k app/kafka/overlays/minimal```

Wait for all of the zookeeper and brokeroc delete instances to be ready

3. Install the seats application:

```oc apply -k cluster/overlays/ocplab/app/seats```

In a smallish cluster wait for all the builds to be completed and deployed before moving onto the next app. In a larger cluster
you can deploy everything in parallel.

4. Install the registration application:

```oc apply -k cluster/overlays/ocplab/app/registration```

5. Optionally install the analytics application (note this is currently tested, may not work):

```oc apply -k cluster/overlays/ocplab/app/analytics```

6. Optionally install the Dashboard. All of the individual UIs are available, the dashboard deploys a simple iFrame application so that everything can be view in one window.

```oc apply -k app/dashboard/overlays/default```

7. Optionally deploy 3scale gateways. Note I use a sealed secret in my ocplab cluster, you will need to replace this your own secret in order for the gateways to connect to the 3scale admin portal. See the 3scale docs.

```kustomize build cluster/overlays/ocplab/app/apicast | oc apply -f -```
