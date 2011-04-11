

#     Script:         sgaid.sh
#     Author:         Kyle Hailey
#     Dated:          June 2002
#     Purpose:        return the sgaid for the $ORACLE_SID
#     copyright (c) 2002 Kyle Hailey


# The trace file contents should contain and section like
# where we are looking for the number 16896
#
# Area #0 `Fixed Size' containing Subareas 0-0
#  Total size 000000000006f21c Minimum Subarea size 00000000
#   Area  Subarea    Shmid      Stable Addr      Actual Addr
#      0        0    16896 0000000020000000 0000000020000000
#

files=`ls *trc`
count=`echo $files | wc -w`
echo $count
echo $files
if [ $count -eq  1 ]; then
  echo "do you want to use file $files? [y|n]"
  read response
else
  response="n"
fi
if test $response = "y"; then
   cat $files  | \
   awk '
      { if ( found == 1 ) 
        {
          print $3 
          exit
        }
   }
   /Shmid/ { found = 1 }
   '
else
for i in 1; do
  sqlplus /nolog << EOF 
    -- connect internal
    connect sys/sys as sysdba
    oradebug setmypid
    oradebug ipc
    oradebug tracefile_name
    exit
EOF
  done  | grep trc  | sed -e 's/[^/]*\//\//' > tracename
   cp `cat tracename` .
   cat `cat tracename`  | \
   awk '
      { if ( found == 1 ) 
        {
          print $3 
          exit
        }
   }
   /Shmid/ { found = 1 }
   '
fi

