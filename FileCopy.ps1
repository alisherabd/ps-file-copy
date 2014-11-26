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

   if($srcc.count -ne 0 -and $trgc.count -ne 0 ){
     Compare-Object $srcc $trgc -Property Name, Extension, LastWriteTime,BaseName,PSIsContainer | Where-Object {$_.SideIndicator -eq "<=" } | ForEach-Object {
        
         #if($_.PSIsContainer){ # this is folder (non exists)
            #Copy-Item $($source + $_.name) $($destination + $_.name) -recurse -force -ea SilentlyContinue
        #}
        if(-Not $_.PSIsContainer) {
        if(Test-Path $($destination + $_.name)){ #if file already exists
            Copy-Item $($source + $_.name) -Destination $($destination + $($_.BaseName + "_" + ($_ | Select-Object -ExpandProperty LastWriteTime).ToString("MM-dd-yyyy") + $_.Extension)) -force -ea SilentlyContinue
        }
        else { # comletly new file
            Copy-Item $($source + $_.name) -Destination $($destination + $_.name) -force -ea SilentlyContinue
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
    Compare-Object $srcc $trgc -Property FullName,Name,PSIsContainer | Where-Object {$_.SideIndicator -eq "<=" -and $_.PSIsContainer -eq $true} |ForEach-Object {
          if(Test-Path $($destination + $_.name)){ #existing folder
                #Write-Host $($_.Fullname+"\") +"  --  "+$($destination + $_.Name+"\") 
             Copy-Files $($_.Fullname+"\") $($destination + $_.Name+"\") 
           }
        }
    }
    else 
    {
        foreach($f in $srcc){
            #$f  | get-member
            if($f.PSIsContainer){ #if it is folder
               if(-Not (Test-Path $($destination + $f.name))){ #not exist folder
                    Copy-Item $($source + $f.name) $($destination) -recurse -force -ea SilentlyContinue
               } 
            } 
            else {
                
                Copy-Item $($source + $f.name) $($destination + $f.name) -recurse -force -ea SilentlyContinue
            }
                    
        }
       
    
    
    }
}



Copy-Files $src $trg
#Convert-DateString 11/25/2014 5:50:52 PM
#Convert-DateString "11/25/2014 5:50:52 PM" 
#11/25/2014 5:50:52 PM
#"19/09/2014 22:41:27 PM" 