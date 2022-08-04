#!/bin/bash
#run this script as root
#i.e. provide where you want to write your logs to as "/var" without the "/" at the end

#get directory user wants to create backup logs to
echo "Where do you want to write your /var/log/ logs to? (i.e. /var or /tmp)"
read logDir

#create directories for logbackupper if they don't exist
[ -d $logDir/backups/logBackupper ] || mkdir -p $logDir/backups/logBackupper
[ -d $logDir/backups/logBackupper/logs ] || mkdir -p $logDir/backups/logBackupper/logs
[ -d $logDir/backups/logBackupper/error ] || mkdir -p $logDir/backups/logBackupper/error
[ -d $logDir/backups/logBackupper/hashed ] || mkdir -p $logDir/backups/logBackupper/hashed

#send all stderr to error.log
exec 2>> $logDir/backups/logBackupper/error/error.log

#print a ran and hashed statement to record times logbackupper was ran in error.log and hashed_logs.txt
echo "Ran on $(date)" >> $logDir/backups/logBackupper/error/error.log
echo "Hashed on $(date)" >> $logDir/backups/logBackupper/hashed/hashed_logs.txt

USERDIR=/var/log

#letting user know backing up has begun
echo "Backing up..."

#3 second timer
sleep 3

#loop over provided directory and copy log files with appended time stamp
for file in $USERDIR/*.l*
do	
	cp $file $logDir/backups/logBackupper/logs/$(echo $file | cut -d/ -f4)-$(date -Iseconds)
	md5sum $file >> $logDir/backups/logBackupper/hashed/hashed_logs.txt
done

#inform user the process has completed
echo "\n" >> $logDir/backups/logBackupper/hashed/hashed_logs.txt
echo "Complete!"
