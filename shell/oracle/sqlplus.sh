admin_userid="mcdbra/mcdbra@drb"  
re=$(sqlplus $admin_userid  <<EOF
select * from tab where rownum<3;
exit
EOF)


echo "start^^^^^^^^^^^^^^^^^^^^^^^^^"
echo $re
echo "end^^^^^^^^^^^^^^^^^^^^^^^^^"