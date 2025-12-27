#!/bin/bash
# Auto GUI + noVNC + Cloudflare Tunnel - For systems no public IP

echo "=== UPDATE HỆ THỐNG ==="
sudo apt update && sudo apt upgrade -y

echo "=== CÀI GUI XFCE NHẸ ==="
sudo apt install xfce4 xfce4-goodies -y

echo "=== CÀI VNC + noVNC + WEBVNC ==="
sudo apt install tightvncserver websockify novnc -y
vncserver || true
vncserver -kill :1

echo "=== CẤU HÌNH XFCE CHO VNC ==="
cat > ~/.vnc/xstartup <<EOF
#!/bin/bash
xrdb $HOME/.Xresources
startxfce4 &
EOF
chmod +x ~/.vnc/xstartup

echo "=== CHẠY VNC CỔNG 5901 & WEB NO-VNC CỔNG 6080 ==="
vncserver :1
websockify --web=/usr/share/novnc/ 6080 localhost:5901 &

echo "=== CÀI CLOUDFLARED (TẠO LINK REMOTE) ==="
curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o cloudflared
chmod +x cloudflared
sudo mv cloudflared /usr/local/bin/

echo "==========================================="
echo "🚀 ĐANG MỞ TUNNEL REMOTE BẰNG CLOUDFLARE..."
echo "==========================================="

cloudflared tunnel --url http://localhost:6080
