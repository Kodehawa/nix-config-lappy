#!/nix/store/wz0j2zi02rvnjiz37nn28h3gfdq61svz-python3-3.12.9/bin/python3

import subprocess


def get_output(cmd):
    try:
        return subprocess.check_output(cmd, shell=True).decode("utf-8").strip().splitlines()
    except subprocess.CalledProcessError:
        return ""


o = get_output("rfkill list")
for line in o:
    if "Soft blocked: yes" in line or "Hard blocked: yes" in line:
        print("airplane-mode-symbolic")
        print("")
        break
