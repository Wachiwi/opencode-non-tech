# WSL-Einrichtung für den OpenCode-Container (Skeleton)
# Einmalig in einer WSL-Distribution (z. B. Ubuntu-24.04) ausführen:
#   sudo bash wsl-setup.sh

set -e

echo "== 1. systemd in WSL aktivieren =="
# In /etc/wsl.conf eintragen (wird von wsl-setup.sh geprüft):
if ! grep -q "^\[boot\]" /etc/wsl.conf 2>/dev/null; then
  cat > /etc/wsl.conf <<'EOF'
[boot]
systemd=true
EOF
  echo "systemd aktiviert. WSL muss neu gestartet werden: wsl --shutdown (in Windows), dann weiter mit Schritt 2."
  exit 0
fi

echo "== 2. Docker CE nativ in WSL installieren =="
# Variante A: nativer Docker in WSL (empfohlen – ohne Docker Desktop, keine Extra-Lizenz)
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo systemctl enable --now docker

echo "== 3. Projektordner in den Container-Deploy-Kontext legen =="
# Empfehlung: Standardprojekt in das WSL-Dateisystem (ext4) klonen/kopieren,
# z. B. ~/Standardprojekt. Bind-Mounts aus dem WSL-Dateisystem sind deutlich
# schneller als /mnt/c/... (Windows-Pfade).
# Windows kann trotzdem via \\wsl$\Ubuntu\home\<user>\Standardprojekt darauf zugreifen.

echo "== 4. Systemd-Dienst installieren =="
sudo cp opencode.service /etc/systemd/system/opencode.service
sudo systemctl daemon-reload
sudo systemctl enable opencode.service

echo "== 5. Erster Start =="
cd ~/Standardprojekt/docker
sudo systemctl start opencode.service
sleep 5
curl -sf -u opencode:$(grep OPENCODE_PASSWORD .env | cut -d= -f2) http://127.0.0.1:4096/api/info \
  && echo "Server ist erreichbar." || echo "Noch nicht erreichbar – Image baut evtl. noch. Einige Minuten warten."
