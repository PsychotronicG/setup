#!/usr/bin/env python3
import subprocess, json, sys

file, lang = sys.argv[1], sys.argv[2]

RESET = '\033[0m'
DIM   = '\033[2m'

KIND_COLOR = {
    # types — cyan family
    'class':     '\033[1;36m',
    'interface': '\033[0;36m',
    'struct':    '\033[0;36m',
    'enum':      '\033[0;36m',
    'type':      '\033[0;36m',
    'impl':      '\033[2;36m',
    'trait':     '\033[0;36m',
    'module':    '\033[0;36m',
    # callables — green family
    'def':       '\033[0;32m',
    'async def': '\033[1;32m',
    'fn':        '\033[0;32m',
    'pub fn':    '\033[1;32m',
    'function':  '\033[0;32m',
    'arrow':     '\033[0;32m',
    'method':    '\033[0;32m',
}

def colorize(kind, text, lineno):
    color = KIND_COLOR.get(kind, '\033[0;37m')
    kind_col  = f"{color}{kind:<12}{RESET}"
    text_col  = f"{text:<57}"
    line_col  = f"{DIM}{lineno:>5}{RESET}"
    return f"{kind_col}{text_col}{line_col}"

PATTERNS = {
    'python': [
        ('class', 'class $NAME'),
        ('def',   'def $NAME($$$)'),
        ('def',   'async def $NAME($$$)'),
    ],
    'javascript': [
        ('class',    'class $NAME { $$$ }'),
        ('function', 'function $NAME($$$) { $$$ }'),
        ('arrow',    'const $NAME = ($$$) => $$$'),
        ('arrow',    'const $NAME = async ($$$) => $$$'),
    ],
    'typescript': [
        ('class',     'class $NAME { $$$ }'),
        ('function',  'function $NAME($$$) { $$$ }'),
        ('function',  'async function $NAME($$$) { $$$ }'),
        ('arrow',     'const $NAME = ($$$) => $$$'),
        ('arrow',     'const $NAME = async ($$$) => $$$'),
        ('interface', 'interface $NAME { $$$ }'),
        ('type',      'type $NAME = $$$'),
    ],
    'tsx': [
        ('class',     'class $NAME { $$$ }'),
        ('function',  'function $NAME($$$) { $$$ }'),
        ('arrow',     'const $NAME = ($$$) => $$$'),
        ('interface', 'interface $NAME { $$$ }'),
        ('type',      'type $NAME = $$$'),
    ],
    'rust': [
        ('fn',     'fn $NAME($$$) { $$$ }'),
        ('pub fn', 'pub fn $NAME($$$) { $$$ }'),
        ('struct', 'struct $NAME { $$$ }'),
        ('enum',   'enum $NAME { $$$ }'),
        ('impl',   'impl $NAME { $$$ }'),
        ('trait',  'trait $NAME { $$$ }'),
    ],
    'go': [
        ('func',      'func $NAME($$$) { $$$ }'),
        ('struct',    'type $NAME struct { $$$ }'),
        ('interface', 'type $NAME interface { $$$ }'),
    ],
    'java': [
        ('class',  'class $NAME { $$$ }'),
        ('method', '$TYPE $NAME($$$) { $$$ }'),
    ],
    'c': [
        ('fn', '$TYPE $NAME($$$) { $$$ }'),
    ],
    'cpp': [
        ('fn',     '$TYPE $NAME($$$) { $$$ }'),
        ('class',  'class $NAME { $$$ }'),
        ('struct', 'struct $NAME { $$$ }'),
    ],
    'bash': [
        ('fn', '$NAME() { $$$ }'),
        ('fn', 'function $NAME() { $$$ }'),
        ('fn', 'function $NAME { $$$ }'),
    ],
    'ruby': [
        ('class', 'class $NAME; $$$ end'),
        ('def',   'def $NAME($$$); $$$ end'),
        ('def',   'def $NAME; $$$ end'),
    ],
    'lua': [
        ('fn',     'function $NAME($$$) $$$ end'),
        ('fn',     'local function $NAME($$$) $$$ end'),
        ('method', 'function $OBJ:$NAME($$$) $$$ end'),
    ],
}

patterns = PATTERNS.get(lang, [])
if not patterns:
    sys.exit(0)

results = []
seen = set()

for kind, pattern in patterns:
    try:
        r = subprocess.run(
            ['ast-grep', '--pattern', pattern, '--lang', lang, file, '--json'],
            capture_output=True, text=True, timeout=10
        )
        if not r.stdout.strip():
            continue
        matches = json.loads(r.stdout)
        if not isinstance(matches, list):
            matches = [matches]
        for m in matches:
            lineno = m.get('range', {}).get('start', {}).get('line', 0) + 1
            if lineno in seen:
                continue
            seen.add(lineno)
            first_line = m.get('lines', m.get('text', '')).split('\n')[0].strip()[:60]
            results.append((lineno, kind, first_line))
    except Exception:
        pass

results.sort(key=lambda x: x[0])
for lineno, kind, text in results:
    display = colorize(kind, text, lineno)
    print(display + '\t' + file + '\t' + str(lineno))
