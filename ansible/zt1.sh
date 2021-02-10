hosts=`cat hosts.txt`
for host in $hosts; do
  ssh $host "(curl -s https://install.zerotier.com | sudo bash) && sudo /sbin/zerotier-cli join 0cccb752f726ce73"
done