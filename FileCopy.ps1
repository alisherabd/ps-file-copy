$src = "C:\t1\"
$trg = "C:\t2\"

# open your Windows PowerShell ISE (x86) as Administrator
#  then execute this command
#  >Set-ExecutionPolicy RemoteSigned
# Go to : File>Open  and locate this script
# update $src and $trg with path that needs to be processed, don't forget to add backslash (\) at the end



function Copy-Files ([string]$source,[string]$destination){
    $srcc = Get-childitem $source
    $trgc = Get-childitem $destination
    Compare-Object $srcc $trgc -Property Name, Length | Where-Object {$_.SideIndicator -eq "<=" } | ForEach-Object {
        if($_.Length -eq $null){ # this is new folder folder
            Copy-Item $($source + $_.name) $($destination + $_.name) -recurse
        }
        else {
            #Write-Host $("file " + $_.Name)
            if(Test-Path $($destination + $_.name)){ #if file already exists 
                Copy-Item $($source + $_.name) -Destination $($destination + $("new_"+$_.name)) -Force
            }
            else { # comletly new file
                Copy-Item $($source + $_.name) -Destination $($destination + $_.name) -Force
            }
        }
    }
    Copy-Folders $source $destination
}

function Copy-Folders ([string]$source,[string]$destination){
    $srcc = Get-childitem $source
    $trgc = Get-childitem $destination

    Compare-Object $srcc $trgc -Property FullName, Length,Name | Where-Object {$_.SideIndicator -eq "<=" -and $_.Length -eq $null} |ForEach-Object {
        
    if(Test-Path $($destination + $_.name)){ #existing folder
        Copy-Files $($_.Fullname+"\") $($destination + $_.Name+"\")
    }
}
}

Copy-Files $src $trg

