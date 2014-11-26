$src = "C:\t1\"
$trg = "C:\t2\"

# open your Windows PowerShell ISE (x86) as Administrator
#  then execute this command
#  >Set-ExecutionPolicy RemoteSigned
# Go to : File>Open  and locate this script
# update $src and $trg with path that needs to be processed, don't forget to add backslash (\) at the end
# Get-childitem C:\t1 | fl -Property *

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
            #Write-Host $_.LastWriteTime
            Copy-Item $($source + $_.name) -Destination $($destination + $($_.BaseName + "_" + ($_ | Select-Object -ExpandProperty LastWriteTime).ToString("MM-dd-yyyy") + $_.Extension)) -Force
        }
        else { # comletly new file
            Copy-Item $($source + $_.name) -Destination $($destination + $_.name) -Force
        }
        }
    }
    
    }

    if($trgc.count -eq 0 -and $srcc.count -ne 0) { # if source is not empty

            Copy-Item $($source +"\*") $destination -Force -recurse
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