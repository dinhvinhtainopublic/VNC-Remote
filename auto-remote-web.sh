#!/bin/bash
# Auto GUI + noVNC + Cloudflare Tunnel (Only show remote link)

# Cài đặt + cấu hình im lặng
sudo apt update -y >/dev/null 2>&1
sudo apt install xfce4 xfce4-goodies tightvncserver websockify novnc -y >/dev/null 2>&1

# Setup VNC
vncserver >/dev/null 2>&1 || true
vncserver -kill :1 >/dev/null 2>&1
cat > ~/.vnc/xstartup <<EOF
#!/bin/bash
xrdb $HOME/.Xresources
startxfce4 &
EOF
chmod +x ~/.vnc/xstartup

# Chạy dịch vụ
vncserver :1 >/dev/null 2>&1
websockify --web=/usr/share/novnc/ 6080 localhost:5901 >/dev/null 2>&1 &

# Cài cloudflared không log
curl -sL https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o cloudflared
chmod +x cloudflared
sudo mv cloudflared /usr/local/bin/ >/dev/null 2>&1

# 🚀 Tạo tunnel và CHỈ LẤY LINK
url=$(cloudflared tunnel --url http://localhost:6080 2>&1 | grep -o "https://.*trycloudflare.com")

clear
echo "==========================================="
echo " 🌍 Link Remote Cloudflare của bạn:"
echo
echo " 👉 $url"
echo
echo "==========================================="
