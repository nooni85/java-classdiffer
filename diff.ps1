# md5deep64 --help
$DIFF1="C:\Users\nooni\Project\api"

function writeDiff {
    param(
        $path,
        $targetName
    )

    if (Test-Path -Path $targetName -PathType Leaf) {
        Remove-Item $targetName
    }

    $cont=""

    Get-ChildItem $path -Recurse | 
        Foreach-Object {
            if (Test-Path -Path $_.FullName -PathType Leaf) {
                # $content = Get-Content $_.FullName
                $ext =[System.IO.Path]::GetExtension($_.FullName)
                if($ext -eq ".class") {
                    $javap = javap -sysinfo $_.FullName
                    $cont += (($javap -match "SHA-256 checksum") -replace "SHA-256 checksum").Trim() + "  " + $_.FullName
                    $cont += "`r`n"
                } else {
                    $cont += md5deep64 $_.FullName
                    $cont += "`r`n"
                }
            }
        }
    $result = $cont.replace($path, '')
    Add-Content $targetName $result
}

writeDiff -path $DIFF1 -targetName 'diff2.txt'