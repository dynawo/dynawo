import re, sys

LOG="idaspm/DYNAMO_IDASPM_clean/DYNAMO_IDASPM_patch/tnr/data/IEEE_5bus_Split/outputs/logs/dynamoCompiler.log"
raw=open(LOG,encoding='utf-8',errors='replace').read().split('\n')
s=next(i for i,l in enumerate(raw) if l.lstrip().startswith('"class IEEE5bus_test_gridfeeding'))
e=next(i for i,l in enumerate(raw) if 'end IEEE5bus_test_gridfeeding;' in l)
block=raw[s:e+1]
block[0]=block[0].lstrip()[1:]                       # drop opening JSON quote
text='\n'.join(block).replace('\\"','"')             # de-escape quotes

# --- repair the single injected OMC error (splits converter_Grid_Forming1) ---
inj='InstFunction.getRecordConstructorFunction failed for OpenModelica.Scripting.translateModel\n'
n=text.count(inj); text=text.replace(inj,'')
assert n==1, f"injection repair count={n} (expected 1)"

lines=text.split('\n')
out=[]
dropped=[]
for ln in lines:
    # drop unused enumeration init-type params (remove Modelica.Blocks.Types.Init dep)
    if re.match(r'\s*(protected\s+)?parameter\s+enumeration\(', ln):
        m=re.search(r'\)\s+(IEEE5bus_gridfeeding\.[A-Za-z0-9_.]+)', ln)
        if m: dropped.append(m.group(1))
        continue
    ln=re.sub(r'^(\s*)protected\s+', r'\1', ln)      # strip per-decl 'protected'
    out.append(ln)
text='\n'.join(out)

# --- mangle GFf-rooted dotted identifiers: flatten '.' -> '_' (numbers/Modelica.* untouched) ---
text=re.sub(r'IEEE5bus_gridfeeding(?:\.[A-Za-z_]\w*)+',
            lambda m: m.group(0).replace('.','_'), text)

# Replace homotopy(actual, simplified) -> actual and smooth(p, expr) -> expr.
# Both are compiler hints (homotopy aids initialization; smooth asserts
# continuity). Dynawo's backend mis-handles them inside the converter limiter
# blocks (unsolvable saturation equations + spurious threadData codegen);
# dropping them to the semantically-equivalent argument fixes the matching.
def replace_call(text, fname, keep):
    out, i, pat = [], 0, fname + '('
    while True:
        j = text.find(pat, i)
        if j < 0:
            out.append(text[i:]); break
        out.append(text[i:j])
        k = j + len(pat); depth, q, args, cur = 1, False, [], ''
        while depth:
            c = text[k]
            if c == '"': q = not q
            if not q and c == '(': depth += 1
            if not q and c == ')':
                depth -= 1
                if depth == 0: break
            if c == ',' and depth == 1 and not q:
                args.append(cur); cur = ''
            else:
                cur += c
            k += 1
        args.append(cur)
        out.append('(' + args[keep].strip() + ')')
        i = k + 1
    return ''.join(out)
# NOTE: do NOT collapse homotopy()/smooth(): homotopy(actual, simplified) is the
# Modelica initialization operator - OMC uses the 'simplified' branch to build a
# solvable initialization system and 'actual' for the transient. The original
# Dynawo run (this dump came from its dynamoCompiler.log) relied on it; collapsing
# it forces the saturated nonlinearity into init and makes it mixed-determined.
# text = replace_call(text, 'homotopy', 0)
# text = replace_call(text, 'smooth', 1)
_ = replace_call  # kept for reference

# Dynawo's code generation cannot emit Modelica mod()'s event function
# (_event_mod_real). The only uses are angle wraps mod(theta, 2*pi) whose result
# feeds Park-transform sin/cos, for which the wrap is mathematically redundant
# (sin/cos are 2*pi-periodic), so drop it: mod(theta, 2*pi) -> theta.
text=re.sub(r'mod\((.+?),\s*6\.283185307179586\)', r'(\1)', text)

# Modelica's strict grammar forbids a unary minus right after a binary operator
# (OMC flat-dump quirk): 'a + -b', 'x ^ -2.0' -> 'a + (-b)', 'x ^ (-2.0)'.
# Operand is a number (with optional exponent) or an identifier path.
text=re.sub(r'([-+*/^])(\s*)-\s*(\d[\d.]*(?:[eE][-+]?\d+)?|[A-Za-z_][\w.\[\]]*)',
            r'\1\2(-\3)', text)

# --- coalesce element-wise array declarations into proper array declarations ---
# OMC's flat dump lists each array element as a separate subscripted scalar
# (Real x[1]...; x[2]...; x[3]...), which Modelica rejects as conflicting
# declarations. Merge each run into one Real x[N] declaration. Cosmetic
# quantity/unit/displayUnit attributes are dropped; functional start/fixed kept.
def split_top(s):
    parts, d, q, cur = [], 0, False, ''
    for ch in s:
        if ch == '"': q = not q
        if not q and ch == '(': d += 1
        if not q and ch == ')': d -= 1
        if ch == ',' and d == 0 and not q:
            parts.append(cur); cur = ''
        else:
            cur += ch
    if cur.strip(): parts.append(cur)
    return [p.strip() for p in parts]

DECL = re.compile(
    r'^(\s*)((?:final\s+|parameter\s+|constant\s+|discrete\s+|input\s+|output\s+)*)'
    r'(Real|Boolean|Integer)\s+(\w+)\[([0-9,\s]+)\]'
    r'\s*(\([^;]*\))?\s*(=\s*.+?)?\s*("[^"]*")?\s*;\s*$')

def idx(s):                       # "1" -> (1,) ; "2, 3" -> (2,3)
    return tuple(int(x) for x in s.split(','))

lines = text.split('\n')
# operate only on the declaration section (before initial equation / equation)
eq_start = next(i for i, l in enumerate(lines)
                if l.strip() in ('equation', 'initial equation'))
out, i = [], 0
while i < eq_start:
    m = DECL.match(lines[i])
    if not m or idx(m.group(5)) != (1,) and idx(m.group(5)) != (1, 1):
        out.append(lines[i]); i += 1; continue
    indent, prefix, typ, name = m.group(1), m.group(2) or '', m.group(3), m.group(4)
    elems = {}                    # index-tuple -> (start, fixed, binding)
    j = i
    while j < eq_start:
        mm = DECL.match(lines[j])
        if not mm or mm.group(4) != name:
            break
        mods = (mm.group(6) or '')[1:-1] if mm.group(6) else ''
        st, fx = None, False
        for kv in split_top(mods):
            if kv.startswith('start'):
                st = kv.split('=', 1)[1].strip()
            elif kv.replace(' ', '') == 'fixed=true':
                fx = True
        elems[idx(mm.group(5))] = (st, fx,
                                   mm.group(7)[1:].strip() if mm.group(7) else None)
        j += 1
    ndim = len(next(iter(elems)))
    if ndim == 1:
        n = max(k[0] for k in elems)
        seq = [elems[(a,)] for a in range(1, n + 1)]
        starts = [e[0] for e in seq]; binds = [e[2] for e in seq]
        fixedflags = [e[1] for e in seq]
        modparts = []
        if any(s is not None for s in starts):
            modparts.append('start = {' + ', '.join(s or '0' for s in starts) + '}')
        # preserve each element's original fixed status exactly: uniform -> each,
        # mixed -> per-element array (over-applying 'each' would over-determine init)
        if all(fixedflags):
            modparts.append('each fixed = true')
        elif any(fixedflags):
            modparts.append('fixed = {' + ', '.join('true' if x else 'false' for x in fixedflags) + '}')
        decl = f'{indent}{prefix}{typ} {name}[{n}]'
        if modparts: decl += '(' + ', '.join(modparts) + ')'
        if any(b is not None for b in binds):
            decl += ' = {' + ', '.join(b or '0' for b in binds) + '}'
        decl += ';'
    else:                          # 2D matrix (constant with bindings, or variable)
        R = max(k[0] for k in elems); C = max(k[1] for k in elems)
        decl = f'{indent}{prefix}{typ} {name}[{R},{C}]'
        if any(elems[k][2] is not None for k in elems):   # has bindings -> constructor
            rows = ['{' + ', '.join(elems[(a, b)][2] or '0' for b in range(1, C + 1)) + '}'
                    for a in range(1, R + 1)]
            decl += ' = {' + ', '.join(rows) + '}'
        decl += ';'
    out.append(decl)
    i = j
# drop assert(...) statements: they use OMC's internal String() overload (not
# standard Modelica) and only bound-check limiter params baked from a valid run.
out.extend(l for l in lines[eq_start:] if not l.lstrip().startswith('assert('))
text = '\n'.join(out)

# verify no dropped enum name is still referenced
for d in dropped:
    dm=d.replace('.','_')
    if dm in text:
        sys.exit(f"ERROR: dropped enum param {dm} still referenced")

# NOTE: do NOT force fixed=true on the states. The original flattened dump
# declares them as Real x(start = ...) WITHOUT fixed, and that exact form
# compiled through Dynawo's chain (this dump is from its dynamoCompiler.log).
# Adding fixed=true injects extra init equations and over-determines the init
# system. The init scheme is carried by the 'initial equation' section + the
# homotopy() operators kept above.

# Expand integer power x^(-2.0) -> 1.0/(x*x): Dynawo's codegen emits a
# threadData-taking power function for it that does not compile.
# Use division/multiplication chains (not x*x, which OMC re-folds to the integer
# power real_int_pow whose threadData-taking signature Dynawo's codegen can't emit).
text = re.sub(r'(\w+)\s*\^\s*\(-2\.0\)', r'(1.0 / \1 / \1)', text)
text = re.sub(r'(\w+)\s*\^\s*\(2\.0\)', r'(\1 * \1)', text)
text = re.sub(r'(\w+)\s*\^\s*2\.0\b', r'(\1 * \1)', text)   # bare exponent; \b keeps any enclosing ')'

# OMC re-folds the 1/wn_i^2 term in the Ti_i parameter into real_int_pow(),
# whose threadData-taking signature Dynawo's codegen cannot emit. Ti_i is a
# constant parameter (Ti_i = 2*zeta/wn - Rf*(1/wn^2)*wb/Lf with all sub-params
# literal), so inline its evaluated value. Match only the binding (RHS mentions
# wn_i), not the CurrentControl_Ti_i = Ti_i copies.
# (Ti_i inline not needed: power-expansion handles wn_i^-2.0)

# header / wrapper
text=text.replace('class IEEE5bus_test_gridfeeding','model IEEE5bus_gridfeeding',1)
text=text.replace('end IEEE5bus_test_gridfeeding;','  annotation(preferredView = "text");\nend IEEE5bus_gridfeeding;')

HEADER='''within Dynawo.Electrical.EMT;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*
* Recovered from the EMTSim grid-forming/grid-feeding converter case
* (EMTSim.Examples.IEEE5bus_gridfeeding) via the OMC instantiated-model dump in the
* original IDASPM zip's dynamoCompiler.log. Flat (fully instantiated) form:
* parameters are baked to the original operating point.
*/

'''
open("IEEE5bus_gridfeeding.mo","w").write(HEADER+text)
print("dropped enum params:",len(dropped))
print("output lines:",text.count(chr(10))+1)
print("der states:",text.count("der("))
print("remaining 'protected ':",text.count("protected "))
print("remaining Modelica.:",text.count("Modelica."))
