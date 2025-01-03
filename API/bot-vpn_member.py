#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import asyncio, aiohttp, re, tempfile
import nest_asyncio
from telegram.constants import ParseMode
from telegram import Update, InlineKeyboardButton, InlineKeyboardMarkup
from telegram.ext import Application, CommandHandler, CallbackQueryHandler, ContextTypes, MessageHandler, filters
import os, subprocess, sys

def check_ulimit():
    result = subprocess.run('ulimit -c', capture_output=True, text=True, shell=True, executable='/bin/bash')
    if result.returncode == 0:
        limit_c = result.stdout.strip()
        if limit_c != '0':
            print("Im Watching You...")
            print("- @kuotavpn")
            sys.exit()

check_ulimit()

nest_asyncio.apply()

user_data = {}

def is_valid_user(user_id: int) -> bool:
    try:
        with open('/etc/william/valid_id_member.txt', 'r') as file:
            valid_ids = file.read().splitlines()
        
        # Check if the user_id exists in any line before the '>'
        for line in valid_ids:
            valid_user_id = line.split('>')[0].strip()  # Get the user ID part before '>'
            if str(user_id) == valid_user_id:
                return True
        return False
    except FileNotFoundError:
        return False

def read_bot_token() -> str:
    try:
        with open('/etc/william/valid_bot_member.txt', 'r') as file:
            return file.read().strip()
    except FileNotFoundError:
        raise RuntimeError("Bot token file not found.")

async def run_curl_command(url: str, headers: dict, data: dict = None, method: str = 'GET') -> str:
    async with aiohttp.ClientSession() as session:
        async with session.request(method, url, headers=headers, json=data) as response:
            result = await response.text()

    import json
    try:
        result_json = json.loads(result)
        return result_json.get('stdout', '')
    except json.JSONDecodeError:
        return result

async def start(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    nickname = update.message.from_user.first_name
    if not is_valid_user(user_id):
        await update.message.reply_text(f"<b>Hey {nickname} ({user_id}) !!\nYou are not authorized to use this bot.\n\nDev -> @kuotavpn\nJoin -> @script_vpn</b>", parse_mode=ParseMode.HTML)
        return
    user_data[user_id] = {'previous_menu': 'start_menu'}
    
    try:
        with open('/etc/william/myvps_member.txt', 'r') as f:
            servers = f.readlines()
    except FileNotFoundError:
        await update.message.reply_text("Server list file not found.")
        return
    
    # Prepare keyboard with only custom names (before '>')
    keyboard = [
        [InlineKeyboardButton(server.split('>')[0].strip(), callback_data=f'select_{server.split(">")[0].strip()}')]
        for server in servers
    ]
    reply_markup = InlineKeyboardMarkup(keyboard)
    
    await update.message.reply_text(
        '<b>WELCOME ~</b>\n'
        '  ╱|、  BOT\n'
        '(˚ˎ 。7  MANAGEMENT\n'
        '|、˜〵  SERVER VPN\n'
        'じしˍ,)ノ\n\n'
        '<b>Please select a server:</b>',
        reply_markup=reply_markup,
        parse_mode=ParseMode.HTML
    )

async def select_server(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.callback_query.from_user.id
    server_name = update.callback_query.data.split("_")[1]  # Extract custom_nama
    
    # Cari subdomain berdasarkan custom_nama
    try:
        with open('/etc/william/myvps_member.txt', 'r') as f:
            servers = f.readlines()
    except FileNotFoundError:
        await update.callback_query.message.edit_text("Server list file not found.")
        return

    sub_domain = None
    for server in servers:
        custom_name, domain = server.split('>')
        if custom_name.strip() == server_name:
            sub_domain = domain.strip()
            break
    
    if not sub_domain:
        await update.callback_query.message.edit_text("Subdomain not found for the selected server.")
        return
    user_data[user_id] = {
        'server': sub_domain
    }
    keyboard = [
        [InlineKeyboardButton("Create SSH", callback_data='create_ssh')],
        [InlineKeyboardButton("Renew SSH", callback_data='renew_ssh')],
        [InlineKeyboardButton("Delete SSH", callback_data='delete_ssh')],
    ]
    reply_markup = InlineKeyboardMarkup(keyboard)
    
    await update.callback_query.message.edit_text(
        f"<b>Server {server_name} ({sub_domain}) selected!</b>\n"
        "Please choose an action below:",
        reply_markup=reply_markup,
        parse_mode=ParseMode.HTML
    )

async def handle_ssh_action(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.callback_query.from_user.id
    action = update.callback_query.data

    user_data[user_id]['command'] = action
    await update.callback_query.answer()  # Acknowledge the button press

    # Ask for user input step by step based on the action
    if action == 'create_ssh':
        await update.callback_query.message.edit_text("Please enter the username for SSH:")
    elif action == 'renew_ssh':
        await update.callback_query.message.edit_text("Please enter the username to renew SSH:")
    elif action == 'delete_ssh':
        await update.callback_query.message.edit_text("Please enter the username to delete SSH:")

# Handle user input for SSH commands
async def handle_user_input(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})
    
    if 'command' not in user_info:
        return  # Exit if no command is set
    
    command = user_info['command']
    server = user_info.get('server')
    
    if not server:
        await update.message.reply_text("No server selected. Please select a server first.")
        return
    
    # Handle each SSH action
    if command == 'create_ssh':
        if 'username' not in user_info:
            user_data[user_id]['username'] = update.message.text
            await update.message.reply_text("Please enter the password for SSH:")
        elif 'password' not in user_info:
            user_data[user_id]['password'] = update.message.text
            await update.message.reply_text("Please enter the expiration time\n(e.g., 30, 60, 90):")
        elif 'exp' not in user_info:
            user_data[user_id]['exp'] = update.message.text
            # Now call the API to create SSH
            await handle_create_ssh(update, context)

    elif command == 'renew_ssh':
        if 'username' not in user_info:
            user_data[user_id]['username'] = update.message.text
            await update.message.reply_text("Please enter the expiration time (e.g., 30, 60, 90):")
        elif 'exp' not in user_info:
            user_data[user_id]['exp'] = update.message.text
            # Now call the API to renew SSH
            await handle_renew_ssh(update, context)

    elif command == 'delete_ssh':
        if 'username' not in user_info:
            user_data[user_id]['username'] = update.message.text
            # Now call the API to delete SSH
            await handle_delete_ssh(update, context)

# Function to create SSH
async def handle_create_ssh(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})

    username = user_info.get('username')
    password = user_info.get('password')
    exp = user_info.get('exp')

    # Perform the curl API call for creating SSH
    server = user_info.get('server')
    try:
        with open('/etc/william/apiX', 'r') as f:
            api_key = f.read().strip()
    except FileNotFoundError:
        await update.message.reply_text("API key file not found.")
        return

    url = f'http://{server}:5069/add-ssh'
    headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
    data = {
        "user": username,
        "pass": password,
        "exp": exp,
        "limit_ip": limit_ip
    }
    response = await run_curl_command(url, headers, data, 'POST')
    await update.message.reply_text(response)

    # After the operation, clean up the user data
    del user_data[user_id]['command']
    del user_data[user_id]['username']
    del user_data[user_id]['password']
    del user_data[user_id]['exp']
    del user_data[user_id]['limit_ip']

# Function to renew SSH
async def handle_renew_ssh(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})

    username = user_info.get('username')
    exp = user_info.get('exp')

    # Perform the curl API call for renewing SSH
    server = user_info.get('server')
    try:
        with open('/etc/william/apiX', 'r') as f:
            api_key = f.read().strip()
    except FileNotFoundError:
        await update.message.reply_text("API key file not found.")
        return

    url = f'http://{server}:5069/renew-ssh'
    headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
    data = {
        "user": username,
        "exp": exp
    }
    response = await run_curl_command(url, headers, data, 'POST')
    await update.message.reply_text(response)

    # After the operation, clean up the user data
    del user_data[user_id]['command']
    del user_data[user_id]['username']
    del user_data[user_id]['exp']

# Function to delete SSH
async def handle_delete_ssh(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})

    username = user_info.get('username')

    # Perform the curl API call for deleting SSH
    server = user_info.get('server')
    try:
        with open('/etc/william/apiX', 'r') as f:
            api_key = f.read().strip()
    except FileNotFoundError:
        await update.message.reply_text("API key file not found.")
        return

    url = f'http://{server}:5069/del-ssh'
    headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
    data = {"user": username}
    response = await run_curl_command(url, headers, data, 'DELETE')
    await update.message.reply_text(response)

    # After the operation, clean up the user data
    del user_data[user_id]['command']
    del user_data[user_id]['username']

# Main function to run the bot
async def main() -> None:
    bot_token = read_bot_token()  # Use the correct token file
    application = Application.builder().token(bot_token).build()

    # Handlers
    application.add_handler(CommandHandler("start", start))
    application.add_handler(CallbackQueryHandler(select_server, pattern=r"^select_"))
    application.add_handler(CallbackQueryHandler(handle_ssh_action, pattern=r"^(create_ssh|renew_ssh|delete_ssh)$"))
    application.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, handle_user_input))

    # Run the bot
    await application.run_polling()

# Run the bot
if __name__ == "__main__":
    asyncio.run(main())