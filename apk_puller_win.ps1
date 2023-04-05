Write-Output "apk puller for win"

function Get-All-Package {
    $packages = (adb shell pm list packages | Out-String).Replace("`r","") -split "`n"
    Write-Output "totally found $($packages.Length) packages"
    foreach ($package in $packages){
        if ($package.Length -lt "package:".Length){
            continue
        }

        $name = $($package -split ":")[1]

        Get-Single_package($name)

    }
}

function Get-Single_package([String]$name) {

    $path = ((adb shell pm path $name | Out-String).Replace("`r","") -split {$_ -eq ":" -or $_ -eq "`n"})
    if ($path.Length -le 0){
        Write-Output "$name not found in device"
        return
    }
    adb pull $path[1] $($name+'.apk')
}


$size = $args.Length

if ($size -lt 1){
    Write-Output "params not input, check usage:`n"
    Write-Output ".\apk_puller_win.ps1 <package_name> : to pull a single package`n"
    Write-Output ".\apk_puller_win.ps1 all : to pull all package in the connected device`n"
    Write-Output "exiting..."
    return
}

$target = $args[0]

if ($target -eq "all"){
    Write-Output "pulling all packages"
    Get-All-Package
}
else {
    Write-Output "pulling $target"
    Get-Single_package($target)
}