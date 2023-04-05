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

    # Create a list
    $list = [System.Collections.ArrayList]::Synchronized([System.Collections.ArrayList]::new())

    Get-ChildItem $path -Recurse | Foreach-Object -ThrottleLimit 5 -Parallel {
        $list = $using:list
        if (Test-Path -Path $_.FullName -PathType Leaf) {
            $relativeFilePath = $_.FullName.Replace($using:path, '')
            Write-Host "[$using:targetName] $relativeFilePath"
            
            $ext = [System.IO.Path]::GetExtension($_.FullName)
            if ($ext -ne ".class") {
                $hash = .\bin\md5deep64 $_.FullName
                $list.Add($relativeFilePath + "  " + $hash )
            }
            else {
                $hash = java -jar .\bin\jd-cli.jar --logLevel off $_.FullName
                $hash = $hash | .\bin\md5deep64
                $list.Add($relativeFilePath + "  " + $hash )
            }
        }
    }
    $list.Sort()

    [System.IO.File]::WriteAllLines($targetName, $list)
}

writeDiff -path $target -targetName $PWD"/targetdiff.txt"
writeDiff -path $src -targetName $PWD"/srcdiff.txt"
