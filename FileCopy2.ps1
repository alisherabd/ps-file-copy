$src = "C:\t1"
$trg = "C:\t2" 

function MoveFileToFolder ([string]$source,[string]$destination){
# get a list of source files
$files = Get-ChildItem -Path $source

# verify if the list of source files is empty
if ($files -ne $null) {
    
    foreach ($file in $files) {
    
    
    $filename = $file.Name
    $filebase = $file.BaseName
    $fileext = $file.Extension
        
# verify if destination file exists and rename
        if (Test-Path $destination$filename) {
            Write-Host $file
            $n = 0
            $filenameNU = $filename
            
            while ((Test-Path $destination$filenameNU) -eq $true)
            {
            $filenameNU = $filebase + "-" + ++$n + $fileext
            }
            #Write-Host $destination$filename
        #Rename-Item $destination$filename $filenameNU
        }
        #Write-Host $source

    #Copy-Item $source $destination -ea silentlycontinue
    }
}
}

function Get-Directories ($path)
{
    $PathLength = $path.length
    Get-ChildItem $path -Recurse | % {
        Add-Member -InputObject $_ -MemberType NoteProperty -Name RelativePath -Value $_.FullName.substring($PathLength+1)
        $_
    }
}

Compare-Object (Get-Directories $src) (Get-Directories $trg) -Property RelativePath, Name, Length |
Sort RelativePath, Name, Length -desc | % {
    if ($file -ne $_.RelativePath) { $_ } } | 
    Where-Object {$_.SideIndicator -eq "=>"} | 
    ForEach-Object {
        $file = $_.RelativePath
        Write-Host $file
        #Echo F | xcopy "$Folder2\$file" "$Folder3\$file" /S
    }

MoveFileToFolder $src $trg

 $srcc = Get-childitem $source
    $trgc = Get-childitem $destination

    Compare-Object $srcc $trgc -Property Name, Length | Where-Object {$_.SideIndicator -eq "<="} | ForEach-Object {
        
        Write-Host $($_.name)
        #Copy-Item "C:\Folder1\$($_.name)" -Destination "C:\Folder3" -Force