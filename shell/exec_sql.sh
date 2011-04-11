#!/bin/ksh
############################################################
#exec_sql.sh $1 $2 $3
#exec_sql.sh "userid" "file name" "sql command"
############################################################

admin_userid=$1
sql_command=$2
sql_command=`echo $sql_command|tr 'A-Z' 'a-z'`

case $sql_command in
*until*cancel*)
  sqlplus -s "$admin_userid" <<EOF
  whenever sqlerror continue
  $sql_command
cancel
exit
EOF
;;
*)
  sqlplus -s "$admin_userid" <<EOF
  whenever sqlerror continue
  set autorecovery on
  $sql_command
  exit
EOF
;;
esac

