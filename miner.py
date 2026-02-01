import hashlib,json,os,platform,socket,threading,time,urllib.request,base64,uuid
GITHUB_USER="max1734601-cpu"
GITHUB_REPO="mining-dashboard"
GITHUB_TOKEN="YOUR_TOKEN_HERE"
WALLET="4465bM7hTwiMHE3ka1foxQMou8YsrMtR4RYFmyJF23KSSp6fHtDcE8LUcUrRbKTQEJPYkKgUqfDyG6TvmcwRJ8UUHVxpc9o"
POOL="gulf.moneroocean.stream"
PORT=10032
class Miner:
 def __init__(self):
  self.id=f"Miner-{platform.node()[:12]}-{str(uuid.uuid4())[:4]}"
  self.hr=0
  self.hashes=0
  self.mining=True
  self.sock=None
  self.job=None
 def ip(self):
  try:
   s=socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
   s.connect(("8.8.8.8",80))
   r=s.getsockname()[0]
   s.close()
   return r
  except:return "?"
 def connect(self):
  try:
   self.sock=socket.socket()
   self.sock.settimeout(30)
   self.sock.connect((POOL,PORT))
   self.send({"id":1,"jsonrpc":"2.0","method":"login","params":{"login":WALLET,"pass":"x","rigid":self.id,"agent":"MH/1"}})
   r=self.recv()
   if r and "result" in r:
    self.job=r["result"].get("job")
    print("[+] Connected to pool")
    return True
   return False
  except Exception as e:
   print(f"[-] Pool error: {e}")
   return False
 def send(self,d):
  try:self.sock.sendall((json.dumps(d)+"\n").encode())
  except:pass
 def recv(self):
  try:
   d=b""
   while b"\n" not in d:d+=self.sock.recv(4096)
   return json.loads(d.decode().strip())
  except:return None
 def mine(self):
  if not self.job:return
  n=0
  t=time.time()
  h=0
  while self.mining:
   n+=1
   h+=1
   data=self.job.get("blob","")+format(n,'08x')
   hsh=hashlib.sha256(data.encode()).hexdigest()
   if hsh.startswith("0000"):
    self.send({"id":2,"jsonrpc":"2.0","method":"submit","params":{"id":self.job.get("job_id"),"nonce":format(n,'08x'),"result":hsh}})
   if time.time()-t>=1:
    self.hr=h
    self.hashes+=h
    h=0
    t=time.time()
   if n%1000==0:time.sleep(0.001)
 def update(self):
  while self.mining:
   try:
    url=f"https://api.github.com/repos/{GITHUB_USER}/{GITHUB_REPO}/contents/miners.json"
    miners={}
    sha=None
    try:
     req=urllib.request.Request(url)
     req.add_header("Authorization",f"token {GITHUB_TOKEN}")
     req.add_header("User-Agent","MH")
     with urllib.request.urlopen(req) as res:
      d=json.loads(res.read())
      sha=d.get("sha")
      miners=json.loads(base64.b64decode(d["content"]).decode())
    except:pass
    miners[self.id]={"name":self.id,"ip":self.ip(),"hashrate":self.hr,"mining":self.mining,"lastSeen":int(time.time()*1000)}
    payload={"message":"update","content":base64.b64encode(json.dumps(miners).encode()).decode()}
    if sha:payload["sha"]=sha
    req=urllib.request.Request(url,json.dumps(payload).encode(),method="PUT")
    req.add_header("Authorization",f"token {GITHUB_TOKEN}")
    req.add_header("Content-Type","application/json")
    req.add_header("User-Agent","MH")
    urllib.request.urlopen(req)
    print(f"[*] {self.hr} H/s")
   except Exception as e:
    print(f"[-] Update err: {e}")
   time.sleep(30)
 def start(self):
  print(f"[*] MiningHub - {self.id}")
  if GITHUB_TOKEN=="YOUR_TOKEN_HERE":
   print("[-] Set GITHUB_TOKEN in miner.py first!")
   return
  if not self.connect():
   time.sleep(30)
   return self.start()
  threading.Thread(target=self.update,daemon=True).start()
  print("[+] Mining...")
  try:self.mine()
  except KeyboardInterrupt:pass
  self.mining=False
  print("[*] Stopped")
if __name__=="__main__":
 Miner().start()
