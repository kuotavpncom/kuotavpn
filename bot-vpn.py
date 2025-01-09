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
        with open('/etc/william/valid_id.txt', 'r') as file:
            valid_ids = file.read().splitlines()
        return str(user_id) in valid_ids
    except FileNotFoundError:
        return False

def read_bot_token() -> str:
    try:
        with open('/etc/william/valid_bot.txt', 'r') as file:
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
        with open('/etc/william/myvps.txt', 'r') as f:
            servers = f.readlines()
    except FileNotFoundError:
        await update.message.reply_text("Server list file not found.")
        return
    keyboard = [[InlineKeyboardButton(server.strip(), callback_data=f'select_{server.strip()}')] for server in servers]
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


async def back_to_selector(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.callback_query.from_user.id
    nickname = update.callback_query.from_user.first_name
    if not is_valid_user(user_id):
        await update.callback_query.message.reply_text(f"<b>Hey {nickname} ({user_id}) !!\nYou are not authorized to use this bot.\n\nDev -> @kuotavpn\nJoin -> @script_vpn</b>", parse_mode=ParseMode.HTML)
        return
    if 'server' in user_data.get(user_id, {}):
        del user_data[user_id]['server']
    try:
        with open('/etc/william/myvps.txt', 'r') as f:
            servers = f.readlines()
    except FileNotFoundError:
        await update.callback_query.message.reply_text("Server list file not found.")
        return
    keyboard = [[InlineKeyboardButton(server.strip(), callback_data=f'select_{server.strip()}')] for server in servers]
    reply_markup = InlineKeyboardMarkup(keyboard)
    await update.callback_query.message.edit_text(
    '<b>WELCOME ~</b>\n'
    '  ╱|、  BOT\n'
    '(˚ˎ 。7  MANAGEMENT\n'
    '|、˜〵  SERVER VPN\n'
    'じしˍ,)ノ\n\n'
    '<b>Please select a server:</b>',
    reply_markup=reply_markup,
    parse_mode=ParseMode.HTML
)

async def main_menu(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.callback_query.from_user.id
    server = user_data.get(user_id, {}).get('server')
    if not server:
        await update.callback_query.message.reply_text("No server selected.")
        return
    keyboard = [
        [InlineKeyboardButton("Manage SSH", callback_data='manage_ssh')],
        [InlineKeyboardButton("Manage Xray", callback_data='manage_xray')],
        [InlineKeyboardButton("Manage L2TP", callback_data='manage_l2tp')],
        [InlineKeyboardButton("Back To Selector Server", callback_data='back_to_selector')]
    ]
    reply_markup = InlineKeyboardMarkup(keyboard)
    await update.callback_query.message.edit_text(f'<b>Main Menu\nServer Selected: {server}\n\nDev -> @kuotavpn\nJoin -> @script_vpn</b>', reply_markup=reply_markup, parse_mode=ParseMode.HTML)

async def manage_ssh(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.callback_query.from_user.id
    server = user_data.get(user_id, {}).get('server')
    keyboard = [
        [
            InlineKeyboardButton("Create SSH", callback_data='create_ssh'),
            InlineKeyboardButton("Trial SSH", callback_data='trial_ssh'),
        ],
        [
            InlineKeyboardButton("Renew SSH", callback_data='renew_ssh'),
            InlineKeyboardButton("Delete SSH", callback_data='delete_ssh'),
        ],
        [InlineKeyboardButton("Check SSH Login", callback_data='check_ssh')],
        [InlineKeyboardButton("Lock SSH USER", callback_data='lock_ssh')],
        [InlineKeyboardButton("Unlock SSH USER", callback_data='unlock_ssh')],
        [InlineKeyboardButton("Back to Main Menu", callback_data='back_to_main_menu')]
    ]
    reply_markup = InlineKeyboardMarkup(keyboard)
    await update.callback_query.message.edit_text(f'<b>Manage SSH\nServer Selected: {server}</b>', reply_markup=reply_markup, parse_mode=ParseMode.HTML)

async def handle_create_ssh(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})
    if user_info.get('command') == 'create_ssh':
        message = await update.message.reply_text("Process create....")
        try:
            username, password, exp, limit_ip = update.message.text.split()
        except ValueError:
            await message.edit_text("Invalid input format. Use: username password exp limit_ip")
            return
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
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
        await message.edit_text(response)
        del user_data[user_id]['command']

async def handle_trial_ssh(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})
    if user_info.get('command') == 'trial_ssh':
        message = await update.message.reply_text("Process trial....")
        try:
            exp, limit_ip = update.message.text.split()
        except ValueError:
            await message.edit_text("Invalid input format. Use: exp limit_ip")
            return
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
            return
        url = f'http://{server}:5069/trial-ssh'
        headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
        data = {
            "exp": exp,
            "limit_ip": limit_ip
        }
        response = await run_curl_command(url, headers, data, 'POST')
        await message.edit_text(response)
        del user_data[user_id]['command']

async def handle_renew_ssh(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})
    if user_info.get('command') == 'renew_ssh':
        message = await update.message.reply_text("Process renew....")
        try:
            username, exp = update.message.text.split()
        except ValueError:
            await message.edit_text("Invalid input format. Use: username exp")
            return
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
            return
        url = f'http://{server}:5069/renew-ssh'
        headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
        data = {
            "user": username,
            "exp": exp
        }
        response = await run_curl_command(url, headers, data, 'POST')
        await message.edit_text(response)
        del user_data[user_id]['command']

async def handle_delete_ssh(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})
    if user_info.get('command') == 'delete_ssh':
        message = await update.message.reply_text("Process delete....")
        username = update.message.text
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
            return
        url = f'http://{server}:5069/del-ssh'
        headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
        data = {"user": username}
        response = await run_curl_command(url, headers, data, 'DELETE')
        await message.edit_text(response)
        del user_data[user_id]['command']

async def cek_ssh(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.callback_query.from_user.id
    user_info = user_data.get(user_id, {})
    server = user_info.get('server')
    if not server:
        await update.callback_query.message.reply_text("No server selected.")
        return
    try:
        with open('/etc/william/apiX', 'r') as f:
            api_key = f.read().strip()
    except FileNotFoundError:
        await update.callback_query.message.reply_text("API key file not found.")
        return
    url = f'http://{server}:5069/cek-ssh'
    headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
    response = await run_curl_command(url, headers, method='GET')
    await update.callback_query.message.reply_text(response)

async def handle_lock_ssh(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})
    if user_info.get('command') == 'lock_ssh':
        message = await update.message.reply_text("Process lock....")
        username = update.message.text
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
            return
        url = f'http://{server}:5069/lock-ssh'
        headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
        data = {"user": username}
        response = await run_curl_command(url, headers, data, 'POST')
        await message.edit_text(response)
        del user_data[user_id]['command']

async def handle_unlock_ssh(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})
    if user_info.get('command') == 'unlock_ssh':
        message = await update.message.reply_text("Process unlock....")
        username = update.message.text
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
            return
        url = f'http://{server}:5069/unlock-ssh'
        headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
        data = {"user": username}
        response = await run_curl_command(url, headers, data, 'POST')
        await message.edit_text(response)
        del user_data[user_id]['command']

async def manage_l2tp(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.callback_query.from_user.id
    server = user_data.get(user_id, {}).get('server')
    keyboard = [
        [InlineKeyboardButton("Create L2TP", callback_data='create_l2tp')],
        [InlineKeyboardButton("Delete L2TP", callback_data='delete_l2tp')],
        [InlineKeyboardButton("Renew L2TP", callback_data='renew_l2tp')],
        [InlineKeyboardButton("Back to Main Menu", callback_data='back_to_main_menu')]
    ]
    reply_markup = InlineKeyboardMarkup(keyboard)
    await update.callback_query.message.edit_text(f'<b>Manage L2TP\nServer Selected: {server}</b>', reply_markup=reply_markup, parse_mode=ParseMode.HTML)

async def handle_create_l2tp(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})
    if user_info.get('command') == 'create_l2tp':
        message = await update.message.reply_text("Process create....")
        try:
            username, password, exp = update.message.text.split()
        except ValueError:
            await message.edit_text("Invalid input format. Use: username password exp limit_ip")
            return
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
            return
        url = f'http://{server}:5069/add-l2tp'
        headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
        data = {
            "user": username,
            "pass": password,
            "exp": exp
        }
        response = await run_curl_command(url, headers, data, 'POST')
        await message.edit_text(response)
        del user_data[user_id]['command']

async def handle_renew_l2tp(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})
    if user_info.get('command') == 'renew_l2tp':
        message = await update.message.reply_text("Process renew....")
        try:
            username, exp = update.message.text.split()
        except ValueError:
            await message.edit_text("Invalid input format. Use: username exp")
            return
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
            return
        url = f'http://{server}:5069/renew-l2tp'
        headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
        data = {
            "user": username,
            "exp": exp
        }
        response = await run_curl_command(url, headers, data, 'POST')
        await message.edit_text(response)
        del user_data[user_id]['command']

async def handle_delete_l2tp(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})
    if user_info.get('command') == 'delete_l2tp':
        message = await update.message.reply_text("Process delete....")
        username = update.message.text
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
            return
        url = f'http://{server}:5069/del-l2tp'
        headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
        data = {"user": username}
        response = await run_curl_command(url, headers, data, 'DELETE')
        await message.edit_text(response)
        del user_data[user_id]['command']

async def manage_xray(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.callback_query.from_user.id
    server = user_data.get(user_id, {}).get('server')
    keyboard = [
        [
            InlineKeyboardButton("Xray Vmess WS", callback_data='menu_xray_vmessws'),
            InlineKeyboardButton("Xray Vmess GRPC", callback_data='menu_xray_vmessgrpc'),
        ],
        [
            InlineKeyboardButton("Xray Vless WS", callback_data='menu_xray_vlessws'),
            InlineKeyboardButton("Xray Vless GRPC", callback_data='menu_xray_vlessgrpc'),
        ],
        [
            InlineKeyboardButton("Xray Trojan WS", callback_data='menu_xray_trojanws'),
            InlineKeyboardButton("Xray Trojan GRPC", callback_data='menu_xray_trojangrpc'),
        ],
        [InlineKeyboardButton("Xray Cek Login", callback_data='check_xray')],
        [InlineKeyboardButton("Xray Change UUID", callback_data='change_uuid')],
        [InlineKeyboardButton("Xray Lock Account", callback_data='lock_xray')],
        [InlineKeyboardButton("Xray Unlock Account", callback_data='unlock_xray')],
        [InlineKeyboardButton("Back to Main Menu", callback_data='back_to_main_menu')]
    ]
    reply_markup = InlineKeyboardMarkup(keyboard)
    await update.callback_query.message.edit_text(f'Manage XRAY\nServer Selected: {server}', reply_markup=reply_markup)

async def menu_xray_vmessws(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.callback_query.from_user.id
    server = user_data.get(user_id, {}).get('server')
    keyboard = [
        [InlineKeyboardButton("Create Vmess WS", callback_data='create_vmessws')],
        [InlineKeyboardButton("Trial Vmess WS", callback_data='trial_vmessws')],
        [InlineKeyboardButton("Delete Vmess WS", callback_data='del_vmessws')],
        [InlineKeyboardButton("Detail Vmess WS", callback_data='detail_vmessws')],
        [InlineKeyboardButton("Renew Vmess WS", callback_data='renew_vmessws')],
        [InlineKeyboardButton("Back to Xray Menu", callback_data='manage_xray')]
    ]
    reply_markup = InlineKeyboardMarkup(keyboard)
    await update.callback_query.message.edit_text(f'VMESS WS Menu\nServer Selected: {server}', reply_markup=reply_markup)

async def menu_xray_vlessws(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.callback_query.from_user.id
    server = user_data.get(user_id, {}).get('server')
    keyboard = [
        [InlineKeyboardButton("Create Vless WS", callback_data='create_vlessws')],
        [InlineKeyboardButton("Trial Vless WS", callback_data='trial_vlessws')],
        [InlineKeyboardButton("Delete Vless WS", callback_data='del_vlessws')],
        [InlineKeyboardButton("Detail Vless WS", callback_data='detail_vlessws')],
        [InlineKeyboardButton("Renew Vless WS", callback_data='renew_vlessws')],
        [InlineKeyboardButton("Back to Xray Menu", callback_data='manage_xray')]
    ]
    reply_markup = InlineKeyboardMarkup(keyboard)
    await update.callback_query.message.edit_text(f'VLESS WS Menu\nServer Selected: {server}', reply_markup=reply_markup)

async def menu_xray_trojanws(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.callback_query.from_user.id
    server = user_data.get(user_id, {}).get('server')
    keyboard = [
        [InlineKeyboardButton("Create Trojan WS", callback_data='create_trojanws')],
        [InlineKeyboardButton("Trial Trojan WS", callback_data='trial_trojanws')],
        [InlineKeyboardButton("Delete Trojan WS", callback_data='del_trojanws')],
        [InlineKeyboardButton("Detail Trojan WS", callback_data='detail_trojanws')],
        [InlineKeyboardButton("Renew Trojan WS", callback_data='renew_trojanws')],
        [InlineKeyboardButton("Back to Xray Menu", callback_data='manage_xray')]
    ]
    reply_markup = InlineKeyboardMarkup(keyboard)
    await update.callback_query.message.edit_text(f'TROJAN WS Menu\nServer Selected: {server}', reply_markup=reply_markup)

async def menu_xray_vmessgrpc(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.callback_query.from_user.id
    server = user_data.get(user_id, {}).get('server')
    keyboard = [
        [InlineKeyboardButton("Create Vmess GRPC", callback_data='create_vmessgrpc')],
        [InlineKeyboardButton("Trial Vmess GRPC", callback_data='trial_vmessgrpc')],
        [InlineKeyboardButton("Delete Vmess GRPC", callback_data='del_vmessgrpc')],
        [InlineKeyboardButton("Detail Vmess GRPC", callback_data='detail_vmessgrpc')],
        [InlineKeyboardButton("Renew Vmess GRPC", callback_data='renew_vmessgrpc')],
        [InlineKeyboardButton("Back to Xray Menu", callback_data='manage_xray')]
    ]
    reply_markup = InlineKeyboardMarkup(keyboard)
    await update.callback_query.message.edit_text(f'Vmess GRPC Menu\nServer Selected: {server}', reply_markup=reply_markup)

async def menu_xray_vlessgrpc(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.callback_query.from_user.id
    server = user_data.get(user_id, {}).get('server')
    keyboard = [
        [InlineKeyboardButton("Create Vless GRPC", callback_data='create_vlessgrpc')],
        [InlineKeyboardButton("Trial Vless GRPC", callback_data='trial_vlessgrpc')],
        [InlineKeyboardButton("Delete Vless GRPC", callback_data='del_vlessgrpc')],
        [InlineKeyboardButton("Detail Vless GRPC", callback_data='detail_vlessgrpc')],
        [InlineKeyboardButton("Renew Vless GRPC", callback_data='renew_vlessgrpc')],
        [InlineKeyboardButton("Back to Xray Menu", callback_data='manage_xray')]
    ]
    reply_markup = InlineKeyboardMarkup(keyboard)
    await update.callback_query.message.edit_text(f'Vless GRPC Menu\nServer Selected: {server}', reply_markup=reply_markup)

async def menu_xray_trojangrpc(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.callback_query.from_user.id
    server = user_data.get(user_id, {}).get('server')
    keyboard = [
        [InlineKeyboardButton("Create Trojan GRPC", callback_data='create_trojangrpc')],
        [InlineKeyboardButton("Trial Trojan GRPC", callback_data='trial_trojangrpc')],
        [InlineKeyboardButton("Delete Trojan GRPC", callback_data='del_trojangrpc')],
        [InlineKeyboardButton("Detail Trojan GRPC", callback_data='detail_trojangrpc')],
        [InlineKeyboardButton("Renew Trojan GRPC", callback_data='renew_trojangrpc')],
        [InlineKeyboardButton("Back to Xray Menu", callback_data='manage_xray')]
    ]
    reply_markup = InlineKeyboardMarkup(keyboard)
    await update.callback_query.message.edit_text(f'Trojan GRPC Menu\nServer Selected: {server}', reply_markup=reply_markup)

def escape_html(text):
    """Escape characters for HTML."""
    html_escape_table = {
        "&": "&amp;",
        '"': "&quot;",
        "'": "&#39;",
        ">": "&gt;",
        "<": "&lt;"
    }
    return "".join(html_escape_table.get(c, c) for c in text)

async def handle_create_vmessws(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})
    if user_info.get('command') == 'create_vmessws':
        message = await update.message.reply_text("Process create....")
        try:
            username, exp, limit_ip = update.message.text.split()
        except :
            await message.edit_text("Invalid input format.\nUse: username exp limit_ip")
            return
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
            return
        url = f'http://{server}:5069/add-vmessws'
        headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
        data = {
            "user": username,
            "exp": exp,
            "limit_ip": limit_ip
        }
        response = await run_curl_command(url, headers, data, 'POST')
        parts = re.split(r'(vmess://[^\n]+)', response)
        formatted_parts = []
        for part in parts:
            if part.startswith('vmess://'):
                formatted_parts.append('<pre>' + escape_html(part) + '</pre>')
            else:
                formatted_parts.append(escape_html(part))
        formatted_response = ''.join(formatted_parts)
        try:
            await message.edit_text(formatted_response, parse_mode=ParseMode.HTML)
        except Exception as e:
            await message.edit_text(f"Error: {e}")
        del user_data[user_id]['command']

async def handle_trial_vmessws(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})
    if user_info.get('command') == 'trial_vmessws':
        message = await update.message.reply_text("Process trial....")
        try:
            exp, limit_ip = update.message.text.split()
        except ValueError:
            await message.edit_text("Invalid input format.\nUse: exp limit_ip")
            return
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
            return
        url = f'http://{server}:5069/trial-vmessws'
        headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
        data = {
            "exp": exp,
            "limit_ip": limit_ip
        }
        response = await run_curl_command(url, headers, data, 'POST')
        parts = re.split(r'(vmess://[^\n]+)', response)
        formatted_parts = []
        for part in parts:
            if part.startswith('vmess://'):
                formatted_parts.append('<pre>' + escape_html(part) + '</pre>')
            else:
                formatted_parts.append(escape_html(part))
        formatted_response = ''.join(formatted_parts)
        try:
            await message.edit_text(formatted_response, parse_mode=ParseMode.HTML)
        except Exception as e:
            await message.edit_text(f"Error: {e}")
        del user_data[user_id]['command']

async def handle_del_vmessws(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})

    if user_info.get('command') == 'del_vmessws':
        message = await update.message.reply_text("Process delete....")
        try:
            username = update.message.text
        except ValueError:
            await message.edit_text("Invalid input format.\nUse: username")
            return
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
            return
        url = f'http://{server}:5069/del-vmessws'
        headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
        data = {"user": username}
        response = await run_curl_command(url, headers, data, 'DELETE')
        await message.edit_text(response)
        del user_data[user_id]['command']

async def handle_detail_vmessws(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})
    if user_info.get('command') == 'detail_vmessws':
        message = await update.message.reply_text("Process cek....")
        try:
            username = update.message.text
        except ValueError:
            await message.edit_text("Invalid input format.\nUse: username")
            return
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
            return
        url = f'http://{server}:5069/detail-vmessws'
        headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
        data = {"user": username}
        response = await run_curl_command(url, headers, data, 'GET')
        parts = re.split(r'(vmess://[^\n]+)', response)
        formatted_parts = []
        for part in parts:
            if part.startswith('vmess://'):
                formatted_parts.append('<pre>' + escape_html(part) + '</pre>')
            else:
                formatted_parts.append(escape_html(part))
        formatted_response = ''.join(formatted_parts)
        try:
            await message.edit_text(formatted_response, parse_mode=ParseMode.HTML)
        except Exception as e:
            await message.edit_text(f"Error: {e}")
        del user_data[user_id]['command']

async def handle_renew_vmessws(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})
    if user_info.get('command') == 'renew_vmessws':
        message = await update.message.reply_text("Process renew....")
        try:
            username, exp = update.message.text.split()
        except ValueError:
            await message.edit_text("Invalid input format.\nUse: exp limit_ip")
            return
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
            return
        url = f'http://{server}:5069/renew-vmessws'
        headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
        data = {
            "user": username,
            "exp": exp
        }
        response = await run_curl_command(url, headers, data, 'POST')
        try:
            await message.edit_text(response)
        except Exception as e:
            await message.edit_text(f"Error: {e}")
        del user_data[user_id]['command']

async def handle_create_vlessws(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})
    if user_info.get('command') == 'create_vlessws':
        message = await update.message.reply_text("Process create....")
        try:
            username, exp, limit_ip = update.message.text.split()
        except :
            await message.edit_text("Invalid input format.\nUse: username exp limit_ip")
            return
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
            return
        url = f'http://{server}:5069/add-vlessws'
        headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
        data = {
            "user": username,
            "exp": exp,
            "limit_ip": limit_ip
        }
        response = await run_curl_command(url, headers, data, 'POST')
        parts = re.split(r'(vless://[^\n]+)', response)
        formatted_parts = []
        for part in parts:
            if part.startswith('vless://'):
                formatted_parts.append('<pre>' + escape_html(part) + '</pre>')
            else:
                formatted_parts.append(escape_html(part))
        formatted_response = ''.join(formatted_parts)
        try:
            await message.edit_text(formatted_response, parse_mode=ParseMode.HTML)
        except Exception as e:
            await message.edit_text(f"Error: {e}")
        del user_data[user_id]['command']

async def handle_trial_vlessws(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})
    if user_info.get('command') == 'trial_vlessws':
        message = await update.message.reply_text("Process trial....")
        try:
            exp, limit_ip = update.message.text.split()
        except ValueError:
            await message.edit_text("Invalid input format.\nUse: exp limit_ip")
            return
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
            return
        url = f'http://{server}:5069/trial-vlessws'
        headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
        data = {
            "exp": exp,
            "limit_ip": limit_ip
        }
        response = await run_curl_command(url, headers, data, 'POST')
        parts = re.split(r'(vless://[^\n]+)', response)
        formatted_parts = []
        for part in parts:
            if part.startswith('vless://'):
                formatted_parts.append('<pre>' + escape_html(part) + '</pre>')
            else:
                formatted_parts.append(escape_html(part))
        formatted_response = ''.join(formatted_parts)
        try:
            await message.edit_text(formatted_response, parse_mode=ParseMode.HTML)
        except Exception as e:
            await message.edit_text(f"Error: {e}")
        del user_data[user_id]['command']

async def handle_del_vlessws(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})

    if user_info.get('command') == 'del_vlessws':
        message = await update.message.reply_text("Process delete....")
        try:
            username = update.message.text
        except ValueError:
            await message.edit_text("Invalid input format.\nUse: username")
            return
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
            return
        url = f'http://{server}:5069/del-vlessws'
        headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
        data = {"user": username}
        response = await run_curl_command(url, headers, data, 'DELETE')
        await message.edit_text(response)
        del user_data[user_id]['command']

async def handle_detail_vlessws(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})

    if user_info.get('command') == 'detail_vlessws':
        message = await update.message.reply_text("Process cek....")
        try:
            username = update.message.text
        except ValueError:
            await message.edit_text("Invalid input format.\nUse: username")
            return
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
            return
        url = f'http://{server}:5069/detail-vlessws'
        headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
        data = {"user": username}
        response = await run_curl_command(url, headers, data, 'GET')
        await message.edit_text(response)
        del user_data[user_id]['command']

async def handle_renew_vlessws(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})
    if user_info.get('command') == 'renew_vlessws':
        message = await update.message.reply_text("Process renew....")
        try:
            username, exp = update.message.text.split()
        except ValueError:
            await message.edit_text("Invalid input format.\nUse: exp limit_ip")
            return
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
            return
        url = f'http://{server}:5069/renew-vlessws'
        headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
        data = {
            "user": username,
            "exp": exp
        }
        response = await run_curl_command(url, headers, data, 'POST')
        try:
            await message.edit_text(response)
        except Exception as e:
            await message.edit_text(f"Error: {e}")
        del user_data[user_id]['command']

async def handle_create_trojanws(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})
    if user_info.get('command') == 'create_trojanws':
        message = await update.message.reply_text("Process create....")
        try:
            username, exp, limit_ip = update.message.text.split()
        except :
            await message.edit_text("Invalid input format.\nUse: username exp limit_ip")
            return
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
            return
        url = f'http://{server}:5069/add-trojanws'
        headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
        data = {
            "user": username,
            "exp": exp,
            "limit_ip": limit_ip
        }
        response = await run_curl_command(url, headers, data, 'POST')
        parts = re.split(r'(trojan://[^\n]+)', response)
        formatted_parts = []
        for part in parts:
            if part.startswith('trojan://'):
                formatted_parts.append('<pre>' + escape_html(part) + '</pre>')
            else:
                formatted_parts.append(escape_html(part))
        formatted_response = ''.join(formatted_parts)
        try:
            await message.edit_text(formatted_response, parse_mode=ParseMode.HTML)
        except Exception as e:
            await message.edit_text(f"Error: {e}")
        del user_data[user_id]['command']

async def handle_trial_trojanws(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})
    if user_info.get('command') == 'trial_trojanws':
        message = await update.message.reply_text("Process trial....")
        try:
            exp, limit_ip = update.message.text.split()
        except ValueError:
            await message.edit_text("Invalid input format.\nUse: exp limit_ip")
            return
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
            return
        url = f'http://{server}:5069/trial-trojanws'
        headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
        data = {
            "exp": exp,
            "limit_ip": limit_ip
        }
        response = await run_curl_command(url, headers, data, 'POST')
        parts = re.split(r'(trojan://[^\n]+)', response)
        formatted_parts = []
        for part in parts:
            if part.startswith('trojan://'):
                formatted_parts.append('<pre>' + escape_html(part) + '</pre>')
            else:
                formatted_parts.append(escape_html(part))
        formatted_response = ''.join(formatted_parts)
        try:
            await message.edit_text(formatted_response, parse_mode=ParseMode.HTML)
        except Exception as e:
            await message.edit_text(f"Error: {e}")
        del user_data[user_id]['command']

async def handle_del_trojanws(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})
    if user_info.get('command') == 'del_trojanws':
        message = await update.message.reply_text("Process delete....")
        try:
            username = update.message.text
        except ValueError:
            await message.edit_text("Invalid input format.\nUse: username")
            return
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
            return
        url = f'http://{server}:5069/del-trojanws'
        headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
        data = {"user": username}
        response = await run_curl_command(url, headers, data, 'DELETE')
        await message.edit_text(response)
        del user_data[user_id]['command']

async def handle_detail_trojanws(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})
    if user_info.get('command') == 'detail_trojanws':
        message = await update.message.reply_text("Process cek....")
        try:
            username = update.message.text
        except ValueError:
            await message.edit_text("Invalid input format.\nUse: username")
            return
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
            return
        url = f'http://{server}:5069/detail-trojanws'
        headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
        data = {"user": username}
        response = await run_curl_command(url, headers, data, 'GET')
        await message.edit_text(response)
        del user_data[user_id]['command']

async def handle_renew_trojanws(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})
    if user_info.get('command') == 'renew_trojanws':
        message = await update.message.reply_text("Process renew....")
        try:
            username, exp = update.message.text.split()
        except ValueError:
            await message.edit_text("Invalid input format.\nUse: exp limit_ip")
            return
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
            return
        url = f'http://{server}:5069/renew-trojanws'
        headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
        data = {
            "user": username,
            "exp": exp
        }
        response = await run_curl_command(url, headers, data, 'POST')
        try:
            await message.edit_text(response)
        except Exception as e:
            await message.edit_text(f"Error: {e}")
        del user_data[user_id]['command']

async def handle_create_vmessgrpc(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})
    if user_info.get('command') == 'create_vmessgrpc':
        message = await update.message.reply_text("Process create....")
        try:
            username, exp = update.message.text.split()
        except :
            await message.edit_text("Invalid input format.\nUse: username exp")
            return
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
            return
        url = f'http://{server}:5069/add-vmessgrpc'
        headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
        data = {
            "user": username,
            "exp": exp
        }
        response = await run_curl_command(url, headers, data, 'POST')
        parts = re.split(r'(vmess://[^\n]+)', response)
        formatted_parts = []
        for part in parts:
            if part.startswith('vmess://'):
                formatted_parts.append('<pre>' + escape_html(part) + '</pre>')
            else:
                formatted_parts.append(escape_html(part))
        formatted_response = ''.join(formatted_parts)
        try:
            await message.edit_text(formatted_response, parse_mode=ParseMode.HTML)
        except Exception as e:
            await message.edit_text(f"Error: {e}")
        del user_data[user_id]['command']

async def handle_trial_vmessgrpc(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})
    if user_info.get('command') == 'trial_vmessgrpc':
        message = await update.message.reply_text("Process trial....")
        try:
            exp = update.message.text
        except ValueError:
            await message.edit_text("Invalid input format.\nUse: exp")
            return
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
            return
        url = f'http://{server}:5069/trial-vmessgrpc'
        headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
        data = {
            "exp": exp
        }
        response = await run_curl_command(url, headers, data, 'POST')
        parts = re.split(r'(vmess://[^\n]+)', response)
        formatted_parts = []
        for part in parts:
            if part.startswith('vmess://'):
                formatted_parts.append('<pre>' + escape_html(part) + '</pre>')
            else:
                formatted_parts.append(escape_html(part))
        formatted_response = ''.join(formatted_parts)
        try:
            await message.edit_text(formatted_response, parse_mode=ParseMode.HTML)
        except Exception as e:
            await message.edit_text(f"Error: {e}")
        del user_data[user_id]['command']

async def handle_del_vmessgrpc(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})
    if user_info.get('command') == 'del_vmessgrpc':
        message = await update.message.reply_text("Process delete....")
        try:
            username = update.message.text
        except ValueError:
            await message.edit_text("Invalid input format.\nUse: username")
            return
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
            return
        url = f'http://{server}:5069/del-vmessgrpc'
        headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
        data = {"user": username}
        response = await run_curl_command(url, headers, data, 'DELETE')
        await message.edit_text(response)
        del user_data[user_id]['command']

async def handle_detail_vmessgrpc(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})
    if user_info.get('command') == 'detail_vmessgrpc':
        message = await update.message.reply_text("Process cek....")
        try:
            username = update.message.text
        except ValueError:
            await message.edit_text("Invalid input format.\nUse: username")
            return
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
            return
        url = f'http://{server}:5069/detail-vmessgrpc'
        headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
        data = {"user": username}
        response = await run_curl_command(url, headers, data, 'GET')
        await message.edit_text(response)
        del user_data[user_id]['command']

async def handle_renew_vmessgrpc(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})
    if user_info.get('command') == 'renew_vmessgrpc':
        message = await update.message.reply_text("Process renew....")
        try:
            username, exp = update.message.text.split()
        except ValueError:
            await message.edit_text("Invalid input format.\nUse: exp")
            return
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
            return
        url = f'http://{server}:5069/renew-vmessgrpc'
        headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
        data = {
            "user": username,
            "exp": exp
        }
        response = await run_curl_command(url, headers, data, 'POST')
        try:
            await message.edit_text(response)
        except Exception as e:
            await message.edit_text(f"Error: {e}")
        del user_data[user_id]['command']

async def handle_create_vlessgrpc(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})
    if user_info.get('command') == 'create_vlessgrpc':
        message = await update.message.reply_text("Process create....")
        try:
            username, exp = update.message.text.split()
        except :
            await message.edit_text("Invalid input format.\nUse: username exp")
            return
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
            return
        url = f'http://{server}:5069/add-vlessgrpc'
        headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
        data = {
            "user": username,
            "exp": exp
        }
        response = await run_curl_command(url, headers, data, 'POST')
        parts = re.split(r'(vless://[^\n]+)', response)
        formatted_parts = []
        for part in parts:
            if part.startswith('vless://'):
                formatted_parts.append('<pre>' + escape_html(part) + '</pre>')
            else:
                formatted_parts.append(escape_html(part))
        formatted_response = ''.join(formatted_parts)
        try:
            await message.edit_text(formatted_response, parse_mode=ParseMode.HTML)
        except Exception as e:
            await message.edit_text(f"Error: {e}")
        del user_data[user_id]['command']

async def handle_trial_vlessgrpc(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})
    if user_info.get('command') == 'trial_vlessgrpc':
        message = await update.message.reply_text("Process trial....")
        try:
            exp = update.message.text
        except ValueError:
            await message.edit_text("Invalid input format.\nUse: exp")
            return
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
            return
        url = f'http://{server}:5069/trial-vlessgrpc'
        headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
        data = {
            "exp": exp
        }
        response = await run_curl_command(url, headers, data, 'POST')
        parts = re.split(r'(vless://[^\n]+)', response)
        formatted_parts = []
        for part in parts:
            if part.startswith('vless://'):
                formatted_parts.append('<pre>' + escape_html(part) + '</pre>')
            else:
                formatted_parts.append(escape_html(part))
        formatted_response = ''.join(formatted_parts)
        try:
            await message.edit_text(formatted_response, parse_mode=ParseMode.HTML)
        except Exception as e:
            await message.edit_text(f"Error: {e}")
        del user_data[user_id]['command']

async def handle_del_vlessgrpc(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})
    if user_info.get('command') == 'del_vlessgrpc':
        message = await update.message.reply_text("Process delete....")
        try:
            username = update.message.text
        except ValueError:
            await message.edit_text("Invalid input format.\nUse: username")
            return
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
            return
        url = f'http://{server}:5069/del-vlessgrpc'
        headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
        data = {"user": username}
        response = await run_curl_command(url, headers, data, 'DELETE')
        await message.edit_text(response)
        del user_data[user_id]['command']

async def handle_detail_vlessgrpc(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})
    if user_info.get('command') == 'detail_vlessgrpc':
        message = await update.message.reply_text("Process cek....")
        try:
            username = update.message.text
        except ValueError:
            await message.edit_text("Invalid input format.\nUse: username")
            return
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
            return
        url = f'http://{server}:5069/detail-vlessgrpc'
        headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
        data = {"user": username}
        response = await run_curl_command(url, headers, data, 'GET')
        await message.edit_text(response)
        del user_data[user_id]['command']

async def handle_renew_vlessgrpc(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})
    if user_info.get('command') == 'renew_vlessgrpc':
        message = await update.message.reply_text("Process renew....")
        try:
            username, exp = update.message.text.split()
        except ValueError:
            await message.edit_text("Invalid input format.\nUse: exp")
            return
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
            return
        url = f'http://{server}:5069/renew-vlessgrpc'
        headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
        data = {
            "user": username,
            "exp": exp
        }
        response = await run_curl_command(url, headers, data, 'POST')
        try:
            await message.edit_text(response)
        except Exception as e:
            await message.edit_text(f"Error: {e}")
        del user_data[user_id]['command']

async def handle_create_trojangrpc(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})
    if user_info.get('command') == 'create_trojangrpc':
        message = await update.message.reply_text("Process create....")
        try:
            username, exp = update.message.text.split()
        except :
            await message.edit_text("Invalid input format.\nUse: username exp")
            return
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
            return
        url = f'http://{server}:5069/add-trojangrpc'
        headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
        data = {
            "user": username,
            "exp": exp
        }
        response = await run_curl_command(url, headers, data, 'POST')
        parts = re.split(r'(trojan://[^\n]+)', response)
        formatted_parts = []
        for part in parts:
            if part.startswith('trojan://'):
                formatted_parts.append('<pre>' + escape_html(part) + '</pre>')
            else:
                formatted_parts.append(escape_html(part))
        formatted_response = ''.join(formatted_parts)
        try:
            await message.edit_text(formatted_response, parse_mode=ParseMode.HTML)
        except Exception as e:
            await message.edit_text(f"Error: {e}")
        del user_data[user_id]['command']



async def handle_trial_trojangrpc(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})
    if user_info.get('command') == 'trial_trojangrpc':
        message = await update.message.reply_text("Process trial....")
        try:
            exp = update.message.text
        except ValueError:
            await message.edit_text("Invalid input format.\nUse: exp")
            return
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
            return
        url = f'http://{server}:5069/trial-trojangrpc'
        headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
        data = {
            "exp": exp
        }
        response = await run_curl_command(url, headers, data, 'POST')
        parts = re.split(r'(trojan://[^\n]+)', response)
        formatted_parts = []
        for part in parts:
            if part.startswith('trojan://'):
                formatted_parts.append('<pre>' + escape_html(part) + '</pre>')
            else:
                formatted_parts.append(escape_html(part))
        formatted_response = ''.join(formatted_parts)
        try:
            await message.edit_text(formatted_response, parse_mode=ParseMode.HTML)
        except Exception as e:
            await message.edit_text(f"Error: {e}")
        del user_data[user_id]['command']

async def handle_del_trojangrpc(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})
    if user_info.get('command') == 'del_trojangrpc':
        message = await update.message.reply_text("Process delete....")
        try:
            username = update.message.text
        except ValueError:
            await message.edit_text("Invalid input format.\nUse: username")
            return
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
            return
        url = f'http://{server}:5069/del-trojangrpc'
        headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
        data = {"user": username}
        response = await run_curl_command(url, headers, data, 'DELETE')
        await message.edit_text(response)
        del user_data[user_id]['command']

async def handle_detail_trojangrpc(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})
    if user_info.get('command') == 'detail_trojangrpc':
        message = await update.message.reply_text("Process cek....")
        try:
            username = update.message.text
        except ValueError:
            await message.edit_text("Invalid input format.\nUse: username")
            return
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
            return
        url = f'http://{server}:5069/detail-trojangrpc'
        headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
        data = {"user": username}
        response = await run_curl_command(url, headers, data, 'GET')
        await message.edit_text(response)
        del user_data[user_id]['command']

async def handle_renew_trojangrpc(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})
    if user_info.get('command') == 'renew_trojangrpc':
        message = await update.message.reply_text("Process renew....")
        try:
            username, exp = update.message.text.split()
        except ValueError:
            await message.edit_text("Invalid input format.\nUse: exp")
            return
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
            return
        url = f'http://{server}:5069/renew-trojangrpc'
        headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
        data = {
            "user": username,
            "exp": exp
        }
        response = await run_curl_command(url, headers, data, 'POST')
        try:
            await message.edit_text(response)
        except Exception as e:
            await message.edit_text(f"Error: {e}")
        del user_data[user_id]['command']

async def cek_xray(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.callback_query.from_user.id
    user_info = user_data.get(user_id, {})
    server = user_info.get('server')
    if not server:
        await update.callback_query.message.reply_text("No server selected.")
        return
    try:
        with open('/etc/william/apiX', 'r') as f:
            api_key = f.read().strip()
    except FileNotFoundError:
        await update.callback_query.message.reply_text("API key file not found.")
        return
    url = f'http://{server}:5069/cek-xray'
    headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
    response = await run_curl_command(url, headers, method='GET')
    filename = f"cek_login_xray_{server}.txt"
    with tempfile.NamedTemporaryFile(delete=False, mode='w', suffix='.txt', prefix='cek_login_xray_', dir='/tmp') as temp_file:
        temp_file.write(response)
        file_path = temp_file.name
    try:
        await context.bot.send_document(
            chat_id=update.callback_query.message.chat_id,
            document=open(file_path, 'rb'),
            filename=filename,
            caption='output cek login xray.'
        )
    finally:
        os.unlink(file_path)

async def handle_change_uuid(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})
    if user_info.get('command') == 'change_uuid':
        message = await update.message.reply_text("Process change uuid....")
        try:
            parts = update.message.text.split()
            uuidold = parts[0]
            uuidnew = parts[1] if len(parts) > 1 else ""
        except :
            await message.edit_text("Invalid input format.\nUse: uuid_old uuid_new")
            return
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
            return
        url = f'http://{server}:5069/change-uuid'
        headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
        data = {
            "uuidold": uuidold,
            "uuidnew": uuidnew
        }
        response = await run_curl_command(url, headers, data, 'POST')
        formatted_response = re.sub(
            r'(\b[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}\b)',
            r'<code>\1</code>',
            escape_html(response)
        )    
        try:
            await message.edit_text(formatted_response, parse_mode=ParseMode.HTML)
        except Exception as e:
            await message.edit_text(f"Error: {e}")
        del user_data[user_id]['command']

async def handle_lock_xray(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})
    if user_info.get('command') == 'lock_xray':
        message = await update.message.reply_text("Process lock....")
        username = update.message.text
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
            return
        url = f'http://{server}:5069/lock-xray'
        headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
        data = {"user": username}
        response = await run_curl_command(url, headers, data, 'POST')
        await message.edit_text(response)
        del user_data[user_id]['command']

async def handle_unlock_xray(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})
    if user_info.get('command') == 'unlock_xray':
        message = await update.message.reply_text("Process unlock....")
        username = update.message.text
        server = user_info.get('server')
        if not server:
            await message.edit_text("No server selected.")
            return
        try:
            with open('/etc/william/apiX', 'r') as f:
                api_key = f.read().strip()
        except FileNotFoundError:
            await message.edit_text("API key file not found.")
            return
        url = f'http://{server}:5069/unlock-xray'
        headers = {'X-API-KEY': api_key, 'Content-Type': 'application/json'}
        data = {"user": username}
        response = await run_curl_command(url, headers, data, 'POST')
        await message.edit_text(response)
        del user_data[user_id]['command']

async def button_handler(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    query = update.callback_query
    nickname = update.callback_query.from_user.first_name
    user_id = query.from_user.id
    if not is_valid_user(user_id):
        await update.message.reply_text(f"<b>Hey {nickname} ({user_id}) !!\nYou are not authorized to use this bot.\n\nDev -> @kuotavpn\nJoin -> @script_vpn</b>", parse_mode=ParseMode.HTML)
        return
    await query.answer()
    data = query.data
    user_info = user_data.get(user_id, {})
    if data.startswith('select_'):
        server = data[len('select_'):]
        user_info['server'] = server
        user_data[user_id] = user_info
        await main_menu(update, context)
    elif data == 'manage_ssh':
        await manage_ssh(update, context)
    elif data == 'manage_l2tp':
        await manage_l2tp(update, context)
    elif data == 'check_ssh':
        await cek_ssh(update, context)
    elif data == 'manage_xray':
        await manage_xray(update, context)
    elif data == 'menu_xray_vmessws':
        await menu_xray_vmessws(update, context)
    elif data == 'menu_xray_vlessws':
        await menu_xray_vlessws(update, context)
    elif data == 'menu_xray_trojanws':
        await menu_xray_trojanws(update, context)
    elif data == 'menu_xray_vmessgrpc':
        await menu_xray_vmessgrpc(update, context)
    elif data == 'menu_xray_vlessgrpc':
        await menu_xray_vlessgrpc(update, context)
    elif data == 'menu_xray_trojangrpc':
        await menu_xray_trojangrpc(update, context)
    elif data == 'create_ssh':
        user_info['previous_menu'] = 'manage_ssh'
        user_info['command'] = 'create_ssh'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the following:\n\nusername password exp limit_ip")
    elif data == 'trial_ssh':
        user_info['previous_menu'] = 'manage_ssh'
        user_info['command'] = 'trial_ssh'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the following:\n\nexp limit_ip")
    elif data == 'delete_ssh':
        user_info['previous_menu'] = 'manage_ssh'
        user_info['command'] = 'delete_ssh'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the username to delete.")
    elif data == 'renew_ssh':
        user_info['previous_menu'] = 'manage_ssh'
        user_info['command'] = 'renew_ssh'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the following:\n\nusername exp")
    elif data == 'lock_ssh':
        user_info['previous_menu'] = 'manage_ssh'
        user_info['command'] = 'lock_ssh'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the following:\n\nuser")
    elif data == 'unlock_ssh':
        user_info['previous_menu'] = 'manage_ssh'
        user_info['command'] = 'unlock_ssh'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the following:\n\nuser")
    elif data == 'create_vmessws':
        user_info['previous_menu'] = 'menu_xray_vmessws'
        user_info['command'] = 'create_vmessws'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the following:\n\nusername exp limit_ip")
    elif data == 'trial_vmessws':
        user_info['previous_menu'] = 'menu_xray_vmessws'
        user_info['command'] = 'trial_vmessws'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the following:\n\nexp limit_ip")
    elif data == 'del_vmessws':
        user_info['previous_menu'] = 'menu_xray_vmessws'
        user_info['command'] = 'del_vmessws'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the following:\n\nusername")
    elif data == 'detail_vmessws':
        user_info['previous_menu'] = 'menu_xray_vmessws'
        user_info['command'] = 'detail_vmessws'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the following:\n\nusername")
    elif data == 'renew_vmessws':
        user_info['previous_menu'] = 'menu_xray_vmessws'
        user_info['command'] = 'renew_vmessws'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the following:\n\nusername exp")
    elif data == 'check_xray':
        await cek_xray(update, context)
    elif data == 'back_to_main_menu':
        await main_menu(update, context)
    elif data == 'back_to_selector':
        await back_to_selector(update, context)
    elif data == 'change_uuid':
        user_info['previous_menu'] = 'manage_xray'
        user_info['command'] = 'change_uuid'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the following:\n\nuuid_old uuid_new\n*leave uuid_new blank for random uuid")
    elif data == 'lock_xray':
        user_info['previous_menu'] = 'manage_xray'
        user_info['command'] = 'lock_xray'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the following:\n\nuser")
    elif data == 'unlock_xray':
        user_info['previous_menu'] = 'manage_xray'
        user_info['command'] = 'unlock_xray'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the following:\n\nuser")
    elif data == 'create_vlessws':
        user_info['previous_menu'] = 'menu_xray_vlessws'
        user_info['command'] = 'create_vlessws'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the following:\n\nusername exp limit_ip")
    elif data == 'trial_vlessws':
        user_info['previous_menu'] = 'menu_xray_vlessws'
        user_info['command'] = 'trial_vlessws'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the following:\n\nexp limit_ip")
    elif data == 'del_vlessws':
        user_info['previous_menu'] = 'menu_xray_vlessws'
        user_info['command'] = 'del_vlessws'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the following:\n\nusername")
    elif data == 'detail_vlessws':
        user_info['previous_menu'] = 'menu_xray_vlessws'
        user_info['command'] = 'detail_vlessws'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the following:\n\nusername")
    elif data == 'renew_vlessws':
        user_info['previous_menu'] = 'menu_xray_vlessws'
        user_info['command'] = 'renew_vlessws'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the following:\n\nusername exp")
    elif data == 'create_trojanws':
        user_info['previous_menu'] = 'menu_xray_trojanws'
        user_info['command'] = 'create_trojanws'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the following:\n\nusername exp limit_ip")
    elif data == 'trial_trojanws':
        user_info['previous_menu'] = 'menu_xray_trojanws'
        user_info['command'] = 'trial_trojanws'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the following:\n\nexp limit_ip")
    elif data == 'del_trojanws':
        user_info['previous_menu'] = 'menu_xray_trojanws'
        user_info['command'] = 'del_trojanws'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the following:\n\nusername")
    elif data == 'detail_trojanws':
        user_info['previous_menu'] = 'menu_xray_trojanws'
        user_info['command'] = 'detail_trojanws'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the following:\n\nusername")
    elif data == 'renew_trojanws':
        user_info['previous_menu'] = 'menu_xray_trojanws'
        user_info['command'] = 'renew_trojanws'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the following:\n\nusername exp")
    elif data == 'create_vmessgrpc':
        user_info['previous_menu'] = 'menu_xray_vmessgrpc'
        user_info['command'] = 'create_vmessgrpc'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the following:\n\nusername exp")
    elif data == 'trial_vmessgrpc':
        user_info['previous_menu'] = 'menu_xray_vmessgrpc'
        user_info['command'] = 'trial_vmessgrpc'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the following:\n\nexp")
    elif data == 'del_vmessgrpc':
        user_info['previous_menu'] = 'menu_xray_vmessgrpc'
        user_info['command'] = 'del_vmessgrpc'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the following:\n\nusername")
    elif data == 'detail_vmessgrpc':
        user_info['previous_menu'] = 'menu_xray_vmessgrpc'
        user_info['command'] = 'detail_vmessgrpc'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the following:\n\nusername")
    elif data == 'renew_vmessgrpc':
        user_info['previous_menu'] = 'menu_xray_vmessgrpc'
        user_info['command'] = 'renew_vmessgrpc'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the following:\n\nusername exp")
    elif data == 'create_l2tp':
        user_info['previous_menu'] = 'manage_l2tp'
        user_info['command'] = 'create_l2tp'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the following:\n\nusername password exp")
    elif data == 'delete_l2tp':
        user_info['previous_menu'] = 'manage_l2tp'
        user_info['command'] = 'delete_l2tp'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the username to delete.")
    elif data == 'renew_l2tp':
        user_info['previous_menu'] = 'manage_l2tp'
        user_info['command'] = 'renew_l2tp'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the following:\n\nusername exp")
    elif data == 'create_vlessgrpc':
        user_info['previous_menu'] = 'menu_xray_vlessgrpc'
        user_info['command'] = 'create_vlessgrpc'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the following:\n\nusername exp")
    elif data == 'trial_vlessgrpc':
        user_info['previous_menu'] = 'menu_xray_vlessgrpc'
        user_info['command'] = 'trial_vlessgrpc'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the following:\n\nexp")
    elif data == 'del_vlessgrpc':
        user_info['previous_menu'] = 'menu_xray_vlessgrpc'
        user_info['command'] = 'del_vlessgrpc'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the following:\n\nusername")
    elif data == 'detail_vlessgrpc':
        user_info['previous_menu'] = 'menu_xray_vlessgrpc'
        user_info['command'] = 'detail_vlessgrpc'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the following:\n\nusername")
    elif data == 'renew_vlessgrpc':
        user_info['previous_menu'] = 'menu_xray_vlessgrpc'
        user_info['command'] = 'renew_vlessgrpc'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the following:\n\nusername exp")
    elif data == 'create_trojangrpc':
        user_info['previous_menu'] = 'menu_xray_trojangrpc'
        user_info['command'] = 'create_trojangrpc'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the following:\n\nusername exp")
    elif data == 'trial_trojangrpc':
        user_info['previous_menu'] = 'menu_xray_trojangrpc'
        user_info['command'] = 'trial_trojangrpc'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the following:\n\nexp")
    elif data == 'del_trojangrpc':
        user_info['previous_menu'] = 'menu_xray_trojangrpc'
        user_info['command'] = 'del_trojangrpc'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the following:\n\nusername")
    elif data == 'detail_trojangrpc':
        user_info['previous_menu'] = 'menu_xray_trojangrpc'
        user_info['command'] = 'detail_trojangrpc'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the following:\n\nusername")
    elif data == 'renew_trojangrpc':
        user_info['previous_menu'] = 'menu_xray_trojangrpc'
        user_info['command'] = 'renew_trojangrpc'
        user_data[user_id] = user_info
        await update.callback_query.message.reply_text("Please send the following:\n\nusername exp")

async def handle_message(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user_id = update.message.from_user.id
    user_info = user_data.get(user_id, {})
    if user_info.get('command') == 'create_ssh':
        await handle_create_ssh(update, context)
    elif user_info.get('command') == 'trial_ssh':
        await handle_trial_ssh(update, context)
    elif user_info.get('command') == 'renew_ssh':
        await handle_renew_ssh(update, context)
    elif user_info.get('command') == 'delete_ssh':
        await handle_delete_ssh(update, context)
    elif user_info.get('command') == 'lock_ssh':
        await handle_lock_ssh(update, context)
    elif user_info.get('command') == 'unlock_ssh':
        await handle_unlock_ssh(update, context)
    elif user_info.get('command') == 'create_l2tp':
        await handle_create_l2tp(update, context)
    elif user_info.get('command') == 'delete_l2tp':
        await handle_delete_l2tp(update, context)
    elif user_info.get('command') == 'renew_l2tp':
        await handle_renew_l2tp(update, context)
    elif user_info.get('command') == 'create_vmessws':
        await handle_create_vmessws(update, context)
    elif user_info.get('command') == 'trial_vmessws':
        await handle_trial_vmessws(update, context)
    elif user_info.get('command') == 'del_vmessws':
        await handle_del_vmessws(update, context)
    elif user_info.get('command') == 'detail_vmessws':
        await handle_detail_vmessws(update, context)
    elif user_info.get('command') == 'renew_vmessws':
        await handle_renew_vmessws(update, context)
    elif user_info.get('command') == 'create_vlessws':
        await handle_create_vlessws(update, context)
    elif user_info.get('command') == 'trial_vlessws':
        await handle_trial_vlessws(update, context)
    elif user_info.get('command') == 'del_vlessws':
        await handle_del_vlessws(update, context)
    elif user_info.get('command') == 'detail_vlessws':
        await handle_detail_vlessws(update, context)
    elif user_info.get('command') == 'renew_vlessws':
        await handle_renew_vlessws(update, context)
    elif user_info.get('command') == 'create_trojanws':
        await handle_create_trojanws(update, context)
    elif user_info.get('command') == 'trial_trojanws':
        await handle_trial_trojanws(update, context)
    elif user_info.get('command') == 'del_trojanws':
        await handle_del_trojanws(update, context)
    elif user_info.get('command') == 'detail_trojanws':
        await handle_detail_trojanws(update, context)
    elif user_info.get('command') == 'renew_trojanws':
        await handle_renew_trojanws(update, context)
    elif user_info.get('command') == 'create_vmessgrpc':
        await handle_create_vmessgrpc(update, context)
    elif user_info.get('command') == 'trial_vmessgrpc':
        await handle_trial_vmessgrpc(update, context)
    elif user_info.get('command') == 'del_vmessgrpc':
        await handle_del_vmessgrpc(update, context)
    elif user_info.get('command') == 'detail_vmessgrpc':
        await handle_detail_vmessgrpc(update, context)
    elif user_info.get('command') == 'renew_vmessgrpc':
        await handle_renew_vmessgrpc(update, context)
    elif user_info.get('command') == 'create_vlessgrpc':
        await handle_create_vlessgrpc(update, context)
    elif user_info.get('command') == 'trial_vlessgrpc':
        await handle_trial_vlessgrpc(update, context)
    elif user_info.get('command') == 'del_vlessgrpc':
        await handle_del_vlessgrpc(update, context)
    elif user_info.get('command') == 'detail_vlessgrpc':
        await handle_detail_vlessgrpc(update, context)
    elif user_info.get('command') == 'renew_vlessgrpc':
        await handle_renew_vlessgrpc(update, context)
    elif user_info.get('command') == 'create_trojangrpc':
        await handle_create_trojangrpc(update, context)
    elif user_info.get('command') == 'trial_trojangrpc':
        await handle_trial_trojangrpc(update, context)
    elif user_info.get('command') == 'del_trojangrpc':
        await handle_del_trojangrpc(update, context)
    elif user_info.get('command') == 'detail_trojangrpc':
        await handle_detail_trojangrpc(update, context)
    elif user_info.get('command') == 'renew_trojangrpc':
        await handle_renew_trojangrpc(update, context)
    elif user_info.get('command') == 'change_uuid':
        await handle_change_uuid(update, context)
    elif user_info.get('command') == 'lock_xray':
        await handle_lock_xray(update, context)
    elif user_info.get('command') == 'unlock_xray':
        await handle_unlock_xray(update, context)

def main() -> None:
    bot_token = read_bot_token()
    application = Application.builder().token(bot_token).build()
    application.add_handler(CommandHandler('start', start))
    application.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, handle_message))
    application.add_handler(CallbackQueryHandler(button_handler))
    application.run_polling()

if __name__ == '__main__':
    main()
