for i in 9 7 3 8
do 
  if [ i -gt 4 ] 
  then
    echo $i
  fi
done
FILENAME="d:\new3"

function while_read_LINE
{
cat $FILENAME | while read LINE
do
         echo "$LINE"
done
}
while_read_LINE