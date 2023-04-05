param (
  [Parameter()]
  [string]$target,

  [Parameter()]
  [string]$src
)

New-Item -ItemType Directory target
New-Item -ItemType Directory src
java -jar .\bin\java-decompiler.jar -dgs=1 $target ".\target"
java -jar .\bin\java-decompiler.jar -dgs=1 $src ".\src"