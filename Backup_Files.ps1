#--------------------------------#
# Script : Backup_Files.ps1
# Updated: 04/06/2018
# Author : Zach Nybo
# Version: 3.0
# Documentation: Backup_Files.md
#
# Summary:
# This script copies files in one
# location to another specified
# location excluding large file
# types. Mainly used as a simple
# way of backing up small
# important files.
#--------------------------------#


# TODO: Run script only if connected to URMSTORES domain
#-------------------------#
# Display Prompt Function #
#-------------------------#

function DisplayMessage ($type, $title, $text, $icon) {

    # Load the .Net assembly
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")


    # Create a new object for the desktop alert
    $desktopAlert = New-Object System.Windows.Forms.NotifyIcon

    # Item Parameters
    $desktopAlert.Icon = $icon
    $desktopAlert.BalloonTipIcon = $type
    $desktopAlert.BalloonTipTitle = $title
    $desktopAlert.BalloonTipText = $text
    $desktopAlert.Visible = $True
    $desktopAlert.ShowBalloonTip(10000)
}

#--------------#
# Log Function #
#--------------#

# Idea taken from:
# https://stackoverflow.com/questions/7834656/create-log-file-in-powershell
# The below function is used to write to a log file

Function LogWrite
{

    # Parameters for the function include the string to write to the file
    Param ([string]$logstring)

    # The current time stamp for the log entry. Updated with every write
    $time = Get-Date -Format g

    # Write the contents to a log file at the specified location
    Add-content $logFile -value "$time $logstring" -ErrorAction Stop

}

#--------------------#
# Script Information #
#--------------------#

New-Variable SCRIPT -option Constant -value "Backup_Files.ps1"
New-Variable AUTHOR -option Constant -value "Zach Nybo"
New-Variable UPDATED -option Constant -value "04/06/2018"
New-Variable VERSION -option Constant -value "3.0"

#-------------#
# Error Codes #
#-------------#

New-Variable INITIALIZATION_FAILED -option Constant -value 4000
New-Variable LOG_LOAD_FAILED -option Constant -value 4001
New-Variable COPY_FAILED -option Constant -value 4002
New-Variable FAILED_TO_EXIT -option Constant -value 4003
New-Variable DIRECTORY_DELETE_FAILED -option Constant -value 4004
New-Variable DISPLAY_MESSAGE_FAILED -option Constant -value 4005

#----------------------#
# Initialize variables #
#----------------------#

try {

    # Friendly error message
    $errorMsg = ""

    # Time stamp is in ISO 8601 standard
    $timestamp = Get-Date -format "yyyyMMddTHHmmss"

    # Root directory for destination
    $destdir = "H:\Backups\"

    # Root directory for logfile
    $logdir = "C:\File Backup\Logs\"

    # Log file path
    $logfile = $logdir + "Backup_logfile_" + $timestamp + ".txt"

    # Destination path
    $destination = $destdir + "Backup_" + $timestamp

    # Source path
    # TODO: Try to include the 'zach2' user directory
    $source = "C:\Users\zach2\Desktop\Stuff"

    # Excludes
    $exclude = "*.exe", "*.iso","*.TIB","*.wim","*.PML", "*.hdmp", "*.mdmp", "*.msu", "*.msi", "*.file", "*.dll", "*.asar", "*.vmdk"

    # Display Message Icon file
    $messageIcon = "C:\File Backup\Icon\backup_icon.ico"

    # Display Message Text
    $messageText = "The file backup process has started."

    #Display Message title
    $messageTitle = "File Backup"

} catch {
    $errorMsg = "Error, could not Initialize script: " + $Error[0]
    exit $INITIALIZATION_FAILED
}

#-------------------#
# Initialize logile #
#-------------------#

try {

    LogWrite "---"
    LogWrite "$SCRIPT"
    LogWrite "$UPDATED"
    LogWrite "$AUTHOR"
    LogWrite "$VERSION"
    LogWrite "---"

} catch {
    $errorMsg = "Error, could not load log file: " + $Error[0]
    exit $LOG_LOAD_FAILED
}

#---------------#
# Display Alert #
#---------------#
# TODO: Find way to 'clear' the alerts before creating another one
try {

    # Display an informational desktop alert that the backup has started
    LogWrite "Display desktop alert..."

    DisplayMessage -type Info -title $messageTitle -text $messageText -icon $messageIcon

    LogWrite "Done"

} catch {
    $errorMsg = "Error, could not display alert: " + $Error[0]
    LogWrite $errorMsg
    LogWrite "Exiting with error code: $DISPLAY_MESSAGE_FAILED"
    exit $DISPLAY_MESSAGE_FAILED
}

#***Clear Directory***#
<# Turning off until it can be tested again
TODO: Troubleshoot and test the Clear Directory section
try {

  Write-host "Checking Directory..."
  echo "Checking Directory..." >> $logfile

  # Only three backup folders are allowed at a time. Get the number of folders
  $count = (Get-ChildItem $destdir | Measure-Object).count

  # List folders to log
  Write-host (Get-ChildItem $destdir)
  echo (Get-ChildItem $destdir >> $logfile)

  # Check if count is then than 3
  if ($count -lt 3) {

    # Not enough folders, no delete.
    Write-host "Less then three folders present, no directories will be deleted"
    echo "Less then three folders present, no directories will be deleted" >> $logfile

  }
  else {

    Write-host "More than two folders present, begining delete..."
    echo "More than two folders present, begining delete... " >> $logfile

    # Three or more folders found, will perform delete action.
    # Variable holds a value larger than any possible timestamp
    $smallStamp = [float]::MaxValue
    Set-PSDebug -Trace 1
    # Get every folder at the directory
    Get-ChildItem $destdir -Recurse -Directory | ForEach-Object {

      # Get the path to the folder
      $fullName = $_.FullName
      # Extract the timestamp from the folder name
      $junk, $timestamp = $_.Name.Split('_') -replace '[T]',''
      # Cast the timestamp as float value
      [float]$floatValue = [float]$timestamp

      # Check for the smaller timestamp
      if ($floatValue -lt $smallStamp) {

        # Set the smaller timestamp to the current timestamp
        $smallStamp = $floatValue
        # Set the folder to be deleted
        $delete = $fullName

      }

    }

    # Delete the folder
    Write-host "Deleting the directory: $delete"
    echo "Deleting the directory: $delete" >> logfile
    Remove-Item $delete -Force -Recurse

  }

} catch {
  $errorMsg = "Error, could not delete directory: " + $Error[0]
  Write-host $errorMsg
  echo $errorMsg >> $logfile
  exit $DIRECTORY_DELETE_FAILED
}
#>

#------------#
# Copy Files #
#------------#
try {

    # Use robocopy to copy the files to the destination
    LogWrite "Begining copy..."

    robocopy $source $destination /Z /E /XF $exclude  >> $logfile

    LogWrite "Done"

    # Alternative method for coping the files to the destinatino:
    # Copy-Item -path $source -destination $destination -exclude "*.exe", "*.iso","*.TIB","*.wim","*.PML", "*.hdmp", "*.mdmp", "*.msu", "*.msi" -recurse

} catch {
    $errorMsg = "Error, could not copy the file or directory: " + $Error[0]
    LogWrite $errorMsg
    LogWrite "Exiting with error code: $COPY_FAILED"
    exit $COPY_FAILED
}

#---------------#
# Display Alert #
#---------------#

try {

    # Display an informational desktop alert that the backup has finished
    LogWrite "Displaying desktop alert..."

    DisplayMessage -type Info -title $messageTitle -text $messageText -icon $messageIcon

    LogWrite "Done"

} catch {
    $errorMsg = "Error, could not display alert: " + $Error[0]
    LogWrite $errorMsg
    LogWrite "Exiting with error code: $DISPLAY_MESSAGE_FAILED"
    exit $DISPLAY_MESSAGE_FAILED
}

#------#
# Exit #
#------#

try {

    # Exit
    $code = "0"
    LogWrite "Exiting script with error code: $code"

} catch {
    $errorMsg = "Error, could not exit: " + $Error[0]
    LogWrite $errorMsg
    LogWrite "Exiting with error code: $FAILED_TO_EXIT"
    exit $FAILED_TO_EXIT
}
