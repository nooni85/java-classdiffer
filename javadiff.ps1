param (
    [Parameter()]
    [string]$target,

    [Parameter()]
    [string]$src
)

Write-Host "Diff project (${target}:${src})"

function writeDiff {
    param(
        $path,
        $targetName
    )

    if (Test-Path -Path $targetName -PathType Leaf) {
        Remove-Item $targetName
    }

    $cont = ""

    Get-ChildItem $path -Recurse | 
    Foreach-Object {
        if (Test-Path -Path $_.FullName -PathType Leaf) {
            # $content = Get-Content $_.FullName
            Write-Host "Working file $_"
            $ext = [System.IO.Path]::GetExtension($_.FullName)
            if ($ext -eq ".class") {
                $md5deep = java -jar .\bin\jd-cli.jar --logLevel off $_.FullName | .\bin\md5deep64.exe
                $cont += $md5deep + "  " + $_.FullName
                # $cont += (($javap -match "SHA-256 checksum") -replace "SHA-256 checksum").Trim() + "  " + $_.FullName
                $cont += "`r`n"
            }
            else {
                $cont += md5deep64 $_.FullName
                $cont += "`r`n"
            }
        }
    }
    $result = $cont.replace($path, '')
    Add-Content $targetName $result
}

writeDiff -path $target -targetName 'targetdiff.txt'
writeDiff -path $src -targetName 'srcdiff.txt'
