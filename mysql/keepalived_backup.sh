#!/bin/bash
 
my_host=`hostname`
current_date=`/bin/date +"%b %d %H:%M:%S"`
From="$my_host"
#mail_list=alexzeng@wordpress.com
 
#Subject="$my_host is BACKUP"
Msgboday="$current_date : mysql is offline at $my_host"
#echo "$Msgboday" | /usr/bin/mailx  -s "$Subject" "$mail_list"
echo "$Msgboday" >> /opt/mysql/log/notify.log
