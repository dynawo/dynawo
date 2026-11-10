#!/usr/bin/env python3
"""
Report on a compiled Dynawo Modelica model, read from its generated <Model>_Dyn.cpp:
  1. the variables (index, name, kind, generated yType)
  2. the equations (index, generated fType, OMC equation number, text)
  3. the assignment equation -> unknown (output set, recomputed here) and the type it implies
  4. the count checks done by SolverKINAlgRestoration::initVarAndEqTypes

The assignment is NOT read from Dynawo (it is not stored anywhere): it is recomputed by
bipartite matching between equations and highest-order unknowns, i.e.
  der(s) for every state s (rSta), and y itself for every other non-external variable
(dummy derivatives included). An equation matched to der(s) should be DIFFERENTIAL_EQ,
any other equation ALGEBRAIC_EQ.

Usage:
  python3 model_report.py <Model>                  # looks for build/**/M/M/P/<Model>/<Model>_Dyn.cpp
  python3 model_report.py <dir containing _Dyn.cpp>
  python3 model_report.py <path/to/Model_Dyn.cpp>
Options:
  --full      do not truncate equation texts
  --diff      in section 3, only print equations whose generated fType differs from the implied one
"""

import glob
import os
import re
import sys
import time

TEXT_WIDTH = 110


def find_dyn_cpp(arg):
    if os.path.isfile(arg):
        return arg
    if os.path.isdir(arg):
        files = glob.glob(os.path.join(arg, "*_Dyn.cpp"))
        if len(files) == 1:
            return files[0]
        if len(files) > 1:
            sys.exit("Expected exactly one *_Dyn.cpp in %s, found %d" % (arg, len(files)))
    root = os.path.dirname(os.path.abspath(__file__))
    files = glob.glob(os.path.join(root, "build", "**", "M", "M", "P", arg, arg + "_Dyn.cpp"), recursive=True)
    if not files:
        sys.exit("No %s_Dyn.cpp found under %s/build" % (arg, root))
    return max(files, key=os.path.getmtime)


def function_body(src, name):
    """Text of the C++ function whose name ends with '::name(' (up to the first column-0 '}')."""
    m = re.search(r"::" + name + r"\(", src)
    if m is None:
        return ""
    end = src.find("\n}", m.end())
    return src[m.end():end]


def parse(src):
    # variables: comment block at the top of evalFAdept
    adept = function_body(src, "evalFAdept")
    y_names = {}
    for name, idx in re.findall(r"^\s*([^\s:]+)\s*:\s*x\[(\d+)\]\s*$", adept, re.M):
        y_names[int(idx)] = name

    y_types = {}
    y_kinds = {}
    for idx, ytype, comment in re.findall(r"yType\[\s*(\d+)\s*\]\s*=\s*(\w+);\s*/\*(.*?)\*/",
                                          function_body(src, "evalStaticYType_omc")):
        idx = int(idx)
        y_types[idx] = ytype
        name = comment.split()[0]
        y_names.setdefault(idx, name)
        if "EXTERNAL" in ytype:
            y_kinds[idx] = "external"
        elif name.endswith("_dummy_der"):
            y_kinds[idx] = "dummy"
        elif "(rSta)" in comment and ytype == "DIFFERENTIAL":
            y_kinds[idx] = "state"
        else:
            y_kinds[idx] = "alg"
    # variables without static type: typed by mode in evalDynamicYType_omc
    for idx in y_names:
        if idx not in y_types:
            y_types[idx] = "dynamic"
            y_kinds[idx] = "mixed"

    f_types = {}
    for idx, ftype in re.findall(r"fType\[\s*(\d+)\s*\]\s*=\s*(\w+);", function_body(src, "evalStaticFType_omc")):
        f_types[int(idx)] = ftype

    f_texts = {}
    f_omc = {}
    for idx, text, omc in re.findall(r'fEquationIndex\[(\d+)\]\s*=\s*"(.*)";\s*//equation_index_omc:(\d+)', src):
        f_texts[int(idx)] = text
        f_omc[int(idx)] = int(omc)

    # incidence: every x[i] / xd[i] used in a block up to the 'res[k] =' statement
    incidence = {}
    for chunk in adept.split("// ----- ")[1:]:
        for m in re.finditer(r"res\[(\d+)\]\s*=[^;]*;", chunk):
            used = chunk[:m.end()]
            cols = incidence.setdefault(int(m.group(1)), set())
            for i in re.findall(r"\bx\[(\d+)\]", used):
                cols.add(("y", int(i)))
            for i in re.findall(r"\bxd\[(\d+)\]", used):
                cols.add(("der", int(i)))
    return y_names, y_types, y_kinds, f_types, f_texts, f_omc, incidence


def highest_order_columns(cols, y_kinds):
    """Keep the highest-order unknowns: der(s) for states, y for non-state non-external variables."""
    keep = []
    for kind, i in cols:
        k = y_kinds.get(i, "alg")
        if kind == "der" and k == "state":
            keep.append((kind, i))
        elif kind == "y" and k not in ("state", "external", "mixed"):
            keep.append((kind, i))
    return keep


def kuhn(phases, columns_of):
    """Kuhn augmenting paths. phases = list of (ordered equations, allowed(e, c)); matched equations stay matched."""
    sys.setrecursionlimit(max(10000, 10 * len(columns_of) + 1000))
    eq_of_col = {}
    col_of_eq = {}

    def augment(e, visited, allowed):
        for c in columns_of[e]:
            if not allowed(e, c) or c in visited:
                continue
            visited.add(c)
            if c not in eq_of_col or augment(eq_of_col[c], visited, allowed):
                eq_of_col[c] = e
                col_of_eq[e] = c
                return True
        return False

    for order, allowed in phases:
        for e in order:
            if e not in col_of_eq:
                augment(e, set(), allowed)
    return col_of_eq, eq_of_col


def match(equations, columns_of, f_types):
    """Output set, same phases as factory_new.py: state derivatives only, then algebraic only, then all.
    Ties are broken in favour of the generated typing (DIFFERENTIAL_EQ equations first in phase 1)."""
    order = sorted(equations, key=lambda e: (f_types.get(e) != "DIFFERENTIAL_EQ", e))
    return kuhn([(order, lambda e, c: c[0] == "der"),
                 (equations, lambda e, c: c[0] != "der"),
                 (equations, lambda e, c: True)], columns_of)


def generated_typing_is_consistent(equations, columns_of, f_types):
    """True if a perfect matching exists with DIFFERENTIAL_EQ <-> der(state) and ALGEBRAIC_EQ <-> other unknowns."""
    def allowed(e, c):
        return (c[0] == "der") == (f_types.get(e) == "DIFFERENTIAL_EQ")
    col_of_eq, _ = kuhn([(equations, allowed)], columns_of)
    return len(col_of_eq) == len(equations)


def col_name(c, y_names):
    name = y_names.get(c[1], "y[%d]" % c[1])
    return "der(%s)" % name if c[0] == "der" else name


def short(text, full):
    return text if full or len(text) <= TEXT_WIDTH else text[:TEXT_WIDTH - 3] + "..."


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    full = "--full" in sys.argv
    only_diff = "--diff" in sys.argv
    if len(args) != 1:
        sys.exit(__doc__)
    path = find_dyn_cpp(args[0])
    with open(path) as f:
        src = f.read()
    y_names, y_types, y_kinds, f_types, f_texts, f_omc, incidence = parse(src)

    print("File: %s" % path)
    print("Generated: %s" % time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(os.path.getmtime(path))))

    # 1. variables
    print("\n=== 1. VARIABLES (%d) ===" % len(y_types))
    print("%4s  %-45s %-9s %s" % ("y", "name", "kind", "generated yType"))
    for i in sorted(y_types):
        flag = "   <-- dummy derivative typed DIFFERENTIAL" if y_kinds[i] == "dummy" and y_types[i] == "DIFFERENTIAL" else ""
        print("%4d  %-45s %-9s %s%s" % (i, y_names.get(i, "?"), y_kinds[i], y_types[i], flag))

    # 2. equations
    equations = sorted(f_types)
    print("\n=== 2. EQUATIONS (%d) ===" % len(equations))
    print("%4s  %-16s %5s  %s" % ("f", "generated fType", "omc", "text"))
    for e in equations:
        print("%4d  %-16s %5s  %s" % (e, f_types[e], f_omc.get(e, "?"), short(f_texts.get(e, "?"), full)))

    # 3. assignment
    columns_of = {e: highest_order_columns(incidence.get(e, set()), y_kinds) for e in equations}
    for e in equations:
        columns_of[e].sort(key=lambda c: (c[0] != "der", c[1]))
    col_of_eq, eq_of_col = match(equations, columns_of, f_types)

    print("\n=== 3. ASSIGNMENT equation -> highest-order unknown (recomputed) ===")
    print("%4s  %-45s %-16s %-16s %s" % ("f", "determines", "implied fType", "generated fType", "candidates"))
    n_diff = 0
    for e in equations:
        c = col_of_eq.get(e)
        implied = "?" if c is None else ("DIFFERENTIAL_EQ" if c[0] == "der" else "ALGEBRAIC_EQ")
        mismatch = c is not None and implied != f_types[e]
        n_diff += mismatch
        if only_diff and not mismatch and c is not None:
            continue
        cands = ", ".join(col_name(x, y_names) for x in columns_of[e])
        print("%4d  %-45s %-16s %-16s %s%s" % (e, "UNMATCHED" if c is None else col_name(c, y_names),
                                                implied, f_types[e], short(cands, full),
                                                "   <-- differs" if mismatch else ""))

    # 4. checks
    unknowns = set(c for e in equations for c in columns_of[e])
    unmatched_cols = sorted(unknowns - set(eq_of_col), key=lambda c: (c[0] != "der", c[1]))
    states = [i for i in y_kinds if y_kinds[i] == "state"]
    nb_y_diff = sum(1 for t in y_types.values() if t == "DIFFERENTIAL")
    nb_y_alg = sum(1 for t in y_types.values() if t == "ALGEBRAIC")
    nb_f_diff = sum(1 for t in f_types.values() if t == "DIFFERENTIAL_EQ")
    nb_f_alg = sum(1 for t in f_types.values() if t == "ALGEBRAIC_EQ")

    mixed_vars = [i for i in y_kinds if y_kinds[i] == "mixed"]
    mixed_eqs = [e for e in f_texts if e not in f_types]

    print("\n=== 4. CHECKS ===")
    print("states: %d, dummy derivatives: %d, equations: %d, matched: %d"
          % (len(states), sum(1 for k in y_kinds.values() if k == "dummy"), len(equations), len(col_of_eq)))
    if mixed_vars or mixed_eqs:
        print("static types only: %d mixed variable(s) and %d mixed equation(s) (type set by mode) are left out"
              % (len(mixed_vars), len(mixed_eqs)))
    print("KIN_DERIVATIVES (DIFFERENTIAL y vs DIFFERENTIAL_EQ f): %d vs %d  %s"
          % (nb_y_diff, nb_f_diff, "OK" if nb_y_diff == nb_f_diff else "FAIL (assert numF == indexY_.size())"))
    print("KIN_ALGEBRAIC   (ALGEBRAIC y vs ALGEBRAIC_EQ f):       %d vs %d  %s"
          % (nb_y_alg, nb_f_alg, "OK" if nb_y_alg == nb_f_alg else "FAIL (assert numF == indexY_.size())"))
    print("generated fType different from implied fType: %d equation(s)" % n_diff)
    print("generated typing structurally consistent (perfect matching DIFFERENTIAL_EQ <-> der(state), "
          "ALGEBRAIC_EQ <-> other unknowns): %s"
          % ("YES" if generated_typing_is_consistent(equations, columns_of, f_types) else "NO"))
    for e in equations:
        if e not in col_of_eq:
            print("  unmatched equation f[%d]: %s" % (e, short(f_texts.get(e, "?"), full)))
    for c in unmatched_cols:
        print("  unknown determined by no equation%s: %s"
              % (" (possibly by a mixed equation)" if mixed_eqs else "", col_name(c, y_names)))
    for i in states:
        if ("der", i) not in unknowns:
            print("  der(%s) appears in no equation" % y_names.get(i, "?"))


if __name__ == "__main__":
    main()
