# CONTEXT — Dummy derivatives OMC dans la génération de modèles Dynawo

> Synthèse d'une revue de code statique de `readerOMC.py`, `factory.py` et `dataContainer.py`.
> Les points marqués **[ÉTABLI]** sont lus directement dans le code.
> Les points marqués **[HYPOTHÈSE]** restent à confirmer sur les fichiers générés (`*_info.json`, `*_Dyn.cpp`).
>
> **Mise à jour 1** : relecture complète du code source actuel
> (`dynawo/sources/ModelicaCompiler/Scripts_OMC_1_13_2/`, état `git` propre, branche `3152_GFM_DynVSM`).
> Tous les numéros de ligne ont été recalés sur ce fichier. Aucune modification de code n'a été faite.
> **Constat additionnel** : `factory.py` ne porte aucune trace du correctif précédemment tenté
> (pas de bloc `BUGFIX`, pas de branche `fictive_continuous_vars_der` dans `prepare_for_evalstaticftype`) —
> le fichier est dans son état d'origine. À garder en tête pour la suite : tout correctif futur repart de zéro.
>
> **Mise à jour 2 (2026-10-20)** : rebuild frais de `DynLine` (reproducteur minimal, `IModulePu`/`didtModulePu`)
> et inspection directe de `DynLine_info.json` / `DynLine_Dyn.cpp`. **La cause B est désormais confirmée sur
> données réelles, pas seulement en théorie.** La cause A est écartée pour ce cas précis (voir §9bis). Le détail
> complet des preuves est en §9bis, à la fin du document — les sections 3 à 8 ci-dessous restent la lecture de
> référence du mécanisme général, §9bis n'en est que l'illustration chiffrée sur un cas réel.

---

## 1. Symptôme

- Un modèle Modelica dont la réduction d'index par OMC produit des dummy derivatives fait planter le solveur Dynawo. Le message indique une **matrice non carrée**.
- Soupçon initial : la variable `x_dummy_der` est classée **DIFFERENTIAL**, mais l'équation associée reste **ALGEBRAIC**.

Les scripts concernés sont du Python exécuté **à la compilation du modèle** :

```
.mo → OMC → *_info.json, *_variables.txt, *.c → readerOMC.py + factory.py → *_Dyn.cpp → .so
```

Les modifier ne nécessite **pas de rebuild de Dynawo**. Il suffit d'éditer la copie installée, puis de recompiler le modèle.

---

## 2. Rappel théorique (Mattsson–Söderlind, 1993)

- Index de différentiation : nombre minimal de dérivations de tout ou partie de F(t, w, ẇ) = 0 nécessaires pour obtenir ẇ = φ(t, w).
- Réduction d'index par dummy derivatives :
  1. on conserve les équations d'origine **et** leurs dérivées (Pantelides), ce qui donne un système surdéterminé mais consistant ;
  2. pour chaque équation dérivée ajoutée, une dérivée est remplacée par une **nouvelle inconnue algébrique**, la dummy derivative.
- Une dummy derivative **n'est pas discrétisée** : le solveur ignore qu'elle vaut dx/dt. C'est précisément ce qui évite que les équations redondantes deviennent contradictoires après discrétisation BDF (erreurs de troncature).
- Conséquence attendue côté Dynawo : `$DER.x` d'OMC doit rester une **inconnue algébrique**, et son équation une **équation algébrique**.
- Point ajouté lors de la relecture de l'article (section précédente de la conversation, non recopiée ici en détail) : la permutation BLT de Pantelides applique **deux permutations indépendantes**, une sur les équations (`P`) et une sur les variables (`Q`) — `H = P·F·Q`. Rien ne garantit `P = Q`. C'est un éclairage complémentaire pour un bug *distinct* (désalignement positionnel équations/variables observé empiriquement sur `GFMCCVSM`), à ne pas confondre avec le mécanisme décrit ci-dessous, qui porte sur le **typage** (ALGEBRAIC vs DIFFERENTIAL), pas sur l'ordre des listes.

---

## 3. Ce que fait le code

### 3.1 Deux notions de « dummy » distinctes [ÉTABLI]

`dataContainer.py` :

```python
DUMMY_VARIABLE_NAME = "$dummy"                                    # ligne 24

def is_dummy_var(var):                                            # lignes 344-345
    return DUMMY_VARIABLE_NAME in var.get_name() and "der(" not in var.get_name()
```

- `is_dummy_var` / `list_vars_dummy` / `nbDummy` désignent le **`$dummy` d'OMC**, l'état fictif ajouté quand un modèle n'a aucun état (`der($dummy) = 0`).
- Les dummy derivatives de la réduction d'index sont dans `reader.dummy_der_variables` (`x_dummy_der`), peuplé dans `readerOMC.py` ligne 1548.
- Les deux notions ne se mélangent pas : `"$dummy" in "x_dummy_der"` vaut `False`. **Confirmé, pas de bug de ce côté.**

### 3.2 Création de `x_dummy_der` [ÉTABLI]

`readerOMC.py`, `read_variables_txt_file`, lignes **1543–1556** (confirmé, numérotation inchangée). Pour chaque `$DER.x` déclaré par OMC dans `algVars` (donc algébrique, condition `elif "$DER" in name and "algVars" in var_type:`) :

| Nom | Traitement |
|---|---|
| `$DER.x` | adresse provisoire `derivativesVars` |
| `der(x)` | même adresse que `$DER.x` |
| `x_dummy_der` | **nouvelle** `Variable`, `set_type("rAlg")`, continuous, adresse `realVars`. Ajoutée à `dummy_der_variables`. |

**Point confirmé par la relecture** (c'était noté [HYPOTHÈSE] côté type OMC) : `$DER.x` entre dans ce bloc uniquement s'il apparaît avec `var_type` contenant `"algVars"` — c'est-à-dire qu'OMC le classe déjà comme variable **algébrique** native (`rAlg`), jamais comme `rDer`. Ce point sert de pilier à la section 3.5 (voir plus bas, devient ÉTABLI).

### 3.3 Remapping de `$DER.x` sur la dérivée de x [ÉTABLI]

`readerOMC.py`, `assign_variables_indexes`, seconde boucle d'adressage, lignes **1686–1700** (confirmé, numérotation inchangée) :

```python
if "derivativesVars" in address:
    name_equivalent_state = name                     # ex: "$DER.x" ou "der(x)"
    if alternative_way_to_declare_der in name_equivalent_state:
        name_equivalent_state = name_equivalent_state.replace(alternative_way_to_declare_der, "")
    if "der(" in name_equivalent_state:
        name_equivalent_state = name_equivalent_state.replace("der(","")[:-1]
    index = to_param_address(name_equivalent_state)...   # indice de x dans realVars
    set_param_address(name, "data->localData[0]->derivativesVars["+str(index)+"]")
    set_param_address(name.replace(alternative_way_to_declare_der,"der(")+")", ...)
    set_param_address(name.replace("der(",alternative_way_to_declare_der)[:-1], ...)
```

- La dummy derivative d'OMC est **remappée sur la vraie dérivée de x** (`xd[idx(x)]`), et non sur `x_dummy_der`.
- Dans le C++ généré, `$DER.x` devient donc un terme `xd[...]`, **discrétisé** par le BDF. C'est contraire au principe de la méthode.
- Confirmé : aucune ligne de ce bloc ne touche `x_dummy_der` — cette variable n'est jamais adressée vers `derivativesVars`, seulement vers `realVars` (section 3.2). Elle n'a donc **structurellement aucun `xd[...]` associé** dans la génération — ce qui est cohérent avec son statut de pure inconnue algébrique « compensatrice ».

### 3.4 Typage des variables (yType) [ÉTABLI]

`factory.py`, `prepare_for_evalstaticytype`, lignes **3028–3037** (léger décalage par rapport à l'ancienne numérotation ~3034-3037, confirmé) :

```python
for v in self.list_vars_syst:
    ...
    spin = "DIFFERENTIAL"
    if is_alg_var(v):
        spin = "ALGEBRAIC"
    if v.get_name() in self.reader.dummy_der_variables:
        spin = "DIFFERENTIAL"        # override explicite
    ...
```

| Variable | Type OMC | yType généré | Sa dérivée apparaît-elle dans un résidu ? |
|---|---|---|---|
| x (dummy state) | rAlg | **ALGEBRAIC** | **oui**, via `$DER.x` → `xd[idx(x)]` |
| x_dummy_der | rAlg | **DIFFERENTIAL** (override) | non : rien ne pointe vers son `xd` (confirmé par 3.3) |

Le flag DIFFERENTIAL est posé sur `x_dummy_der`, alors que c'est la dérivée de **x** qui apparaît dans les équations. **Confirmé intégralement.**

### 3.5 Typage des équations (fType) [ÉTABLI — passe de HYPOTHÈSE à ÉTABLI sur un point clé]

`factory.py`, `collect_eq_makers_from_16_dae`, lignes **888–894** (confirmé) :

```python
eq_type = ALGEBRAIC
if len(list(filter(lambda x, name=name_var_eval: x.get_name() == name, self.list_vars_der))) > 0:
    eq_type = DIFFERENTIAL
elif name_var_eval in self.reader.var_name_to_eq_type:
    eq_type = self.reader.var_name_to_eq_type[name_var_eval]
```

- `list_vars_der` est peuplé (`factory.py` ligne 439) par `filter(is_der_real_var, list_vars_read)`.
- `dataContainer.py`, `is_der_real_var` (lignes 324–330) :
  ```python
  def is_der_real_var(var):
      if DUMMY_VARIABLE_NAME in var.get_name(): return False
      return var.get_type() == "rDer"
  ```
- **Confirmé (anciennement hypothèse)** : `$DER.x` est créé avec `set_type("rAlg")` (section 3.2), jamais `"rDer"`. Il ne peut donc **jamais** appartenir à `list_vars_der`. On tombe systématiquement dans le `elif` : `var_name_to_eq_type[name_var_eval]`.
- `var_name_to_eq_type` est rempli par `readerOMC.py`, `analyse_equations_and_get_types`, lignes **703–711** (confirmé) :

  ```python
  if "der(" in eq or "der (" in eq:
      types = [DIFFERENTIAL]
  else:
      types = [ALGEBRAIC]
  ```

  La détection se fait sur la **chaîne de caractères** de l'équation du JSON OMC (le champ `"equation"`, lu ligne 441 : `self.analyse_equations_and_get_types(str(eq), name)`). **[HYPOTHÈSE, toujours à confirmer sur le JSON réel]** : si OMC écrit `$DER.x` plutôt que `der(x)` dans ce champ texte, le test `"der(" in eq` échoue et l'équation est typée **ALGEBRAIC**, alors que son résidu contient un `xd[...]` après remapping (section 3.3). C'est le mécanisme probable du bug soupçonné — mais seul le contenu réel du `*_info.json` peut trancher, le code ne fait aucune normalisation `$DER.` → `der(` sur ce champ avant le test.

### 3.6 Collecte de l'équation de la dummy [ÉTABLI + HYPOTHÈSE confirmée-renforcée]

`factory.py`, `collect_eq_syst`, lignes **928–931** (confirmé, numérotation inchangée) :

```python
for var_name in self.reader.dummy_der_variables:
    name = "der("+var_name.replace("_dummy_der","")+")"
    for eq in filter(lambda x: (not x.get_is_modelica_reinit()) and (x.get_evaluated_var() == name), self.list_all_equations):
        self.list_eq_syst.append(eq)
```

- `eq.get_evaluated_var()` est posé dans `collect_eq_makers_from_16_dae` (ligne 883, `eq_mak.set_evaluated_var(name_var_eval)`), à partir de `name_var_eval`, lui-même tiré tel quel du champ `"defines"` du JSON OMC (`readerOMC.py`, `read_info_json`, lignes 424–429, `list_defined_vars = equation["defines"]`).
- **Confirmé** : il n'existe **aucune normalisation** `$DER.` → `der(` appliquée sur ce champ `"defines"` nulle part dans `readerOMC.py` avant que la chaîne ne serve de clé de comparaison dans `collect_eq_syst`.
- **[HYPOTHÈSE, toujours à vérifier sur le JSON réel]** : si `"defines"` vaut `["$DER.x"]` plutôt que `["der(x)"]` pour l'équation différentielle de x, `eq.get_evaluated_var()` retournera `"$DER.x"`, qui ne matchera jamais `name = "der(x)"` construit ligne 929. L'équation de la dummy **ne sera alors jamais collectée** dans `list_eq_syst`. Il manque alors une ligne, et la matrice globale devient non carrée (symptôme initial rapporté).
- Confirmé également : juste après (lignes 938–946), chaque équation de `list_eq_syst` reçoit un `num_dyn` séquentiel, **sauf** si `var_name in self.reader.fictive_continuous_vars_der` ou `is_auxiliary_vars(var_name)`, auquel cas `eq.set_num_dyn(-1)` (commentaire d'origine : `# can detect bugs`).

---

## 4. Causes possibles du plantage

Les trois causes peuvent coexister.

| # | Cause | Effet sur le solveur | Statut |
|---|---|---|---|
| A | `x_dummy_der` n'apparaît dans aucun résidu `setF` (le code OMC référence `$DER.x`, redirigé vers `xd[idx(x)]`) | **colonne nulle** dans la jacobienne : matrice structurellement singulière | **ÉCARTÉE, confirmé sur `DynLine` (§9bis)** : `der(IModulePu)` est resté adressé sur le `realVars` de `IModulePu_dummy_der`, pas sur `derivativesVars[idx(IModulePu)]` — ce dernier n'est référencé nulle part. L'adressage est correct dans ce cas ; pas de colonne nulle. |
| B | Typages incohérents : variable DIFFERENTIAL et équation ALGEBRAIC_EQ (ou x ALGEBRAIC alors que son `xd` apparaît) | le sous-système « équations algébriques × variables algébriques » (restauration algébrique, initialisation) **n'est pas carré** | **CONFIRMÉE sur données réelles (§9bis)** : `yType[10]=DIFFERENTIAL` (`IModulePu_dummy_der`) vs `fType[1]=ALGEBRAIC_EQ` (son équation). Le texte `"equation"` du JSON OMC pour cette équation ne contient jamais la sous-chaîne `"der("` (OMC l'a réarrangée en `"dynline.didtModulePu"`), donc `analyse_equations_and_get_types` la type ALGEBRAIC par défaut. **C'est la cause confirmée du déséquilibre.** |
| C | Équation de la dummy non collectée (nom `$DER.x` ≠ `der(x)` dans `"defines"`) | une équation de moins que de variables : **matrice globale non carrée** | **ÉCARTÉE sur `DynLine` (§9bis)** : le champ `"defines"` vaut bien `der(dynline.IModulePu)` dans le JSON réel, pas `$DER.dynline.IModulePu`. L'équation est donc correctement collectée par `collect_eq_syst`. Reste hypothétique pour d'autres modèles/versions d'OMC où `"defines"` pourrait différer. |
| D | `der(x)` présent aussi dans `list_vars_der` | équation ajoutée deux fois dans `collect_eq_syst` (pas de dédoublonnage) : une ligne de trop | **infirmé par 3.5** : `$DER.x`/`der(x)` ont `type == "rAlg"`, donc `is_der_real_var` renvoie toujours `False` pour eux ⇒ ne peuvent pas être dans `list_vars_der`. À écarter. |

**Lecture théorique.** En remappant `$DER.x` sur `xd[idx(x)]`, on retrouve deux équations qui contraignent x : g(x) = 0 et g'(x, ẋ) = 0, avec ẋ discrétisé. On est dans la situation du système augmenté (1.3) de l'article, surdéterminé et contradictoire une fois discrétisé. L'inconnue de compensation `x_dummy_der` ne joue son rôle que si elle apparaît réellement dans les équations.

Jacobienne du Newton BDF, J = ∂F/∂y + α·∂F/∂ẏ (α = coefficient BDF / h), sur les colonnes (x, x_dummy_der), dans le cas A :

```
                 x                    x_dummy_der
g(x) = 0      ( g_x                       0   )
g'(x, ẋ) = 0  ( g'_x + α·g'_ẋ             0   )   ← colonne nulle
```

---

## 5. Bugs annexes [ÉTABLI]

1. **Faute de frappe**, `readerOMC.py` ligne **1198** (confirmé, numérotation inchangée), dans `set_start_value_for_syst_vars_06inz` :
   ```python
   name = "der(" + name.repplace("_dummy_der", "") + ")"   # ← repplace
   ```
   Lève `AttributeError` dès qu'un modèle a une dummy derivative **et** une entrée dans `var_init_val_06_extend`. Bug latent : pas la cause du plantage actuel. Correction : `replace`.

2. **Comparaison chaînée**, `factory.py` ligne **969** (confirmé, numérotation inchangée), dans `collect_reinit_eq` :
   ```python
   if var in self.list_vars_der > 0:
   ```
   Python lit `(var in self.list_vars_der) and (self.list_vars_der > 0)`.
   - Branche morte : `var` parcourt des variables x, jamais des `der(x)`. Une équation de reinit n'est donc jamais typée DIFFERENTIAL par ce chemin.
   - Crash latent : si le test valait True, `list > 0` lèverait un `TypeError` en Python 3 (comparaison `list > int`).

   Correction proposée (inchangée, non appliquée) :
   ```python
   der_names = {v.get_name() for v in self.list_vars_der}   # avant la boucle
   eq_type = ALGEBRAIC
   if eq.get_evaluated_var() in der_names:
       eq_type = DIFFERENTIAL
   elif ...
   ```

3. **Pas de dédoublonnage** dans `collect_eq_syst`. Quatre boucles successives alimentent `self.list_eq_syst` (confirmé, lignes 915–931) : `auxiliary_var_to_keep`, `residual_vars_to_address_map`, `list_vars_syst` + `list_vars_der`, dummies. Une même équation peut y être ajoutée plusieurs fois si son nom apparaît dans plusieurs de ces ensembles.

---

## 6. Vérifications à faire (sans rebuild Dynawo)

À faire sur **une** dummy derivative d'un modèle qui plante. Ces points restent entièrement ouverts : rien dans le code ne permet de trancher sans regarder le JSON/C++ réellement généré par OMC pour un modèle donné.

### 6.1 JSON OMC (`<Modele>_info.json`)

Pour l'équation de la dummy, relever :
- `"defines"` : `der(x)` ou `$DER.x` ? Cela tranche la cause C (confirmé : aucune normalisation n'existe dans le code, donc le texte brut du JSON est décisif).
- `"equation"` : le texte contient-il `der(` ou `$DER.` ? Cela tranche le typage (cause B, confirmé même mécanisme : `analyse_equations_and_get_types` teste littéralement la sous-chaîne `"der("`).

### 6.2 Diagnostic dans `collect_eq_syst` (fin de fonction, après la numérotation, ~ligne 946)

```python
from collections import Counter
names = [eq.get_evaluated_var() for eq in self.list_eq_syst]
dups = [n for n, c in Counter(names).items() if c > 1]
print_info("Equations dupliquées dans list_eq_syst : " + str(dups))

dummy_eq_names = {"der(" + v.replace("_dummy_der", "") + ")"
                  for v in self.reader.dummy_der_variables}
der_names = {v.get_name() for v in self.list_vars_der}
print_info("der(x) de dummies aussi présents dans list_vars_der : "
           + str(dummy_eq_names & der_names))
for eq in self.list_eq_syst:
    if eq.get_evaluated_var() in dummy_eq_names:
        print_info("dummy eq %s : type=%s num_dyn=%s"
                   % (eq.get_evaluated_var(), eq.get_type(), eq.get_num_dyn()))
```

Interprétation :
- aucune ligne `dummy eq ...` affichée : **cause C** ;
- liste de doublons non vide : **cause D** (mais déjà jugé peu probable par la relecture, voir §4).

### 6.3 C++ généré (`<Modele>_Dyn.cpp`)

Repérer dans `evalStaticYType` les indices de x et de `x_dummy_der` (les commentaires contiennent les noms), puis :

```bash
grep -n "x\[<idx_x_dummy_der>\]" *_Dyn*.cpp   # x_dummy_der apparaît-elle dans setF ?  (absente → cause A)
grep -n "xd\[<idx_x>\]"          *_Dyn*.cpp   # la dérivée de x apparaît-elle ?        (présente → remapping confirmé)
```

Bilans de types (hors MIXED, typés dynamiquement) :

```bash
grep -c "= DIFFERENTIAL;"    *_Dyn*.cpp
grep -c "= ALGEBRAIC;"       *_Dyn*.cpp
grep -c "= DIFFERENTIAL_EQ;" *_Dyn*.cpp
grep -c "= ALGEBRAIC_EQ;"    *_Dyn*.cpp
```

Un écart égal au nombre de dummies confirme la **cause B**.

Le critère de cohérence est mécanique :
- une équation doit être `DIFFERENTIAL_EQ` **si et seulement si** son résidu dans `setF` contient au moins un `xd[...]` ;
- une variable doit être `DIFFERENTIAL` **si et seulement si** son `xd[i]` apparaît dans au moins un résidu.

### 6.4 Historique

`git blame` sur `readerOMC.py`, lignes ~1543–1556 et ~1686–1700 : pourquoi `$DER.x` est-il remappé sur la dérivée de x ? Y a-t-il une contrainte du solveur Dynawo derrière ce choix ?

---

## 7. Pistes de correction (à choisir après les vérifications)

### Option 1 — Respecter Mattsson–Söderlind (recommandée a priori)

Garder `$DER.x` comme **inconnue algébrique** :
- adresser `$DER.x` et `der(x)` sur le `realVars` de `x_dummy_der`, et non sur `derivativesVars[idx(x)]` (reader, lignes ~1686–1700) ;
- supprimer l'override DIFFERENTIAL de `x_dummy_der` (`factory.py`, lignes ~3036–3037) ;
- l'équation de la dummy reste ALGEBRAIC_EQ ;
- s'assurer que `collect_eq_syst` retrouve l'équation quel que soit le nom (`der(x)` ou `$DER.x`) — point désormais confirmé comme fragile : aucune normalisation n'existe actuellement (§3.6).

### Option 2 — Conserver le remapping actuel, corriger le typage

Seulement si le git blame révèle une raison valable :
- typer x en DIFFERENTIAL, puisque son `xd` apparaît, et non `x_dummy_der` ;
- typer l'équation de la dummy en DIFFERENTIAL_EQ, en détectant aussi `$DER.` dans `analyse_equations_and_get_types` ou via un cas dédié dans `collect_eq_makers_from_16_dae` ;
- garantir que `x_dummy_der` apparaît dans au moins une équation, sinon la colonne reste nulle.

Inconvénient de l'option 2 : ẋ est rediscrétisé alors que g(x) = 0 reste présent, donc on garde le risque d'incohérence décrit par l'article.

### Dans tous les cas

- corriger `repplace` (`readerOMC.py`, ligne 1198) ;
- corriger la comparaison chaînée (`factory.py`, ligne 969) ;
- ajouter un contrôle d'unicité dans `collect_eq_syst`.

---

## 8. Éléments à fournir pour conclure

1. `"defines"` et `"equation"` de l'équation de `$DER.x` dans `*_info.json`.
2. Sortie du diagnostic de la section 6.2.
3. Extraits de `*_Dyn.cpp` : lignes `evalStaticYType` de x et `x_dummy_der`, et résidu `setF` de l'équation de la dummy.
4. Le point où le solveur plante : initialisation, restauration algébrique ou pas de temps courant. Cela distingue la cause B (sous-système algébrique) des causes A, C et D (système global).

---

## 9bis. Preuve concrète sur `DynLine` (rebuild frais, 2026-10-20)

Modèle : `dynawo/sources/Models/Modelica/Dynawo/Electrical/Lines/DynLine.mo` (reproducteur minimal :
`IModulePu = sqrt(i.re² + i.im² + 1e-8)`, `didtModulePu = der(IModulePu)`).

Build vérifié frais : `DynLine_info.json`/`_Dyn.cpp` du **12:06:33/42**, postérieurs à `DynLine.mo` du **12:02:35**.

### Variables.txt
```
type: algVars (5) index: 12: $DER.dynline.IModulePu (no alias) valueType: real initial: no arrCref index:(13)
```
Une seule dummy derivative dans ce modèle : `dynline.IModulePu_dummy_der`.

### `_info.json` — l'équation qui définit `der(IModulePu)`
```json
{
  "eqIndex": 44, "section": "residuals", "tag": "assign",
  "defines": ["der(dynline.IModulePu)"],
  "equation": ["dynline.didtModulePu"],
  "uses": ["dynline.didtModulePu"]
}
```
- `"defines"` vaut bien `der(dynline.IModulePu)` → **cause C écartée** : `collect_eq_syst` retrouve correctement cette équation (le nom construit `"der(" + "dynline.IModulePu" + ")"` matche exactement).
- `"equation"` vaut `"dynline.didtModulePu"` → **aucune occurrence de la sous-chaîne `"der("`**. OMC a réarrangé l'équation `didtModulePu = der(IModulePu)` pour l'exprimer comme `der(IModulePu) = didtModulePu`, et le texte stocké est seulement le membre de droite. C'est la preuve directe que le test `"der(" in eq` de `analyse_equations_and_get_types` (readerOMC.py:703) peut échouer même quand l'équation est authentiquement une définition de dérivée.

### `_Dyn.cpp` — conséquence sur les tags
```cpp
yType[ 10 ] = DIFFERENTIAL;   /* dynline_IModulePu_dummy_der (rAlg) */
...
fType[ 1 ] = ALGEBRAIC_EQ;    // résidu : f[1] = realVars[10] /* der(dynline.IModulePu) DUMMY_DER */
                              //        - ( realVars[7] /* dynline.didtModulePu */ )
```
Variable `DIFFERENTIAL`, équation qui la définit `ALGEBRAIC_EQ` : **l'asymétrie de la cause B est reproduite textuellement**, sans aucune hypothèse restante sur ce point précis.

### Vérification complémentaire : adressage (cause A)
```
derivativesVars[2]   ← présent (dynline.terminal1.i.im, vrai état)
derivativesVars[3]   ← présent (dynline.terminal1.i.re, vrai état)
derivativesVars[6]   ← ABSENT (aurait été le "vrai" xd de IModulePu)
```
`der(dynline.IModulePu)` est resté adressé sur le `realVars` propre à `IModulePu_dummy_der` (slot 10), jamais remappé vers `derivativesVars[6]`. **La cause A ne s'applique pas ici** : pas de colonne nulle, l'adressage respecte en fait l'esprit de Mattsson–Söderlind (la dummy derivative est bien une inconnue indépendante). Seul le typage de son équation est fautif.

### Bilan pour ce cas
Le bug se réduit, sur `DynLine`, à une seule ligne fautive : `analyse_equations_and_get_types` (readerOMC.py:694-713) type ALGEBRAIC une équation qui définit réellement une dérivée, parce que le texte OMC de cette équation particulière ne contient pas littéralement `"der("`. Un correctif ciblé consisterait à typer DIFFERENTIAL toute équation dont le `"defines"` commence par `"der("` ou `"$DER."`, indépendamment du contenu du champ `"equation"` — à tester d'abord sans modifier le code, en simulant le correctif sur ce JSON (cf. §6.2/§6.3), avant toute édition de `factory.py`/`readerOMC.py`.

---

## 9. Relation avec le bug d'ordonnancement déjà diagnostiqué (GFMCCVSM)

Ce document traite d'un mécanisme de **typage** (ALGEBRAIC vs DIFFERENTIAL mal posé selon que le JSON OMC écrit `der(x)` ou `$DER.x`). Le bug précédemment creusé en profondeur sur `GFMCCVSM`/`DynLine` (assert `numF == indexY_.size()`) avait été interprété comme un mécanisme **distinct** : un désalignement positionnel entre `list_eq_syst` (équations) et `list_vars_syst` (variables), dû à des permutations BLT indépendantes à la OMC (cf. §2, Mattsson–Söderlind, `H = P·F·Q`).

**Cette interprétation « P≠Q » n'a cependant jamais été reconfirmée sur des données fraîches** (elle provenait d'une session avec une instrumentation de debug depuis annulée) et doit être traitée comme non établie — voir §9ter pour la suite des événements, qui a rendu ce test impossible à refaire sur `GFMCCVSM` dans son état actuel.

### 9ter. Clôture pratique (2026-10-20) : le crash `CCVSMRoCoF` a disparu, la cause reste ouverte

Rebuild frais de `DynGridFormingCurrentControlledVirtualSynchronousMachine` (13:57, postérieur à `CurrentSaturation.mo` du 19/10 16:32) :
- **Aucune dummy derivative** dans ce modèle désormais : les 30 occurrences `$DER.*` de `_variables.txt` sont **toutes** classées `derivativeVars` (dérivées d'état réelles), y compris `$DER...currentSaturation.idFilteredConvRefPu` / `...iqFilteredConvRefPu`, qui étaient historiquement soupçonnées de déclencher la réduction d'index. Elles sont maintenant de vrais états différentiels, pas des dummy derivatives.
- `CCVSMRoCoF.jobs` **tourne sans erreur** avec ce build.

**Interprétation** : le crash original n'a pas été corrigé par un changement du générateur (`factory.py`/`readerOMC.py` sont restés dans leur état d'origine, §0 de ce document) — il a disparu parce que **le modèle ne passe plus par le chemin des dummy derivatives du tout**, suite à une évolution de `CurrentSaturation.mo` indépendante de cette investigation. Le bug générateur (cause B, confirmé en §9bis sur `DynLine`) reste donc **intact et latent** : il resurgira sur tout futur modèle qui génère une authentique dummy derivative. L'hypothèse « P≠Q » reste, elle, **non tranchée** : impossible de la tester sur `GFMCCVSM` tant qu'il n'a plus de dummy derivative ; il faudra soit retrouver un autre modèle candidat, soit la considérer comme probablement confondue avec la cause B (répétée plusieurs fois) jusqu'à preuve du contraire.

Les deux bugs, s'ils coexistent un jour dans le même pipeline de génération, n'ont pas la même cause ni le même correctif : la cause B porte sur des chaînes de caractères (`"der("` vs `"$DER."`) dans le JSON, l'hypothèse P≠Q porterait sur l'ordre des listes — mais cette dernière doit d'abord être redémontrée avant d'être traitée comme un fait établi.
