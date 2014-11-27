$src = "C:\t1\"
$trg = "C:\t2\"

function Copy-Files ([string]$source,[string]$destination){
    $srcc = Get-childitem $source
    $trgc = Get-childitem $destination

   if($trgc.count -ne 0 ){
     Compare-Object $srcc $trgc -Property Name, Extension, LastWriteTime,BaseName,PSIsContainer | Where-Object {$_.SideIndicator -eq "<=" } | ForEach-Object {
        Write-Host $_
    }
    }
    else
    {
        
    }

}



Copy-Files $src $trg
