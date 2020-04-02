Function fnLogWrite
{
    param(
    [string]$sourceFile,
    [string]$logstring
    )

   $datetime = Get-Date -Format g
   Add-content $SourceFile -value "$datetime - $logstring"
}



$debug = $false

$sourceFile = "C:\tempdata\movefile.log"
$userOutputFile = "C:\tempdata\files-moved.txt"
$showOutput = $false
$banList = '*.jpg', '*.jpeg', '*.png', '*.mp4', '*.avi', '*.flv', '*.3gp','*.mkv', '*.mov', '*.vob', '*.mpg', '*.mpeg', '*.bup', '*.ifo', '*.mp3', '*.m4a'

$homeDrive = "H:"
$localDrive = "C:\Users\$ENV:UserName\Personal"


# create personal folder
# --------------------------------------------------------------------------
If(!(Test-Path $localDrive)) {
    New-Item -Path $localDrive -ItemType Directory -Force 
    }

If(!(Test-Path $sourceFile)) {
    New-Item -Path $sourceFile -ItemType File -Force 
}


# clear userOutputFile and insert standard template
# --------------------------------------------------------------------------
If($userOutputFile) {
    Clear-Content $userOutputFile

    Add-Content $userOutputFile "
Hello $env:username,
The following media files have been moved as per policy. 
- If it's work-related media, please move it to M:.
- If you need to work remotely on it, or it's personal, it can stay in your personal folder.

Your personal folder is accessible via Start > All Programs > _Personal Folder.

"
}

# get file list
# --------------------------------------------------------------------------  
fnLogWrite -sourcefile $sourceFile -logstring "--------------------------------------------------------------------------"
fnLogWrite -sourcefile $sourceFile -logstring "Getting files for $homeDrive"
$files = Get-ChildItem $homeDrive -Include $banList -Recurse -Force

    
# start
# -------------------------------------------------------------------------- 

ForEach ($file in $files) {
    
    $noQualifierFolder = Split-Path $($file.directoryName) -NoQualifier   
    $folderOnHomeDrive = $homeDrive + $noQualifierFolder
    $folderOnLocalStorage = $localDrive + $noQualifierFolder
    $fileOnLocalStorage = $localDrive + $noQualifierFolder + "\" + $($file.Name)
 
    if($debug) {
        Write-Output "Checking variables: `
        $noQualifierFolder `
        $folderOnHomeDrive ` 
        $folderOnLocalStorage `
        $fileOnLocalStorage "           
    }


    # try to have some form of automatic deletion
    # -------------------------------------------------------------------------- 
    $banNames = @("*xvid*","*eztv*""*hdrip*","*KORSUB*", "*WEBRip*","*DVDRip*","*WEB-DL*","*HDTV*")
    $result = $banNames | where { $file.Name -like $_ }

    If ($result -ne $null) {
        $showOutput = $true
        Remove-Item -LiteralPath $($file.FullName) -Force
        fnLogWrite -sourcefile $sourceFile -logstring "Deleted file $file"
        Add-Content $userOutputFile "File deleted: $file"
    }

    
    # create folder and move files
    # --------------------------------------------------------------------------   
    Else {
        If(!(Test-Path $folderOnLocalStorage)) {
            New-Item -Path $folderOnLocalStorage -ItemType Directory -Force
        }


        # create folder and move files
        # -------------------------------------------------------------------------- 
        If($($file.FullName) -notlike "*RECYCLE.BIN*") {
            $showOutput = $true
            Move-Item -LiteralPath "$($file.FullName)" -Destination $folderOnLocalStorage -Force
            fnLogWrite -sourcefile $sourceFile -logstring "Moving file $file to $folderOnLocalStorage"

            # create shortcut, depending on OS version
            # -------------------------------------------------------------------------- 
            $OSversion = [Environment]::OSVersion.Version
            if ($OSversion -like "10.*") {
                $path = "$fileOnLocalStorage"
                $QuickAccess = New-Object -ComObject shell.application 
                $QuickAccess.Namespace("shell:::{679f85cb-0220-4080-b29b-5540cc05aab6}").Items() | where {$_.Path -eq "$Path"} 
                $QuickAccess.Namespace("$Path").Self.InvokeVerb(“pintohome”)
            }
            elseif  ($OSversion -like "6.1.*") {
                $shell = New-Object -ComObject WScript.Shell
                $shortcut = $shell.CreateShortcut("$($file.FullName).lnk")
                $shortcut.TargetPath = "$fileOnLocalStorage"
                $shortcut.Save()
            }
   
    
            fnLogWrite -sourcefile $sourceFile -logstring "Saving shortcut file $shortcut to $fileOnLocalStorage"
            Add-Content $userOutputFile "File moved: $file to $folderOnLocalStorage"
        }
    }
}


# show output file on end
# -------------------------------------------------------------------------- 
If ($showOutput -eq $true) {
    Start-Process notepad $userOutputFile
}
Else {
    fnLogWrite -sourcefile $sourceFile -logstring "No files to process"
}