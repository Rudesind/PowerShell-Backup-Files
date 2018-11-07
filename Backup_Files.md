## Backup Files
---
Script: Backup_Files.md
Updated: 04/06/2018
Author: Zach Nybo
Version: 3.0

This is a simple powershell script that backs up a specified user directory.

Updated the script to remove use of the Display_Message.ps1 script. The script was converted to a function and is called directly from the script itself.

Updated the script to remove the oldest backup directory when three or more are present.

#### Usage:
```
Backup_Files.ps1
```

The script can also be added to the windows **Task Scheduler**

#### Installation:

1. Create a directory under root directory named **File Backup**
2. In the newly created directory, create two folders named **Icon** and **Logs**
3. In the **Icon** folder, place the icon you wish to be used with the desktop notification. The icon must have the name: **C:\File Backup\Icon\backup_icon.ico**
4. The **Logs** folder will hold all the logs created by the script.
5. On your H:\ drive, create a folder named **Backups**. This is where the files will be backed up to

#### Error Codes:
INITIALIZATION_FAILED (4000): Error occurred when initializing the variables.
LOG_LOAD_FAILED (4001): Error initializing the log file.
COPY_FAILED (4002): Robocopy failed.
FAILED_TO_EXIT (4003): Error occurred when attempted to exit the script.
DIRECTORY_DELETE_FAILED (4004): Error on deleting directory step.
DISPLAY_MESSAGE_FAILED (4005): Could not create desktop alert.


#### Task Scheduler:

To turn this script into a recurring event, create a basic task in the windows task scheduler.

See [This.](https://community.spiceworks.com/how_to/17736-run-powershell-scripts-from-task-scheduler)

### References:
---
[Write-host](https://ss64.com/ps/write-host.html)
[Powershell $Error](http://www.maxtblog.com/2012/07/using-powershell-error-variable/)
[Try Catch](https://community.spiceworks.com/how_to/121063-using-try-catch-powershell-error-handling)
[Invoke-Expression Error Handling](https://stackoverflow.com/questions/32348794/how-to-get-status-of-invoke-expression-successful-or-failed)
[Powershell Exit Code](http://joshua.poehls.me/2012/powershell-script-module-boilerplate/)
[Invoke-Expression](https://ss64.com/ps/invoke-expression.html)
[Invoke script with arguments](https://stackoverflow.com/questions/12850487/powershell-how-to-invoke-a-second-script-with-arguments-from-a-script)
[Icon](https://www.iconfinder.com/icons/473633/backup_data_disk_diskette_floppy_guardar_save_storage_icon#size=128)
[Robocopy Exclude File Types](https://social.technet.microsoft.com/Forums/office/en-US/919ab53c-8a86-439b-bc41-649fce8b9ba1/robocopy-exclude-file-types?forum=w7itprogeneral)
[ISO 8601](https://en.wikipedia.org/wiki/ISO_8601)
[Functions](http://www.jonathanmedd.net/2015/01/how-to-make-use-of-functions-in-powershell.html)
[More Functions](http://windowsitpro.com/windows/create-your-own-powershell-functions)
[[float]\::Maxvalue](http://itknowledgeexchange.techtarget.com/powershell/integer-sizes/)
[Directory Count](https://stackoverflow.com/questions/14714284/count-items-in-a-folder-with-powershell)
[Remove folder](https://stackoverflow.com/questions/7909167/how-to-quietly-remove-a-directory-with-content-in-powershell)
[Comparison Operators](https://ss64.com/ps/syntax-compare.html)
[Converting int](http://hodentekhelp.blogspot.com/2015/06/how-do-you-convert-string-to-integer-in.html)
[Spliting](https://stackoverflow.com/questions/30617758/splitting-a-string-into-separate-variables)
[Folder loop](https://stackoverflow.com/questions/33543052/powershell-loop-through-folders-create-file-in-each-folder)
