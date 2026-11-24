#!/bin/bash
# Double-click this file to preview the Summa web locally.
# No build, no deploy, no Netlify credits — it just serves the web/ folder on your Mac,
# exactly the way Netlify serves it in production.

cd "$(dirname "$0")/web" || { echo "Could not find the web/ folder next to this script."; exit 1; }
PORT=8000
IP=$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null)

echo ""
echo "  Summa web — local preview"
echo "  --------------------------------------------------"
echo "  On this Mac:    http://localhost:$PORT/            (daily)"
echo "                  http://localhost:$PORT/intro.html  (intro funnel)"
if [ -n "$IP" ]; then
  echo "  On your phone:  http://$IP:$PORT/                  (same Wi-Fi)"
fi
echo "  --------------------------------------------------"
echo "  Edit a file, then just refresh the page to see changes."
echo "  Stop the server: press Ctrl+C, or close this window."
echo ""

python3 -m http.server "$PORT"
