POD_NAME=$(oc get pods -oname -l deploymentconfig=registration-loader | sed 's/pod\///')

echo "Copying reservations.csv to ${POD_NAME}:/home/jboss/reservations.csv"

oc cp ./reservations.csv ${POD_NAME}:/home/jboss/reservations.csv -n seating