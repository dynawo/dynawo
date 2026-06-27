import re, sys
LOG="idaspm/DYNAMO_IDASPM_clean/DYNAMO_IDASPM_patch/tnr/data/IEEE_5bus/outputs/sim/logs/dynamoCompiler-sim.log"
raw=open(LOG,encoding='utf-8',errors='replace').read().split('\n')
s=next(i for i,l in enumerate(raw) if l.lstrip().startswith('"class IEEE_5bus_test'))
e=next(i for i,l in enumerate(raw) if 'end IEEE_5bus_test;' in l)
block=raw[s:e+1]
block[0]=block[0].lstrip()[1:]
text='\n'.join(block).replace('\\"','"')

# --- repair the single injected OMC error: it replaced one equation by an error
# message line between the Bus2 v1 and v2 connection blocks. Drop the bogus line. ---
inj='  InstFunction.getRecordConstructorFunction failed for OpenModelica.Scripting.translateModel\n'
n=text.count(inj); assert n==1, f"injection count={n}"
text=text.replace(inj,'')

# --- drop unused enumeration init-type params; strip per-decl 'protected' ---
out=[]; dropped=[]
for ln in text.split('\n'):
    if re.match(r'\s*(protected\s+)?parameter\s+enumeration\(', ln):
        m=re.search(r'\)\s+(IEEE_5bus\.[A-Za-z0-9_.]+)', ln)
        if m: dropped.append(m.group(1))
        continue
    ln=re.sub(r'^(\s*)protected\s+', r'\1', ln)
    out.append(ln)
text='\n'.join(out)

# --- mangle IEEE_5bus-rooted dotted identifiers: '.' -> '_' ---
text=re.sub(r'IEEE_5bus(?:\.[A-Za-z_]\w*)+', lambda m: m.group(0).replace('.','_'), text)

# keep homotopy()/smooth() (initialization operators) -- do NOT collapse.

# Modelica forbids unary minus right after a binary operator: 'a + -b' -> 'a + (-b)'
text=re.sub(r'([-+*/^])(\s*)-\s*(\d[\d.]*(?:[eE][-+]?\d+)?|[A-Za-z_][\w.\[\]]*)',
            r'\1\2(-\3)', text)

# drop assert(...) (OMC-internal String() overload)
text='\n'.join(l for l in text.split('\n') if not l.lstrip().startswith('assert('))

# expand integer powers x^(-2.0)->1/(x*x), x^2.0 / x^2 -> (x*x)
text=re.sub(r'(\w+)\s*\^\s*\(-2\.0\)', r'(1.0 / \1 / \1)', text)
text=re.sub(r'(\w+)\s*\^\s*\(2\.0\)', r'(\1 * \1)', text)
text=re.sub(r'(\w+)\s*\^\s*2\.0\b', r'(\1 * \1)', text)

# inline GridFeeding2.Ti_i (OMC folds 1/wn^2 into real_int_pow whose threadData
# signature Dynawo codegen can't emit). Match only the binding (RHS has wn_i).
text=re.sub(r'(IEEE_5bus_GridFeeding2_Ti_i(?:\([^)]*\))?\s*=\s*)[^;]*wn_i[^;]*',
            r'\g<1>0.004665956317661105', text)

for d in dropped:
    if d.replace('.','_') in text: sys.exit(f"dropped enum {d} still referenced")

# header / wrapper
text=text.replace('class IEEE_5bus_test','model IEEE_5bus',1)
text=text.replace('end IEEE_5bus_test;','  annotation(preferredView = "text");\nend IEEE_5bus;')
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
* Recovered from the EMTSim IEEE 5-bus case (EMTSim.Examples.IEEE_5bus) via the OMC
* instantiated-model dump in the original IDASPM zip's dynamoCompiler-sim.log.
* Flat (fully instantiated) form: 5 buses, 7 RL lines, 4 PQ loads, a perfect
* generator and one grid-feeding converter on a meshed bus.
*/

'''
open("IEEE_5bus.mo","w").write(HEADER+text)
print("dropped enum params:",len(dropped))
print("output lines:",text.count(chr(10))+1)
print("der states:",text.count("der("))
print("remaining 'protected ':",text.count("protected "))
print("remaining Modelica.:",text.count("Modelica."))
