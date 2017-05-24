#!/bin/bash
#This script should be run weekly over the weekend
#Send reminder to log out on Friday afternoon - dialog window with ok button
#Automatic App store updates should be disabled - this way users are not prompted during the week

#Testing
##test with all users logged out
##why are app store apps not updating?

#optional improvements
##log out all users - right now we only quit apps for current user. if other users are logged in they can still have apps open
##try to nicely close apps 1st, then try forcing them shut - force shut not needed. apple apps save live. 3rd party don't update through this script
##force restart on machine, then run updates and restart
##or restart (forced), restart (clean), update, restart
##change sleep delay to wait until after app close timeout ends - would need to close notification windows after updates are done

#define and initialize variables
RESTART=false

#check for updates
softwareupdate --list --verbose &> updatelist.txt

#read updatelog to stdout
input="updatelist.txt"
while IFS= read -r var
do
  echo "$var"
done < "$input"

#set restart flag if needed
grep -q 'restart' updatelist.txt && RESTART=true

#Display maintenance warning
osascript -e 'tell app "System Events" to display dialog "This computer will close all programs in 5 minutes for maintenance. Please save your work." buttons {"OK"} default button 1 with icon caution with title "Starting Maintenance - Save Your Work" giving up after 300'

#give user 5 mins to finish working
sleep 300

#close Mac apps that require updating
grep -q 'iTunes' updatelist.txt && pkill "iTunes"
grep -q 'Pages' updatelist.txt && pkill "Pages"
grep -q 'Numbers' updatelist.txt && pkill "Numbers"
grep -q 'Keynote' updatelist.txt && pkill "Keynote"
grep -q 'iPhoto' updatelist.txt && pkill "iPhoto"
grep -q 'Photos' updatelist.txt && pkill "Photos"
grep -q 'GarageBand' updatelist.txt && pkill "GarageBand"
grep -q 'iMovie' updatelist.txt && pkill "iMovie"
grep -q 'Safari' updatelist.txt && pkill "Safari"

#Check for and run OS updates
softwareupdate -ia --verbose 2>&1

#Check if reboot is needed
if [ $RESTART = true ]; then
	#Display restart warning
	osascript -e 'tell app "System Events" to display dialog "This computer is restarting complete maintenance." buttons {"OK"} default button 1 with icon caution with title "Restarting Computer"'
	sleep 15

#check if Filevault is enabled and reboot appropriately
if [ "$(fdesetup isactive)" != 'true' ]; then
        echo "This device is NOT encrypted. Rebooting now."
        shutdown -r now 2>&1
        exit
else
	echo "This device is encrypted. Rebooting via fdesetup."
	echo $ADMINPW | fdesetup authrestart -verbose 2>&1
        exit
fi

else
	exit
fi
