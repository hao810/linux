#!/bin/bash
# monitor mysql status
# if this node mysql is dead and its slave delay less than 120 seconds, then stop its keepalived. The other node will bind the IP.
 
export MYSQL_HOME=/opt/mysql
export PATH=$MYSQL_HOME/bin:$PATH
 
mysql="$MYSQL_HOME/bin/mysql"
delay_file="$MYSQL_HOME/log/slave_delay_second.log"
slave_host=$1
 
#$mysql -u root --connect_timeout=3 --execute="select version();"
netstat -tunlp | grep 3306
 
if [ $? -ne 0 ]; then
 delayseconds=`cat $delay_file`
 if [ $delayseconds -le 120 ]; then
   systemctl stop keepalived
 fi
 exit 1 #bad
fi
 
# Get slave delay time and save it
$mysql -usk -ppassword -h$slave_host --connect_timeout=3 -e"select version();"
if [ $? -eq 0 ]; then
  delayseconds=`$mysql -uroot -pLiuyangfu# -h$slave_host --connect_timeout=3 -e"show slave status\G"|grep Seconds_Behind_Master|awk '{print \$2}'`
  if [[ "$delayseconds" =~ ^[0-9]+$ ]] ; then
     echo "$delayseconds" > $delay_file
  else
     echo "9999" > $delay_file
  fi
fi
exit 0 #good
