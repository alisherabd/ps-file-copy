$src = "C:\t1\"
$trg = "C:\t2\"

# open your Windows PowerShell ISE (x86) as Administrator
#  then execute this command
#  >Set-ExecutionPolicy RemoteSigned
# Go to : File>Open  and locate this script
# update $src and $trg with path that needs to be processed, don't forget to add backslash (\) at the end
# Get-childitem C:\t1 | fl -Property *
function Convert-DateString ([String]$Date)
{
    $theDateTimeObject = ([datetime]::ParseExact($Date,"MM/dd/yyyy h:mm:ss tt",$null))
    $temp =  $theDateTimeObject.month.toString() +"-"+ $theDateTimeObject.day.toString() + "-" + $theDateTimeObject.year.toString()
    return $temp
}

function Copy-Files ([string]$source,[string]$destination){
    $srcc = Get-childitem $source
    $trgc = Get-childitem $destination
   
    if($trgc.count -ne 0) #
    {

     Compare-Object $srcc $trgc -Property Name, Length, Extension, LastWriteTime,BaseName | Where-Object {$_.SideIndicator -eq "<=" } | ForEach-Object {
        
        if($_.Length -eq $null){ # this is folder (non exists)
            Copy-Item $($source + $_.name) $($destination + $_.name) -recurse
        }
        else {
            #Write-Host $("file " + $_.Name)
        if(Test-Path $($destination + $_.name)){ #if file already exists
            $temp = $_.LastWriteTime
            $date = Convert-DateString $temp.toString()
            #Write-Host $_.LastWriteTime
            Copy-Item $($source + $_.name) -Destination $($destination + $($_.BaseName + "_" + $date + $_.Extension)) -Force
        }
        else { # comletly new file
            Copy-Item $($source + $_.name) -Destination $($destination + $_.name) -Force
        }
        }
    }
    
    }

   
    Copy-Folders $source $destination
}

function Copy-Folders ([string]$source,[string]$destination){
    $srcc = Get-childitem $source
    $trgc = Get-childitem $destination

    if($trgc.count -ne 0)
    {
    # this is to find exiting folders
    Compare-Object $srcc $trgc -Property FullName, Length,Name | Where-Object {$_.SideIndicator -eq "<=" -and $_.Length -eq $null} |ForEach-Object {
        
    if(Test-Path $($destination + $_.name)){ #existing folder
        Copy-Files $($_.Fullname+"\") $($destination + $_.Name+"\")
    }
    }
}
}

Copy-Files $src $trg
#Convert-DateString 11/25/2014 5:50:52 PM
#Convert-DateString "11/25/2014 5:50:52 PM" 
#11/25/2014 5:50:52 PM
#"19/09/2014 22:41:27 PM" 
