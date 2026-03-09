# Определяем URL скрипта
$source = $MyInvocation.MyCommand.Definition

$hostName = ([uri]$source).Host

# Конфигурация папок
$config = @{
    "dog.poop.su" = @{ folder="dogs"; max=3 }
    "cat.poop.su" = @{ folder="cats"; max=2 }
}

if(!$config.ContainsKey($hostName)){
    folder="default"; max=3
}

$conf = $config[$hostName]

# случайная картинка
$n = Get-Random -Minimum 1 -Maximum ($conf.max + 1)

$imgUrl = "https://$hostName/$($conf.folder)/$n.jpg"
$imgPath = "$env:TEMP\$($conf.folder)_$n.jpg"

Invoke-WebRequest $imgUrl -OutFile $imgPath

# установка обоев
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class W{
[DllImport("user32.dll")] public static extern bool SystemParametersInfo(int a,int b,string c,int d);
}
"@

Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -Value 10
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -Value 0
[W]::SystemParametersInfo(20,0,$imgPath,3)
