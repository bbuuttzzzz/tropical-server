set -e
set -x

ufw disable

# Install Docker
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl

# Create directory and download Docker's GPG key
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the Docker repository to Apt sources
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker and related packages
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start Docker
sudo service docker start

# set up mount folder
mkdir -p /root/mount/data
mkdir -p /root/mount/gmodcache
mkdir -p /root/mount/steamcache
chmod -R 777 /root/mount

# get and clone repo
mkdir -p /root/src/
cd /root/src/

#just in case it failed the last time, delete tropical-server existing folder
rm -rf tropical-server

GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
git clone https://github.com/bbuuttzzzz/tropical-server.git
cd tropical-server
git submodule update --recursive --init
cd /root/

# Copy data folder
cp -p /src/tropical-server/data/* /root/mount/data/