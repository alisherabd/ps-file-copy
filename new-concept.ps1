cls
$src = "C:\T1"
$trg = "C:\T2"

function Trace-Folder([string]$s,[string]$t){
    get-childitem $s |
    Foreach-Object {
        $target = $_.FullName.Replace($src,$trg)
        if($_.PSIsContainer){ #folder
            if(Test-Path $target){ #folder exist
                Trace-Folder $_.FullName $target
            }
            else { #folder not exist
                Copy-Item $_.FullName -Destination $target -recurse -force -ea SilentlyContinue
                Write-Host "...Copying Folder - " $target
            }
        }
        else{#file
            Trace-File $_ $target
        }
    }
}


function Trace-File($s,[string]$t){
        if(Test-Path $t){ #file exist
            Compare-Object $s.FullName $t | Where-Object {$_.SideIndicator -eq "=>" } | ForEach-Object {
               $version = $($s.DirectoryName.Replace($src,$trg) + "\" + $($s.BaseName + "_" + ($s | Select-Object -ExpandProperty LastWriteTime).ToString("MM-dd-yyyy") + $s.Extension))
               Copy-Item $s.FullName  -Destination $version -force -ea SilentlyContinue
               Write-Host "...Versioning File - " $version
            }
        }
        else { # file not exits
           Copy-Item $s.FullName -Destination $t -force -ea SilentlyContinue
           Write-Host "...Copying File - " $t
        }
}


Trace-Folder $src $trg

#get-childitem $src -recurse | fl -Property *
