#!/usr/bin/env python3
"""Decompose an OMC flattened EMTSim model back into its component hierarchy.

The flattened dump (the de-escaped `class <Name>_test ... end` block from a
dynamoCompiler.log) keeps the original instance hierarchy in its DOTTED names:
`<Top>.<instance>.<subinstance>...<pin>.<var>`. This tool rebuilds the tree,
buckets every parameter and equation to its owning instance, classifies each
top-level instance against the EMT-library component signatures, and extracts the
connection (multi-instance) equations — i.e. it recovers "how the model was
originally assembled" so it can be re-modularised into proper Modelica components
instead of one flat blob.

Usage:  python3 decompose_flat_model.py gff_flat_raw.mo [TopName]
Input is the FLAT DOTTED dump (before the recover_gff.py dot->underscore mangle).
"""
import re, sys
from collections import defaultdict

PATH = sys.argv[1]
t = open(PATH).read()
lines = t.split('\n')
TOP = sys.argv[2] if len(sys.argv) > 2 else re.search(r'class (\w+?)_test', t).group(1)
ROOT = re.escape(TOP) + r'\.'

eq_i = next(i for i, l in enumerate(lines) if l.strip() in ('equation', 'initial equation'))
decls, eqs = lines[1:eq_i], [l for l in lines[eq_i + 1:] if l.strip() and not l.strip().startswith('end ')]

def refs(s):
    return re.findall(ROOT + r'([A-Za-z0-9_.]+)', s)

def top_of(ref):
    segs = ref.split('.')
    return segs[0] if len(segs) >= 2 else None

# ---- instance tree (top-level instances and their immediate children) ----
children = defaultdict(set)
for path in set(r for l in decls + eqs for r in refs(l)):
    segs = path.split('.')
    if len(segs) >= 2:
        children[segs[0]].add(segs[1])

# ---- per-instance params (name -> value) and internal-equation count ----
params = defaultdict(dict)
for l in decls:
    m = re.match(r'\s*parameter\s+\w+\s+' + ROOT + r'([A-Za-z0-9_]+)\.([A-Za-z0-9_.]+?)(?:\([^)]*\))?\s*=\s*([^;"]+)', l)
    if m:
        params[m.group(1)][m.group(2)] = m.group(3).strip()

internal = defaultdict(list); connections = []
for e in eqs:
    insts = set(filter(None, (top_of(r) for r in refs(e))))
    if len(insts) == 1:
        internal[next(iter(insts))].append(e.strip())
    elif len(insts) >= 2:
        connections.append((frozenset(insts), e.strip()))

# ---- classify a top-level instance by its children / equation signature ----
def classify(inst):
    ch = children[inst]; eqtxt = ' '.join(internal.get(inst, []))
    if {'p', 'n', 'i', 'v', 'R', 'L'} <= ch: return 'RLBranchDisym (3-ph R-L series branch)'
    if 'C_PQLoad' in ch and 'i_LC' in ch:    return 'PQ load (R//L//C, dq init)'
    if 'signalSource1' in ch:                return 'SignalVoltage / sine source (infinite bus)'
    if ch == {'p'}:                           return 'Ground'
    if {'V0', 'angle_0', 'p'} <= ch:          return 'Bus'
    if {'height', 'offset', 'startTime', 'y'} <= ch: return 'Modelica.Blocks.Sources.Step'
    if ch == {'k', 'y'}:                      return 'Modelica.Blocks.Sources.Constant'
    if 'CurrentControl' in ch and 'VoltageControl' in ch: return 'GRID-FORMING converter (composite)'
    if 'CurrentControl' in ch and 'PLL' in ch:            return 'GRID-FEEDING converter (composite)'
    if 'getRecordConstructorFunction' in ch:  return '(OMC error artifact - not a component)'
    return '? (inspect)'

print(f"# Decomposition of flat model: {TOP}\n")
print(f"declarations: {len(decls)}   equations: {len(eqs)}   "
      f"connection eqs: {len(connections)}   top-level instances: {len(children)}\n")
print("## Top-level components\n")
for inst in sorted(children):
    p = params.get(inst, {})
    pstr = ', '.join(f'{k}={v}' for k, v in list(p.items())[:6])
    print(f"### {inst}")
    print(f"   type      : {classify(inst)}")
    print(f"   children  : {sorted(children[inst])}")
    print(f"   #params   : {len(p)}   #internal eqs: {len(internal.get(inst, []))}")
    if pstr: print(f"   params    : {pstr}{' ...' if len(p) > 6 else ''}")
    print()

# ---- connection topology: group connection equations by instance-pair ----
print("## Connection topology (electrical nodes / wiring)\n")
pairs = defaultdict(int)
for insts, _ in connections:
    pairs[tuple(sorted(insts))] += 1
for pair, n in sorted(pairs.items(), key=lambda x: -x[1]):
    print(f"   {' <-> '.join(pair):60s} {n} eqs")
