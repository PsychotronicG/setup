#!/usr/bin/env python3
import sys, os, yaml

def load(filepath):
    if not os.path.exists(filepath):
        return {}
    with open(filepath) as f:
        return yaml.safe_load(f) or {}

def list_commands(directory, tool_filter=None, cat_filter=None):
    files = []
    for f in sorted(os.listdir(directory)):
        if not f.endswith('.yaml'):
            continue
        tool = f[:-5]
        if tool_filter and tool != tool_filter:
            continue
        files.append((tool, os.path.join(directory, f)))

    for tool, filepath in files:
        data = load(filepath)
        for category, commands in data.items():
            if cat_filter and category != cat_filter:
                continue
            if not commands:
                continue
            for cmd in commands:
                name = cmd.get('name', '')
                command = cmd.get('command', '')
                display = f"{tool:<12} {category:<14} {name}"
                print(f"{display}\t{tool}\t{category}\t{name}\t{command}")

def list_tools(directory):
    for f in sorted(os.listdir(directory)):
        if not f.endswith('.yaml'):
            continue
        tool = f[:-5]
        data = load(os.path.join(directory, f))
        total = sum(len(v) for v in data.values() if v)
        cats = len(data)
        print(f"{tool}\t{total} commands · {cats} categories")

def list_cats(filepath):
    data = load(filepath)
    for cat, commands in data.items():
        count = len(commands) if commands else 0
        print(f"{cat}\t{count} commands")

def preview_tool(filepath):
    tool = os.path.basename(filepath)[:-5]
    data = load(filepath)
    print(f"\n  \033[36m{tool}\033[0m\n")
    for cat, commands in data.items():
        count = len(commands) if commands else 0
        print(f"  \033[34m{cat:<20}\033[0m  {count} commands")
    print()

def preview_cat(filepath, tool, category):
    data = load(filepath)
    commands = data.get(category, [])
    print(f"\n  \033[36m{tool}\033[0m / \033[34m{category}\033[0m\n")
    for cmd in commands:
        name = cmd.get('name', '')
        command = cmd.get('command', '')
        print(f"  \033[2m·\033[0m  {name}")
        print(f"     \033[1m$ {command}\033[0m\n")

def list_categories(filepath):
    data = load(filepath)
    for cat in data.keys():
        print(cat)

def add_command(filepath, category, name, command):
    data = load(filepath)
    if category not in data:
        data[category] = []
    data[category].append({'name': name, 'command': command})
    with open(filepath, 'w') as f:
        yaml.dump(data, f, default_flow_style=False, allow_unicode=True, sort_keys=False)

def count_commands(filepath):
    data = load(filepath)
    total = sum(len(v) for v in data.values() if v)
    print(total)

if __name__ == '__main__':
    subcmd = sys.argv[1]

    if subcmd == 'list':
        directory = sys.argv[2]
        tool_filter = sys.argv[3] if len(sys.argv) > 3 and sys.argv[3] else None
        cat_filter  = sys.argv[4] if len(sys.argv) > 4 and sys.argv[4] else None
        list_commands(directory, tool_filter, cat_filter)

    elif subcmd == 'list_tools':
        list_tools(sys.argv[2])

    elif subcmd == 'list_cats':
        list_cats(sys.argv[2])

    elif subcmd == 'preview_tool':
        preview_tool(sys.argv[2])

    elif subcmd == 'preview_cat':
        preview_cat(sys.argv[2], sys.argv[3], sys.argv[4])

    elif subcmd == 'categories':
        list_categories(sys.argv[2])

    elif subcmd == 'add':
        add_command(sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5])

    elif subcmd == 'count':
        count_commands(sys.argv[2])
