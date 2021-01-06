# Clears all rows from registration database
oc exec deploy/registerdb -- bash -c  'mysql -h "${REGISTERDB_SERVICE_HOST}" -u "${MYSQL_USER}" -p"${MYSQL_PASSWORD}" ${MYSQL_DATABASE} -e "delete from reservationlist"'
oc exec deploy/registerdb -- bash -c  'mysql -h "${REGISTERDB_SERVICE_HOST}" -u "${MYSQL_USER}" -p"${MYSQL_PASSWORD}" ${MYSQL_DATABASE} -e "select * from reservationlist"'