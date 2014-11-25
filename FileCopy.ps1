$src = "C:\t1\"
$trg = "C:\t2\" 


function Copy-Files ([string]$source,[string]$destination){
    $srcc = Get-childitem $source
    $trgc = Get-childitem $destination

    Compare-Object $srcc $trgc -Property Name, Length | Where-Object {$_.SideIndicator -eq "<=" } | ForEach-Object {
        if($_.Length -eq $null){ # this is folder
            #Write-Host $("folder " + $_.Name)

        }
        else {
            #Write-Host $("file " + $_.Name)
            if(Test-Path $($destination + $($_.name))){ #if file already exists 
                #Copy-Item $($source + $($_.name)) -Destination $($destination + $("new_"+$_.name)) -Force
            }
            else { # comletly new file
                #Copy-Item $($source + $($_.name)) -Destination $($destination + $($_.name)) -Force
            }
        }
}
}

function Copy-Folders ([string]$source,[string]$destination){
    $srcc = Get-childitem $source
    $trgc = Get-childitem $destination

    Compare-Object $srcc $trgc -Property Name, Length | Where-Object {$_.SideIndicator -eq "<="} | ForEach-Object {
        
        Write-Host $($_.SideIndicator)
        #Write-Host $($_.name)
        

        #Copy-Item "C:\Folder1\$($_.name)" -Destination "C:\Folder3" -Force
}
}

Copy-Files $src $trg

