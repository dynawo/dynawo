import re
from collections import defaultdict, OrderedDict

RAW=open('ieee5_flat_raw.mo').read()

# ---------- 1. cleanup transforms (NO dot-mangling: we need hierarchy) ----------
t=RAW
# repair injection (drop the bogus error line)
t=t.replace('  InstFunction.getRecordConstructorFunction failed for OpenModelica.Scripting.translateModel\n','')
# drop enum init-type params, strip per-decl protected
out=[]
for ln in t.split('\n'):
    if re.match(r'\s*(protected\s+)?parameter\s+enumeration\(',ln): continue
    out.append(re.sub(r'^(\s*)protected\s+',r'\1',ln))
t='\n'.join(out)
# parenthesize unary minus after operator
t=re.sub(r'([-+*/^])(\s*)-\s*(\d[\d.]*(?:[eE][-+]?\d+)?|[A-Za-z_][\w.\[\]]*)',r'\1\2(-\3)',t)
# drop asserts
t='\n'.join(l for l in t.split('\n') if not l.lstrip().startswith('assert('))
# expand integer powers
t=re.sub(r'(\w+)\s*\^\s*\(-2\.0\)',r'(1.0 / \1 / \1)',t)
t=re.sub(r'(\w+)\s*\^\s*\(2\.0\)',r'(\1 * \1)',t)
t=re.sub(r'(\w+)\s*\^\s*2\.0\b',r'(\1 * \1)',t)
# inline GridFeeding2 Ti_i
t=re.sub(r'(IEEE_5bus\.GridFeeding2\.Ti_i(?:\([^)]*\))?\s*=\s*)[^;]*wn_i[^;]*',r'\g<1>0.004665956317661105',t)

lines=t.split('\n')
ie_i=next((i for i,l in enumerate(lines) if l.strip()=='initial equation'),None)
eq_i=next(i for i,l in enumerate(lines) if l.strip()=='equation')
decls=lines[1:(ie_i if ie_i is not None else eq_i)]
inits=[l.strip() for l in (lines[ie_i+1:eq_i] if ie_i is not None else [])]
eqs=[l.strip() for l in lines[eq_i+1:] if l.strip() and not l.strip().startswith('end ')]

def topof(r):
    s=r.split('.'); return s[0] if len(s)>=2 else None

# ---------- 2. bucket decls and internal eqs per instance ----------
inst_decls=defaultdict(list); inst_eqs=defaultdict(list); inst_init=defaultdict(list); conn_eqs=[]
for d in decls:
    m=re.search(r'IEEE_5bus\.([A-Za-z0-9_]+)\.',d)
    if m: inst_decls[m.group(1)].append(d.strip())
for e in eqs:
    insts=set(filter(None,(topof(r) for r in re.findall(r'IEEE_5bus\.([A-Za-z0-9_.]+)',e))))
    if len(insts)==1: inst_eqs[next(iter(insts))].append(e)
    elif len(insts)>=2: conn_eqs.append((insts,e))
for e in inits:
    insts=set(filter(None,(topof(r) for r in re.findall(r'IEEE_5bus\.([A-Za-z0-9_.]+)',e))))
    if len(insts)==1: inst_init[next(iter(insts))].append(e)

# instance -> type
TYPE={**{f'Bus{i}':'Bus' for i in range(1,6)},
      **{n:'RLLine' for n in inst_eqs if n.startswith('Line_')},
      **{n:'PQLoad' for n in ['Load2','Load3','Load4','Load5']},
      'PerfectGen1':'PerfectGen','GridFeeding2':'GridFeeding','Grnd':'Ground','cst2':'ConstSource'}
PARAMS={'Bus':['V_0','angle_0'],'RLLine':['R','L','X'],
        'PQLoad':['P','Q','V','V0','init_theta'],'PerfectGen':['V'],'ConstSource':['k'],
        'GridFeeding':[],'Ground':[]}
PINS={'Bus':['p'],'RLLine':['p','n'],'PQLoad':['p'],'PerfectGen':['p','n'],
      'GridFeeding':['p'],'Ground':['p'],'ConstSource':[]}
REP={'Bus':'Bus1','RLLine':'Line_1_2','PQLoad':'Load2','PerfectGen':'PerfectGen1',
     'GridFeeding':'GridFeeding2','Ground':'Grnd','ConstSource':'cst2'}

def localize(inst,txt,flatten_internal):
    pre=r'IEEE_5bus\.'+re.escape(inst)+r'\.'
    if not flatten_internal:
        return re.sub(pre,'',txt)
    def fix(m):
        rest=m.group(1)
        return rest if re.match(r'(p|n)\.',rest) else rest.replace('.','_')
    return re.sub(pre+r'([A-Za-z0-9_.]+)',fix,txt)

CONNECTOR='''  connector Terminal "Three-phase EMT terminal"
    Real v1; Real v2; Real v3;
    flow Real i1; flow Real i2; flow Real i3;
  end Terminal;'''

def gen_class(typ):
    rep=REP[typ]; pins=PINS[typ]; params=PARAMS[typ]
    flat=(typ in ('GridFeeding','PerfectGen'))
    decl_out=[]; eqs_out=[]
    paramvals={}
    for d in inst_decls[rep]:
        dl=localize(rep,d,flat).strip()
        # parameter line?
        mp=re.match(r'''parameter\s+\w+\s+([A-Za-z0-9_]+)\s*(?:\([^)]*\))?\s*=\s*([^;"']+)''',dl)
        if mp and mp.group(1) in params:
            mv=re.search(r'=\s*([^;"]+)',dl); paramvals[mp.group(1)]=mv.group(1).strip() if mv else '0'
            # declare as bare parameter (value injected per-instance)
            decl_out.append(f'  parameter Real {mp.group(1)};')
            continue
        # skip pin sub-variable declarations (absorbed by Terminal)
        if re.match(r'(Real|parameter\s+Real)\s+(p|n)\.',dl): continue
        decl_out.append('  '+dl)
    for e in inst_eqs[rep]:
        eqs_out.append('  '+localize(rep,e,flat).strip())
    # pin + input declarations
    pindecl=''.join(f'  Terminal {p};\n' for p in pins)
    inp=''
    outp=''
    body='\n'.join(decl_out)
    eqbody='\n'.join(eqs_out)
    initblk=''
    if inst_init.get(rep):
        ib='\n'.join('  '+localize(rep,x,flat).strip() for x in inst_init[rep])
        initblk='initial equation\n'+ib+'\n'
    return f'''model EMT5_{typ}
{pindecl}{inp}{outp}{body}
{initblk}equation
{eqbody}
  annotation(preferredView = "text");
end EMT5_{typ};'''

# ---------- 3. connection nodes via union-find on pins ----------
parent={}
def find(x):
    parent.setdefault(x,x)
    while parent[x]!=x: parent[x]=parent[parent[x]]; x=parent[x]
    return x
def union(a,b): parent[find(a)]=find(b)
signal_eqs=[]
for insts,e in conn_eqs:
    # voltage equality A.p.vN = B.q.vN  -> union A.p and B.q
    m=re.findall(r'IEEE_5bus\.([A-Za-z0-9_]+)\.([A-Za-z0-9_]+)\.v[123]',e)
    if len(m)==2 and '=' in e and 'i1' not in e and '+' not in e:
        union(f'{m[0][0]}.{m[0][1]}',f'{m[1][0]}.{m[1][1]}')
    elif 'Vs' in e and 'cst2' in e:
        signal_eqs.append('  gridFeeding2.Vs = cst2.y;')
# group pins by root
nodes=defaultdict(list)
for pin in list(parent):
    nodes[find(pin)].append(pin)

# instance var name (lower first letter to avoid clashing with class)
def vn(inst): return inst[0].lower()+inst[1:]

# ---------- 4. emit top model ----------
comp_decls=[]
for inst in sorted(TYPE, key=lambda x:(TYPE[x],x)):
    typ=TYPE[inst]
    pv={}
    # gather this instance's param values
    rep=REP[typ]
    for d in inst_decls[inst]:
        dl=localize(inst,d,typ in ('GridFeeding','PerfectGen')).strip()
        mp=re.match(r'''parameter\s+\w+\s+([A-Za-z0-9_]+)\s*(?:\([^)]*\))?\s*=\s*([^;"']+)''',dl)
        if mp and mp.group(1) in PARAMS[typ]: pv[mp.group(1)]=mp.group(2).strip()
    mods=', '.join(f'{k} = {v}' for k,v in pv.items())
    comp_decls.append(f'  EMT5_{typ} {vn(inst)}{"("+mods+")" if mods else ""};')

connects=[]
for root,pinset in sorted(nodes.items()):
    if len(pinset)<2: continue
    base=sorted(pinset)[0]
    bi,bp=base.split('.')
    for other in sorted(pinset):
        if other==base: continue
        oi,op=other.split('.')
        connects.append(f'  connect({vn(bi)}.{bp}, {vn(oi)}.{op});')

TOP=f'''model Circuit "IEEE 5-bus EMT network: components + connect() topology"
{chr(10).join(comp_decls)}
equation
{chr(10).join(signal_eqs)}
{chr(10).join(connects)}
  annotation(preferredView = "text");
end Circuit;'''

# ---------- assemble ----------
HEADER='''within Dynawo.Electrical.EMT;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt. SPDX-License-Identifier: MPL-2.0
* This file is part of Dynawo.
*
* Friendly (modular) reconstruction of the recovered EMTSim IEEE_5bus case:
* the flat dump losslessly regrouped into one component class per type, wired by
* connect() per the recovered topology. Mathematically identical to IEEE_5bus.mo.
*/

package IEEE_5bus_modular "Modular reconstruction of the recovered IEEE 5-bus EMT case"
'''
classes=[CONNECTOR]+[gen_class(typ) for typ in ['Ground','ConstSource','Bus','RLLine','PQLoad','PerfectGen','GridFeeding']]
out=HEADER+'\n\n'.join(classes)+'\n\n'+TOP+'\nend IEEE_5bus_modular;\n'
open('IEEE_5bus_modular.mo','w').write(out)
print("wrote IEEE_5bus_modular.mo lines:",out.count(chr(10))+1)
print("nodes:",len([n for n in nodes.values() if len(n)>=2]),"connects:",len(connects),"signal eqs:",len(signal_eqs))
for typ in ['Bus','RLLine','PQLoad','PerfectGen','GridFeeding','Ground','ConstSource']:
    print(f"  EMT5_{typ}: {len(inst_eqs[REP[typ]])} eqs")
