# Clears all rows from seating database
oc exec deploy/seatsdb -- bash -c  'mysql -h "${SEATSDB_SERVICE_HOST}" -u "${MYSQL_USER}" -p"${MYSQL_PASSWORD}" ${MYSQL_DATABASE} -e "delete from bookedseat"'
oc exec deploy/seatsdb -- bash -c  'mysql -h "${SEATSDB_SERVICE_HOST}" -u "${MYSQL_USER}" -p"${MYSQL_PASSWORD}" ${MYSQL_DATABASE} -e "select * from bookedseat"'