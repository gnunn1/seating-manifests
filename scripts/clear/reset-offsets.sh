# Deployments that need to be scaled down to reset offset
deploy=("registration-command" "registration-ui" "seat-listener" "seat-request")
# Scale down all the consumers
echo "Scaling down kafka consumers"
for i in "${deploy[@]}"
do
   oc scale deploy/$i --replicas=0 -n seating
done

# # Reset offsets
# echo "Reset offsets"
oc exec seating-kafka-0 -- bin/kafka-consumer-groups.sh --bootstrap-server localhost:9092 --group registrationgroup --group seatgroup  --reset-offsets --to-earliest --all-topics --execute

# Scaleup all the consumers
echo "Scaling up kafka consumers"
for i in "${deploy[@]}"
do
   oc scale deploy/$i --replicas=1 -n seating
done