# macupdate

updates mac applications restarting computer if needed. Will bypass filevault login on restart for encrypted machines when pair with filevault credentials in rmm.

Roadmap:
check for updates before proceeding with script.
  no updates - end
  check for and set restart flag
  perform user notifications and app closures based on results
Replace close all apps automator script with pkill.
  rev2 - selectivly close only apps required for update
run silently in background unless needed
  no restart required, no open apps - run update silently in background
  Pages is open, need to close to update - The following apps will close for updating in 2 minutes:Pages. Please save your work.
  OS update requires restart - Running updates. Restart required. Please save your work.


CONFIRMED
3rd Party Apps from App store do not show in softwareupdate --list
--UNKNOWN: will 3rdparty apps show if distributed through VolumeLicensing? OR Can volume licensing be pushed out through Profile manager?
--UNCONFIRMED: will apple iWork and iLife apps list and update through softwareupdate?
----iTunes does list and update. ran itunes update while itunes was running and received error exit code. not sure if it was because app was running, but the update completed successfully.
