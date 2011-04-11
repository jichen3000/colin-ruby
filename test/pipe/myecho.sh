
var0=0
LIMIT=10000

while [ "$var0" -lt "$LIMIT" ]
do
  echo "index:$var0"
  sleep 0.4
  let "var0 += 1"
done

echo "end!"
