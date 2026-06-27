#!/usr/bin/env python3
"""Pin the precise surplus equations in a daeMode-generated Dynawo model.

Dynawo's Modelica chain always uses OMC '+daeMode' and expects nbF == nbVars.
When a recovered/flattened EMT model is reported as
  "variables number N != equations number M"
this script localizes the (M - N) surplus equations by a maximum bipartite
matching of the generated residuals against the real variables, then prints the
Dulmage-Mendelsohn over-determined block (the canonical "which equations are
structurally surplus" set, independent of matching order).

Input: the generated <Model>_Dyn.cpp. It is kept in the build tree only if
DYNCompileModelicaModel.cpp's post-build removeAllInDirectory() is temporarily
disabled; otherwise re-run the model build with that line commented out.

Usage:  python3 diagnose_daemode_surplus.py <Model>_Dyn.cpp
Result for GFf_Load_InfBus: matched 196 / 200, surplus 4 -- all inside the
Grid_Feeding1 grid interface (3x series-inductor RL_converter/RL3 der + 1 PLL
Park rotation). See README.md for the full diagnosis and fix path.
"""
import re, sys
from collections import deque, Counter

sys.setrecursionlimit(100000)
src = open(sys.argv[1]).read()
body = re.search(r'::setFomc\(.*?\)\s*\{(.*?)\n\}', src, re.S).group(1)

# variable roles from the inline codegen comments: realVars[k] /* name ROLE */
role = {}
for k, name, tag in re.findall(
        r'realVars\[(\d+)\]\s*/\*\s*([^\*]+?)\s*(STATE\(\d+\)|variable)\s*\*/', src):
    k = int(k)
    role[k] = ('STATE' if tag.startswith('STATE') else 'VAR', name.strip())
# nbVars is the count of system real variables; Jacobian-only realVars sit above it
nbVars = int(re.search(r'data->nbVars\s*=\s*(\d+)', src).group(1))
role = {k: v for k, v in role.items() if k < nbVars}

# derivativesVars[k] -> der(state-name); map to the state's realVars index
dername = {int(k): n.strip() for k, n in
           re.findall(r'derivativesVars\[(\d+)\]\s*/\*\s*der\(([^\)]+)\)\s*STATE_DER', src)}
name2real = {v[1]: k for k, v in role.items()}

def refs(txt):
    rv = {int(x) for x in re.findall(r'realVars\[(\d+)\]', txt) if int(x) < nbVars}
    ds = {name2real[dername[int(d)]] for d in re.findall(r'derivativesVars\[(\d+)\]', txt)
          if dername.get(int(d)) in name2real}
    return rv | ds

# daeMode residuals are computed as '$P$DAEresN = ...;' then assigned 'f[i] = $P$DAEresN'
dae = {int(n): refs(e) for n, e in
       re.findall(r'\$P\$DAEres(\d+)\s*=(.*?);', body, re.S)}
adj = {}
for i, txt in re.findall(r'\bf\[(\d+)\]\s*=(.*?);\s*\n', body, re.S):
    m = re.search(r'\$P\$DAEres(\d+)', txt)
    adj[int(i)] = (dae.get(int(m.group(1)), set()) if m else refs(txt)) & set(role)

# Kuhn maximum matching (constrained equations first)
matchE, matchV = {}, {}
def aug(u, seen):
    for v in adj[u]:
        if v in seen:
            continue
        seen.add(v)
        if v not in matchV or aug(matchV[v], seen):
            matchV[v] = u; matchE[u] = v; return True
    return False
for u in sorted(adj, key=lambda u: len(adj[u])):
    aug(u, set())

print("equations %d  variables %d  matched %d  -> SURPLUS %d"
      % (len(adj), len(role), len(matchE), len(adj) - len(matchE)))

# Dulmage-Mendelsohn over-determined block: reach from unmatched eqs via
# alternating paths (traverse var -> its matched eq).
reachE = set(i for i in adj if i not in matchE)
reachV, dq = set(), deque(reachE)
while dq:
    for v in adj[dq.popleft()]:
        if v in reachV:
            continue
        reachV.add(v)
        if v in matchV and matchV[v] not in reachE:
            reachE.add(matchV[v]); dq.append(matchV[v])
sh = lambda n: n.replace('gFf_Load_InfBus.', '').replace('GFf_Load_InfBus_', '')
print("DM over-determined block: %d eqs / %d vars (surplus %d)"
      % (len(reachE), len(reachV), len(reachE) - len(reachV)))
print("over-det vars by subsystem:",
      dict(Counter(sh(role[v][1]).split('_')[0] + '_' +
                   (sh(role[v][1]).split('_')[1] if '_' in sh(role[v][1]) else '')
                   for v in reachV)))
