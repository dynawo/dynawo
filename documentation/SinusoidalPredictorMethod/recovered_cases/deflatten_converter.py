import re,json
from collections import defaultdict
RAW=open('ieee5_flat_raw.mo').read()
ROOT='IEEE_5bus'; CONV='GridFeeding2'; PRE=ROOT+'.'+CONV+'.'
PVAL=json.load(open('gf2_params.json'))

t=RAW.replace('  InstFunction.getRecordConstructorFunction failed for OpenModelica.Scripting.translateModel\n','')
t='\n'.join(ln for ln in t.split('\n') if not re.match(r'\s*(protected\s+)?parameter\s+enumeration\(',ln))
t=re.sub(r'^(\s*)protected\s+',r'\1',t,flags=re.M)
t=re.sub(r'([-+*/^])(\s*)-\s*(\d[\d.]*(?:[eE][-+]?\d+)?|[A-Za-z_][\w.\[\]]*)',r'\1\2(-\3)',t)
t='\n'.join(l for l in t.split('\n') if not l.lstrip().startswith('assert('))
for pat,rep in [(r'(\w+)\s*\^\s*\(-2\.0\)',r'(1.0 / \1 / \1)'),(r'(\w+)\s*\^\s*\(2\.0\)',r'(\1 * \1)'),(r'(\w+)\s*\^\s*2\.0\b',r'(\1 * \1)')]:
    t=re.sub(pat,rep,t)
lines=t.split('\n')
ie_i=next((i for i,l in enumerate(lines) if l.strip()=='initial equation'),None)
eq_i=next(i for i,l in enumerate(lines) if l.strip()=='equation')
decls=lines[1:(ie_i if ie_i is not None else eq_i)]
inits=[l.strip() for l in (lines[ie_i+1:eq_i] if ie_i is not None else [])]
eqs=[l.strip() for l in lines[eq_i+1:] if l.strip() and not l.strip().startswith('end ')]

subnames=set(re.findall(re.escape(PRE)+r'([A-Za-z0-9_]+)\.[A-Za-z0-9_]+',t))
convvars=set()
for d in decls:
    m=re.match(r'\s*Real\s+'+re.escape(PRE)+r'([A-Za-z0-9_]+)(\([^)]*\))?\s*(=|;|")',d)
    if m and m.group(1) not in PVAL and m.group(1) not in subnames: convvars.add(m.group(1))

def subst_params(txt):
    return re.sub(re.escape(PRE)+r'([A-Za-z0-9_]+(?:\[\d+\])?)\b',
                  lambda m: repr(PVAL[m.group(1)]) if m.group(1) in PVAL else m.group(0), txt)

sub_decls=defaultdict(list); sub_eqs=defaultdict(list); sub_init=defaultdict(list); couplings=[]
for d in decls:
    m=re.search(re.escape(PRE)+r'([A-Za-z0-9_]+)\.',d)
    if m: sub_decls[m.group(1)].append(d.strip())
def bucket(coll,store):
    for e in coll:
        if set(re.findall(re.escape(ROOT)+r'\.([A-Za-z0-9_]+)',e))-{CONV}: continue
        ss=set(re.findall(re.escape(PRE)+r'([A-Za-z0-9_]+)\.',e))
        if not ss: continue
        (store[next(iter(ss))] if len(ss)==1 else couplings).append(e if len(ss)==1 else (ss,e))
bucket(eqs,sub_eqs); bucket(inits,sub_init)
SUBS=sorted(sub_eqs)
pins=defaultdict(set)
for m in re.findall(re.escape(PRE)+r'([A-Za-z0-9_]+)\.(p|n)\.(v1|i1)',t): pins[m[0]].add(m[1])
def vn(s): return s[0].lower()+s[1:]

def loc_own(sub,txt):   # strip this sub's prefix (flatten internal dots, keep pins), subst params
    txt=subst_params(txt)
    return re.sub(re.escape(PRE+sub+'.')+r'([A-Za-z0-9_.]+)',
                  lambda m:(m.group(1) if re.match(r'(p|n)\.',m.group(1)) else m.group(1).replace('.','_')),txt)
def loc_ext(txt):       # localise a reference to ANOTHER sub/convvar for composite scope
    txt=subst_params(txt)
    txt=re.sub(re.escape(PRE)+r'([A-Za-z0-9_]+)\.([A-Za-z0-9_.]+)',
               lambda m:vn(m.group(1))+'.'+(m.group(2) if re.match(r'(p|n)\.',m.group(2)) else m.group(2).replace('.','_')),txt)
    for v in convvars: txt=re.sub(re.escape(PRE)+v+r'\b',v,txt)
    return txt.replace(ROOT+'.','')

wires=[]
CONNECTOR='''  connector Terminal "Three-phase EMT terminal"
    Real v1; Real v2; Real v3;
    flow Real i1; flow Real i2; flow Real i3;
  end Terminal;'''
def gen_sub(sub):
    raw_decls=[loc_own(sub,d).strip() for d in sub_decls.get(sub,[])]
    raw_eqs=[loc_own(sub,e).strip() for e in sub_eqs.get(sub,[])]
    raw_init=[loc_own(sub,x).strip() for x in sub_init.get(sub,[])]
    def parse_alias(line):
        line=re.sub(r'\([^()]*\)','',line.strip().rstrip(';')).strip()   # drop attribute modifiers
        if line.count('=')!=1: return None
        L,R=[x.strip() for x in line.split('=')]
        L=re.sub(r'^(?:parameter\s+)?Real\s+','',L).strip()
        extp=re.compile(re.escape(PRE)+r'[A-Za-z0-9_.]+$'); locp=re.compile(r'[A-Za-z0-9_]+$')
        if locp.fullmatch(L) and extp.fullmatch(R): return (L,R)
        if extp.fullmatch(L) and locp.fullmatch(R): return (R,L)
        return None
    alias={}
    for coll in (raw_decls,raw_eqs):
        for x in coll:
            a=parse_alias(x)
            if a: alias[a[0]]=a[1]
    inames=set(alias)
    aliasre=None  # use parse_alias below
    decl_out=[]
    for d in raw_decls:
        if re.match(r'(Real|parameter\s+Real|parameter\s+Boolean)\s+(p|n)\.',d): continue
        m=re.match(r'(?:Real|parameter\s+Real)\s+([A-Za-z0-9_]+)\b',d)
        if m and m.group(1) in inames: continue        # drop decl of aliased name (becomes input)
        decl_out.append('  '+d)
    eqs_out=['  '+e for e in raw_eqs if not parse_alias(e)]
    init_out=['  '+x for x in raw_init]
    # convvars used directly (not already an input) -> input
    body='\n'.join(decl_out+eqs_out+init_out)
    for cv in sorted(convvars):
        if re.search(re.escape(PRE)+cv+r'\b',body) and cv not in inames:
            inames.add(cv); alias.setdefault(cv, PRE+cv)
    # emit inputs + wires
    for nm in sorted(inames):
        decl_out.insert(0,f'  input Real {nm};')
        wires.append(f'  {vn(sub)}.{nm} = {loc_ext(alias[nm])};')
    def strip_cv(x):
        for cv in convvars: x=re.sub(re.escape(PRE)+cv+r'\b',cv,x)
        return x
    decl_out=[strip_cv(x) for x in decl_out]; eqs_out=[strip_cv(x) for x in eqs_out]; init_out=[strip_cv(x) for x in init_out]
    pindecl=''.join(f'  Terminal {p};\n' for p in sorted(pins[sub]))
    initblk=('initial equation\n'+'\n'.join(init_out)+'\n') if init_out else ''
    return f'''model {sub} "GridFeeding sub-component"
{pindecl}{chr(10).join(decl_out)}
{initblk}equation
{chr(10).join(eqs_out)}
  annotation(preferredView = "text");
end {sub};'''

classes=[gen_sub(s) for s in SUBS]

# composite electrical connects + signal-equation couplings + convvar eqs
parent={}
def find(x):
    parent.setdefault(x,x)
    while parent[x]!=x: parent[x]=parent[parent[x]];x=parent[x]
    return x
signal_eqs=[]
pinref=re.compile(re.escape(CONV)+r'\.((?:[A-Za-z0-9_]+\.)?(?:p|n))\.v[123]')
for ss,e in couplings:
    m=pinref.findall(e)
    if len(m)==2 and e.count('=')==1 and ' + ' not in e and 'der(' not in e and not re.search(r'\.i[123]',e):
        parent[find(m[0])]=find(m[1])
    elif re.search(r'\.i[123]',e) and ('+' in e or e.strip().startswith('0.0 =')):
        continue   # current KCL -> realised by connect
    else:
        signal_eqs.append('  '+loc_ext(e).strip())
convvar_eqs=[]
for e in eqs:
    if set(re.findall(re.escape(ROOT)+r'\.([A-Za-z0-9_]+)',e))-{CONV}: continue
    if re.search(re.escape(PRE)+r'[A-Za-z0-9_]+\.',e): continue
    if any(re.search(re.escape(PRE)+v+r'\b',e) for v in convvars):
        convvar_eqs.append('  '+loc_ext(e).strip())
nodes=defaultdict(list)
for pin in parent: nodes[find(pin)].append(pin)
def pinexpr(x):
    if '.' in x:
        i,p=x.split('.'); return f'{vn(i)}.{p}'
    return x   # external terminal p / n
connects=[]
for root,ps in sorted(nodes.items()):
    if len(ps)<2: continue
    base=sorted(ps)[0]
    for o in sorted(ps):
        if o!=base: connects.append(f'  connect({pinexpr(base)}, {pinexpr(o)});')
cvdecl='\n'.join(f'  Real {v};' for v in sorted(convvars) if v!='Vs')
TOP=f'''model GridFeeding "Grid-feeding converter (modular)"
  Terminal p "AC terminal to the grid";
  input Real Vs "DC-bus voltage setpoint";
{cvdecl}
{chr(10).join(f'  {s} {vn(s)};' for s in SUBS)}
equation
{chr(10).join(convvar_eqs)}
{chr(10).join(signal_eqs)}
{chr(10).join(wires)}
{chr(10).join(connects)}
  annotation(preferredView = "text");
end GridFeeding;'''
TEST='''
model GridFeeding_test "Standalone test: grid-feeding converter into a stiff 50 Hz grid"
  GridFeeding gf;
  parameter Real Vpk = sqrt(2.0/3.0) * 103670.0;
equation
  gf.Vs = 207340.0;
  gf.p.v1 = Vpk * cos(2*3.141592653589793*50*time);
  gf.p.v2 = Vpk * cos(2*3.141592653589793*50*time - 2.0943951023931953);
  gf.p.v3 = Vpk * cos(2*3.141592653589793*50*time + 2.0943951023931953);
  annotation(preferredView = "text");
end GridFeeding_test;
'''
HEADER='''within Dynawo.Electrical.EMT;
/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com). SPDX-License-Identifier: MPL-2.0
* Modular grid-feeding converter, de-flattened from the recovered EMTSim GridFeeding2.
* One reusable class per sub-component wired in the GridFeeding composite; converter
* parameters resolved to their operating-point values.
*/
package GridFeedingConverter "Modular grid-feeding EMT converter"
'''
open('GridFeedingConverter.mo','w').write(HEADER+'\n\n'.join([CONNECTOR]+classes)+'\n\n'+TOP+'\n'+TEST+'end GridFeedingConverter;\n')
print("subs",len(SUBS),"connects",len(connects),"signal_eqs",len(signal_eqs),"convvar_eqs",len(convvar_eqs),"wires",len(wires))
