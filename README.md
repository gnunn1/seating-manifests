## Install Demo

1. Install AMQ Streams Operator first

```oc apply -k cluster/overlays/operators/default```

This will create a ```seating``` project, wait for the operator to be ready.

2. Install the kafka cluster

```oc apply -k app/kafka/overlays/default```

Wait for all of the zookeeper and broker instances to be ready

2. Install the applications:

```oc apply -k cluster/overlays/app/ocplab```

In a smallish cluster wait for all the builds to be completed and deployed
