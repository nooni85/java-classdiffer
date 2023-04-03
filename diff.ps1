# md5deep64 --help
$DIFF1="C:\Users\nooni\Project\api"

function writeDiff {
    param(
        $path,
        $targetName
    )

    Get-ChildItem $path -Recurse | 
        Foreach-Object {
            if (Test-Path -Path $_.FullName -PathType Leaf) {
                # $content = Get-Content $_.FullName
                $result = md5deep64 $_.FullName
                Add-Content $targetName $result
            }
        }
}

writeDiff -path $DIFF1 -targetName 'diff2.txt'