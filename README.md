## Install Demo

1. Install AMQ Streams Operator first

```oc apply -k cluster/overlays/operators/default```

This will create a ```seating``` project, wait for the operator to be ready.

2. Install the application

```oc apply -k cluster/overlays/app/default```

Wait for everything to be ready
