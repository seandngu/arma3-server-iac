# Remove conflicting Docker packages
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg --assume-yes; done

# Add Docker's official GPG key:
sudo apt-get update --assume-yes
sudo apt-get install ca-certificates curl --assume-yes
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update --assume-yes

# Create TeamSpeak server
sudo docker compose -file="server/teamspeak/compose.yml" up -d

# Create arma-web-server
sudo docker compose --file="server/arma-server-manager/compose.yml" up -d

# Return password from TeamSpeak logs
sudo docker logs $(sudo docker container ls --all --filter=ancestor="teamspeak" --format "{{.ID}}")