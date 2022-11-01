#!/usr/bin/env python3
import json
import textwrap

from datetime import datetime
from subprocess import check_output


RESET = "\x1b[0m"
BOLD = "\x1b[1m"
ULINE = "\x1b[4m"
STRIKE = "\x1b[9m"

DGRAY = "\x1b[30m"
RED = "\x1b[31m"
GREEN = "\x1b[32m"
YELLOW = "\x1b[33m"

ipdata = json.loads(check_output(['ip', '-j', 'addr', 'show']))
uptime = check_output(['uptime']).strip().decode('utf-8')
update_time = datetime.now()

print(
    f"{STRIKE}{YELLOW}[[[{RESET} "
    f"{YELLOW}Welcome to {BOLD}\\n{RESET} "
    f"{YELLOW}(\\l) "
    f"{STRIKE}{YELLOW}]]]{RESET}"
)
print(RED + r'\v \r \m')
print(uptime + RESET)
print()

print(f"{GREEN}{ULINE}{BOLD}Network Info:{RESET}")
for inf in ipdata:
    ifname = inf['ifname']
    mac = inf['address']
    ips = [x['local'] for x in inf['addr_info']]

    print(
        f'  {BOLD}{GREEN}{ifname}{RESET} '
        f'{DGRAY}({mac}){RESET}'
    )
    ips_text = ', '.join((f'{YELLOW}{i}{RESET}' for i in ips))
    for l in textwrap.wrap(ips_text):
        print('    ' + l)
    print(RESET, end='')

print()
