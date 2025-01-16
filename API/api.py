#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from flask import Flask, request, jsonify
import subprocess, re, sys, getpass, os

app = Flask(__name__)

API_KEY_FILE = '/etc/william/apiX'

def check_ulimit():
    """Memeriksa nilai ulimit -c dan keluar jika nilainya tidak sama dengan 0."""
    result = subprocess.run('ulimit -c', capture_output=True, text=True, shell=True, executable='/bin/bash')
    if result.returncode == 0:
        limit_c = result.stdout.strip()
        if limit_c != '0':
            print("Im Watching You...")
            print("- @user_legend")
            sys.exit()

check_ulimit()

def load_api_key():
    """Memuat API key dari file atau menggunakan default jika file tidak ada."""
    if os.path.exists(API_KEY_FILE):
        with open(API_KEY_FILE, 'r') as f:
            return f.read().strip()
    return "please_input_your_apikey"

def save_api_key(api_key):
    """Menyimpan API key ke file."""
    try:
        with open(API_KEY_FILE, 'w') as f:
            f.write(api_key)
        print(f"API key disimpan ke {API_KEY_FILE}")
    except Exception as e:
        print(f"Gagal menyimpan API key ke file: {e}")

api_key = load_api_key()
VALID_API_KEYS = {api_key: "admin"}

def prompt_for_api_key():
    """Meminta input API key baru dan menyimpannya."""
    api_key = input("Masukkan API key baru: ")
    save_api_key(api_key)
    VALID_API_KEYS.clear()
    VALID_API_KEYS[api_key] = "admin"
    print("API key berhasil diperbarui.")
    sys.exit(0)

if api_key == "please_input_your_apikey":
    prompt_for_api_key()
elif len(sys.argv) > 1 and sys.argv[1] == "changeapi":
    prompt_for_api_key()
    sys.exit(0)

def check_api_key(api_key):
    """Periksa apakah API key valid."""
    return api_key in VALID_API_KEYS

def remove_escape_codes(text):
    """Menghapus semua escape codes ANSI dari teks."""
    ansi_escape = re.compile(r'\x1b\[[0-?]*[ -/]*[@-~]')
    return ansi_escape.sub('', text)
    
def remove_escape_codes_and_replace_lines(text):
    """Menghapus semua escape codes ANSI dari teks dan mengganti karakter garis horizontal."""
    text = remove_escape_codes(text)
    text = re.sub(r'\u2501+', '━━━━━━━━━━━━━━━━━━━━', text)
    return text

@app.route('/add-ssh', methods=['POST'])
def add_ssh():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    user = request.json.get('user')
    password = request.json.get('pass')
    exp = request.json.get('exp')
    limit_ip = request.json.get('limit_ip', '0')
    if not re.match(r'^[a-zA-Z0-9_]+$', user):
        return jsonify({'error': 'Invalid username format. Only alphanumeric and underscore are allowed.'}), 400
    if None in [user, password, exp]:
        return jsonify({'error': 'Missing required parameter(s).'}), 400
    try:
        command = ['add-sshx', user, password, exp, limit_ip]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)   
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/trial-ssh', methods=['POST'])
def trial_ssh():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    exp = request.json.get('exp')
    limit_ip = request.json.get('limit_ip', '0')
    if not re.match(r'^[0-9]+$', exp):
        return jsonify({'error': 'Invalid username format. Only numeric are allowed.'}), 400
    if None in [exp, limit_ip]:
        return jsonify({'error': 'Missing required parameter(s).'}), 400
    try:
        command = ['trial-sshx', exp, limit_ip]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/renew-ssh', methods=['POST'])
def renew_ssh():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    user = request.json.get('user')
    exp = request.json.get('exp')
    if not re.match(r'^[a-zA-Z0-9_]+$', user):
        return jsonify({'error': 'Invalid username format. Only alphanumeric and underscore are allowed.'}), 400
    if None in [user, exp]:
        return jsonify({'error': 'Missing required parameter(s).'}), 400
    try:
        command = ['renew-sshx', user, exp]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/del-ssh', methods=['DELETE'])
def delete_ssh():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    user = request.json.get('user')
    if not re.match(r'^[a-zA-Z0-9_]+$', user):
        return jsonify({'error': 'Invalid username format. Only alphanumeric and underscore are allowed.'}), 400
    try:
        command = ['del-sshx', user]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/cek-ssh', methods=['GET'])
def cek_ssh():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    try:
        command = ['cek']
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking...",
                "Checking VPS"
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/unlock-ssh', methods=['POST'])
def unlock_ssh():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    user = request.json.get('user')
    if not re.match(r'^[a-zA-Z0-9_]+$', user):
        return jsonify({'error': 'Invalid username format. Only alphanumeric and underscore are allowed.'}), 400
    try:
        command = ['unlock-ssh', user]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/lock-ssh', methods=['POST'])
def lock_ssh():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    user = request.json.get('user')
    if not re.match(r'^[a-zA-Z0-9_]+$', user):
        return jsonify({'error': 'Invalid username format. Only alphanumeric and underscore are allowed.'}), 400
    try:
        command = ['lock-ssh', user]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

#===========

@app.route('/add-vmessws', methods=['POST'])
def add_vmessws():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    user = request.json.get('user')
    exp = request.json.get('exp')
    limit_ip = request.json.get('limit_ip', '0')
 
    if not re.match(r'^[a-zA-Z0-9_]+$', user):
        return jsonify({'error': 'Invalid username format. Only alphanumeric and underscore are allowed.'}), 400
    if None in [user, exp]:
        return jsonify({'error': 'Missing required parameter(s).'}), 400
    try:
        command = ['add-vmws', user, exp, limit_ip]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/trial-vmessws', methods=['POST'])
def trial_vmessws():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    exp = request.json.get('exp')
    limit_ip = request.json.get('limit_ip', '0')
    if not re.match(r'^[0-9]+$', exp):
        return jsonify({'error': 'Invalid username format. Only numeric are allowed.'}), 400
    if None in [exp, limit_ip]:
        return jsonify({'error': 'Missing required parameter(s).'}), 400
    try:
        command = ['trial-vmws', exp, limit_ip]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)     
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/renew-vmessws', methods=['POST'])
def renew_vmws():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    user = request.json.get('user')
    exp = request.json.get('exp')
    if not re.match(r'^[a-zA-Z0-9_]+$', user):
        return jsonify({'error': 'Invalid username format. Only alphanumeric and underscore are allowed.'}), 400
    if None in [user, exp]:
        return jsonify({'error': 'Missing required parameter(s).'}), 400
    try:
        command = ['renew-vmws', user, exp]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True) 
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/del-vmessws', methods=['DELETE'])
def delete_vmessws():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    user = request.json.get('user')
    if not re.match(r'^[a-zA-Z0-9_]+$', user):
        return jsonify({'error': 'Invalid username format. Only alphanumeric and underscore are allowed.'}), 400
    try:
        command = ['del-vmws', user]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/detail-vmessws', methods=['GET'])
def detail_vmessws():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    user = request.json.get('user')
    if not re.match(r'^[a-zA-Z0-9_]+$', user):
        return jsonify({'error': 'Invalid username format. Only alphanumeric and underscore are allowed.'}), 400
    try:
        command = ['detail-vmws', user]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/add-vlessws', methods=['POST'])
def add_vlessws():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    user = request.json.get('user')
    exp = request.json.get('exp')
    limit_ip = request.json.get('limit_ip', '0')
    if not re.match(r'^[a-zA-Z0-9_]+$', user):
        return jsonify({'error': 'Invalid username format. Only alphanumeric and underscore are allowed.'}), 400
    if None in [user, exp]:
        return jsonify({'error': 'Missing required parameter(s).'}), 400
    try:
        command = ['add-vlws', user, exp, limit_ip]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/trial-vlessws', methods=['POST'])
def trial_vlessws():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    exp = request.json.get('exp')
    limit_ip = request.json.get('limit_ip', '0')
    if not re.match(r'^[0-9]+$', exp):
        return jsonify({'error': 'Invalid username format. Only numeric are allowed.'}), 400
    if None in [exp, limit_ip]:
        return jsonify({'error': 'Missing required parameter(s).'}), 400
    try:
        command = ['trial-vlws', exp, limit_ip]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/renew-vlessws', methods=['POST'])
def renew_vlessws():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    user = request.json.get('user')
    exp = request.json.get('exp')
    if not re.match(r'^[a-zA-Z0-9_]+$', user):
        return jsonify({'error': 'Invalid username format. Only alphanumeric and underscore are allowed.'}), 400
    if None in [user, exp]:
        return jsonify({'error': 'Missing required parameter(s).'}), 400
    try:
        command = ['renew-vlws', user, exp]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/del-vlessws', methods=['DELETE'])
def delete_vlessws():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    user = request.json.get('user')
    if not re.match(r'^[a-zA-Z0-9_]+$', user):
        return jsonify({'error': 'Invalid username format. Only alphanumeric and underscore are allowed.'}), 400
    try:
        command = ['del-vlws', user]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/detail-vlessws', methods=['GET'])
def detail_vlessws():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    user = request.json.get('user')
    if not re.match(r'^[a-zA-Z0-9_]+$', user):
        return jsonify({'error': 'Invalid username format. Only alphanumeric and underscore are allowed.'}), 400
    try:
        command = ['detail-vlws', user]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/add-trojanws', methods=['POST'])
def add_trojanws():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    user = request.json.get('user')
    exp = request.json.get('exp')
    limit_ip = request.json.get('limit_ip', '0')
    if not re.match(r'^[a-zA-Z0-9_]+$', user):
        return jsonify({'error': 'Invalid username format. Only alphanumeric and underscore are allowed.'}), 400
    if None in [user, exp]:
        return jsonify({'error': 'Missing required parameter(s).'}), 400
    try:
        command = ['add-trojanws', user, exp, limit_ip]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/trial-trojanws', methods=['POST'])
def trial_trojanws():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    exp = request.json.get('exp')
    limit_ip = request.json.get('limit_ip', '0')
    if not re.match(r'^[0-9]+$', exp):
        return jsonify({'error': 'Invalid username format. Only numeric are allowed.'}), 400
    if None in [exp, limit_ip]:
        return jsonify({'error': 'Missing required parameter(s).'}), 400
    try:
        command = ['trial-trojanws', exp, limit_ip]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/renew-trojanws', methods=['POST'])
def renew_trojanws():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    user = request.json.get('user')
    exp = request.json.get('exp')
    if not re.match(r'^[a-zA-Z0-9_]+$', user):
        return jsonify({'error': 'Invalid username format. Only alphanumeric and underscore are allowed.'}), 400
    if None in [user, exp]:
        return jsonify({'error': 'Missing required parameter(s).'}), 400
    try:
        command = ['renew-trojanws', user, exp]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/del-trojanws', methods=['DELETE'])
def delete_trojanws():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    user = request.json.get('user')
    if not re.match(r'^[a-zA-Z0-9_]+$', user):
        return jsonify({'error': 'Invalid username format. Only alphanumeric and underscore are allowed.'}), 400
    try:
        command = ['del-trojanws', user]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/detail-trojanws', methods=['GET'])
def detail_trojanws():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    user = request.json.get('user')
    if not re.match(r'^[a-zA-Z0-9_]+$', user):
        return jsonify({'error': 'Invalid username format. Only alphanumeric and underscore are allowed.'}), 400
    try:
        command = ['detail-trojanws', user]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/add-vmessgrpc', methods=['POST'])
def add_vmessgrpc():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    user = request.json.get('user')
    exp = request.json.get('exp')
    if not re.match(r'^[a-zA-Z0-9_]+$', user):
        return jsonify({'error': 'Invalid username format. Only alphanumeric and underscore are allowed.'}), 400
    if None in [user, exp]:
        return jsonify({'error': 'Missing required parameter(s).'}), 400
    try:
        command = ['add-vmgrpc', user, exp]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/trial-vmessgrpc', methods=['POST'])
def trial_vmessgrpc():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    exp = request.json.get('exp')
    if exp is None:
        return jsonify({'error': 'Missing required parameter: exp.'}), 400
    if not isinstance(exp, str):
        return jsonify({'error': 'Invalid parameter type: exp must be a string.'}), 400
    if not re.match(r'^[0-9]+$', exp):
        return jsonify({'error': 'Invalid exp format. Only numeric characters are allowed.'}), 400
    try:
        command = ['trial-vmgrpc', exp]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)     
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/renew-vmessgrpc', methods=['POST'])
def renew_vmgrpc():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    user = request.json.get('user')
    exp = request.json.get('exp')
    if not re.match(r'^[a-zA-Z0-9_]+$', user):
        return jsonify({'error': 'Invalid username format. Only alphanumeric and underscore are allowed.'}), 400
    if None in [user, exp]:
        return jsonify({'error': 'Missing required parameter(s).'}), 400
    try:
        command = ['renew-vmgrpc', user, exp]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True) 
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/del-vmessgrpc', methods=['DELETE'])
def delete_vmessgrpc():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    user = request.json.get('user')
    if not re.match(r'^[a-zA-Z0-9_]+$', user):
        return jsonify({'error': 'Invalid username format. Only alphanumeric and underscore are allowed.'}), 400
    try:
        command = ['del-vmgrpc', user]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/detail-vmessgrpc', methods=['GET'])
def detail_vmessgrpc():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    user = request.json.get('user')
    if not re.match(r'^[a-zA-Z0-9_]+$', user):
        return jsonify({'error': 'Invalid username format. Only alphanumeric and underscore are allowed.'}), 400
    try:
        command = ['detail-vmgrpc', user]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/add-trojangrpc', methods=['POST'])
def add_trojangrpc():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    user = request.json.get('user')
    exp = request.json.get('exp')
    if not re.match(r'^[a-zA-Z0-9_]+$', user):
        return jsonify({'error': 'Invalid username format. Only alphanumeric and underscore are allowed.'}), 400
    if None in [user, exp]:
        return jsonify({'error': 'Missing required parameter(s).'}), 400
    try:
        command = ['add-trojangrpc', user, exp]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/trial-trojangrpc', methods=['POST'])
def trial_trojangrpc():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    exp = request.json.get('exp')
    if exp is None:
        return jsonify({'error': 'Missing required parameter: exp.'}), 400
    if not isinstance(exp, str):
        return jsonify({'error': 'Invalid parameter type: exp must be a string.'}), 400
    if not re.match(r'^[0-9]+$', exp):
        return jsonify({'error': 'Invalid exp format. Only numeric characters are allowed.'}), 400
    try:
        command = ['trial-trojangrpc', exp]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)     
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/renew-trojangrpc', methods=['POST'])
def renew_trojangrpc():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    user = request.json.get('user')
    exp = request.json.get('exp')
    if not re.match(r'^[a-zA-Z0-9_]+$', user):
        return jsonify({'error': 'Invalid username format. Only alphanumeric and underscore are allowed.'}), 400
    if None in [user, exp]:
        return jsonify({'error': 'Missing required parameter(s).'}), 400
    try:
        command = ['renew-trojangrpc', user, exp]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True) 
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/del-trojangrpc', methods=['DELETE'])
def delete_trojangrpc():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    user = request.json.get('user')
    if not re.match(r'^[a-zA-Z0-9_]+$', user):
        return jsonify({'error': 'Invalid username format. Only alphanumeric and underscore are allowed.'}), 400
    try:
        command = ['del-trojangrpc', user]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/detail-trojangrpc', methods=['GET'])
def detail_trojangrpc():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    user = request.json.get('user')
    if not re.match(r'^[a-zA-Z0-9_]+$', user):
        return jsonify({'error': 'Invalid username format. Only alphanumeric and underscore are allowed.'}), 400
    try:
        command = ['detail-trojangrpc', user]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/add-vlessgrpc', methods=['POST'])
def add_vlessgrpc():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    user = request.json.get('user')
    exp = request.json.get('exp')
    if not re.match(r'^[a-zA-Z0-9_]+$', user):
        return jsonify({'error': 'Invalid username format. Only alphanumeric and underscore are allowed.'}), 400
    if None in [user, exp]:
        return jsonify({'error': 'Missing required parameter(s).'}), 400
    try:
        command = ['add-vlgrpc', user, exp]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/trial-vlessgrpc', methods=['POST'])
def trial_vlessgrpc():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    exp = request.json.get('exp')
    if exp is None:
        return jsonify({'error': 'Missing required parameter: exp.'}), 400
    if not isinstance(exp, str):
        return jsonify({'error': 'Invalid parameter type: exp must be a string.'}), 400
    if not re.match(r'^[0-9]+$', exp):
        return jsonify({'error': 'Invalid exp format. Only numeric characters are allowed.'}), 400
    try:
        command = ['trial-vlgrpc', exp]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)     
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/renew-vlessgrpc', methods=['POST'])
def renew_vlessgrpc():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    user = request.json.get('user')
    exp = request.json.get('exp')
    if not re.match(r'^[a-zA-Z0-9_]+$', user):
        return jsonify({'error': 'Invalid username format. Only alphanumeric and underscore are allowed.'}), 400
    if None in [user, exp]:
        return jsonify({'error': 'Missing required parameter(s).'}), 400
    try:
        command = ['renew-vlgrpc', user, exp]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True) 
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/del-vlessgrpc', methods=['DELETE'])
def delete_vlessgrpc():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    user = request.json.get('user')
    if not re.match(r'^[a-zA-Z0-9_]+$', user):
        return jsonify({'error': 'Invalid username format. Only alphanumeric and underscore are allowed.'}), 400
    try:
        command = ['del-vlgrpc', user]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/detail-vlessgrpc', methods=['GET'])
def detail_vlessgrpc():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    user = request.json.get('user')
    if not re.match(r'^[a-zA-Z0-9_]+$', user):
        return jsonify({'error': 'Invalid username format. Only alphanumeric and underscore are allowed.'}), 400
    try:
        command = ['detail-vlgrpc', user]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500
        
@app.route('/cek-xray', methods=['GET'])
def cek_xray():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    try:
        command = ['cek-xray']
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

#===========

@app.route('/add-l2tp', methods=['POST'])
def add_l2tp():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    user = request.json.get('user')
    password = request.json.get('pass')
    exp = request.json.get('exp')
    if not re.match(r'^[a-zA-Z0-9_]+$', user):
        return jsonify({'error': 'Invalid username format. Only alphanumeric and underscore are allowed.'}), 400
    if None in [user, password, exp]:
        return jsonify({'error': 'Missing required parameter(s).'}), 400
    try:
        command = ['add-l2tpx', user, password, exp]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)   
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/renew-l2tp', methods=['POST'])
def renew_l2tp():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    user = request.json.get('user')
    exp = request.json.get('exp')
    if not re.match(r'^[a-zA-Z0-9_]+$', user):
        return jsonify({'error': 'Invalid username format. Only alphanumeric and underscore are allowed.'}), 400
    if None in [user, exp]:
        return jsonify({'error': 'Missing required parameter(s).'}), 400
    try:
        command = ['renew-l2tpx', user, exp]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/del-l2tp', methods=['DELETE'])
def delete_l2tp():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    user = request.json.get('user')
    if not re.match(r'^[a-zA-Z0-9_]+$', user):
        return jsonify({'error': 'Invalid username format. Only alphanumeric and underscore are allowed.'}), 400
    try:
        command = ['del-l2tpx', user]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/change-uuid', methods=['POST'])
def change_uuid():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    uuidold = request.json.get('uuidold')
    uuidnew = request.json.get('uuidnew')
    try:
        command = ['change-uuidx', uuidold, uuidnew]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/unlock-xray', methods=['POST'])
def unlock_xray():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    user = request.json.get('user')
    if not re.match(r'^[a-zA-Z0-9_]+$', user):
        return jsonify({'error': 'Invalid username format. Only alphanumeric and underscore are allowed.'}), 400
    try:
        command = ['unlock-xray', user]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/lock-xray', methods=['POST'])
def lock_xray():
    api_key = request.headers.get('X-API-KEY')
    if not api_key or not check_api_key(api_key):
        return jsonify({'error': 'Invalid or missing API key.'}), 401
    user = request.json.get('user')
    if not re.match(r'^[a-zA-Z0-9_]+$', user):
        return jsonify({'error': 'Invalid username format. Only alphanumeric and underscore are allowed.'}), 400
    try:
        command = ['lock-xray', user]
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        filtered_stdout = '\n'.join(
            line for line in remove_escape_codes_and_replace_lines(result.stdout).splitlines()
            if not any(exclude in line for exclude in [
                "curl is already installed",
                "Wget is already installed",
                "Client Name Accepted",
                "IP Address Accepted",
                "Script Active !",
                "Checking..."
            ])
        )
        response = {
            'stdout': filtered_stdout.strip(),
            'stderr': remove_escape_codes_and_replace_lines(result.stderr).strip(),
            'returncode': result.returncode
        }
        if result.returncode == 0:
            return jsonify(response), 200
        else:
            return jsonify(response), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500

#===========

if __name__ == '__main__':
    from waitress import serve
    serve(app, host="0.0.0.0", port=5069)
    
