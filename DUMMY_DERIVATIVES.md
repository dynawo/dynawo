# Dummy derivatives dans Dynawo — le cas `TestIndex`

Ce document part d'un seul exemple, `TestIndex`, un système d'index 2 qui tourne sans problème
dans OpenModelica mais plantait dans Dynawo. Il explique pourquoi, ce qui a été modifié dans le
générateur de code (`factory.py`) pour le faire tourner, et comment cela se relie à la méthode des
dummy derivatives de Mattsson et Söderlind (1993).

---

## 1. L'exemple

Modèle : `dynawo/sources/Models/Modelica/Dynawo/Examples/IndexReduction/TestIndex.mo`
(modèle préassemblé `PreassembledModels/TestIndex.xml`, cas de test `TestIndex/testIndex2.jobs`).

24 inconnues : `x1..x11`, `y1, y2, y4, y10, y16`, `u1..u6`. Les lignes qui comptent :

```modelica
x1 + x3 + x4 + x5 = 0.0;            // (C1) contrainte sur les valeurs
x2 + x6 + x7 + x8 = 0.0;            // (C2)
0.01 * der(x1) = y1;                // (E1)
0.01 * der(x2) = y2;                // (E2)
0.01 * x3 + 0.1 * der(x3) = u1 - y4;   // idem pour x4, x5
(y4 - y1) + 0.01 * x6 + 0.1 * der(x6) = u4 - y2;   // idem pour x7, x8
der(x9) = y4 - y1;                  // idem pour x10, x11
```

`x1` (de même `x2`) apparaît sous deux formes : sa valeur, seulement dans (C1), et sa dérivée,
seulement dans (E1). Or (C1) fixe déjà la valeur de `x1` à chaque instant :
`x1 = -(x3 + x4 + x5)`. `x1` ne peut donc pas être un état intégré librement à partir de (E1) :
les deux équations se contrediraient.

OpenModelica résout cela par réduction d'index :
1. il dérive (C1) : `der(x1) + der(x3) + der(x4) + der(x5) = 0` ;
2. il remplace `der(x1)` par une nouvelle inconnue algébrique, la *dummy derivative*, que Dynawo
   nomme `x1_dummy_der` ;
3. `x1` devient algébrique (défini par C1), et (E1) devient une relation algébrique
   `0.01 * x1_dummy_der = y1`.

Même chose pour `x2` avec (C2) et (E2). Au final : 9 vrais états (`x3..x11`), 15 inconnues
algébriques (dont `x1`, `x2`, `x1_dummy_der`, `x2_dummy_der`).

### Forme du code généré (mode DAE)

OMC compile ce modèle en mode DAE : la plupart des équations sont des résidus nommés `$DAEres0`
à `$DAEres15`, qui ne sont rattachés à aucune variable. Dans leur texte, les vraies dérivées d'état
s'écrivent `der(x3)` et les dummy derivatives `$DER.x1` :

| Résidu | Texte OMC | Rôle |
|---|---|---|
| `$DAEres7` | `$DER.x1 + der(x3) + der(x4) + der(x5)` | contrainte (C1) dérivée |
| `$DAEres6` | `y1 + (-0.01) * $DER.x1` | (E1) réécrite |
| `$DAEres13` | `$DER.x2 + der(x6) + der(x7) + der(x8)` | contrainte (C2) dérivée |
| `$DAEres11` | `y2 + (-0.01) * $DER.x2` | (E2) réécrite |
| `$DAEres0`, `2`, `4` | `u1 - 0.1*der(x3) - 0.01*x3 - y4`, … | équations propres de `x3, x4, x5` |
| `$DAEres12`, `14`, `15` | `0.1*der(x6) + …`, … | équations propres de `x6, x7, x8` |
| `$DAEres8`, `9`, `10` | `y4 - y1 - der(x9)`, … | équations propres de `x9, x10, x11` |

---

## 2. Pourquoi l'exemple ne tournait pas

### Ce que Dynawo exige

Le générateur écrit pour chaque variable un type (`yType` : `DIFFERENTIAL` ou `ALGEBRAIC`) et
pour chaque équation un type (`fType` : `DIFFERENTIAL_EQ` ou `ALGEBRAIC_EQ`). Le solveur s'en sert
pour découper le système en deux sous-systèmes, résolus séparément lors des restaurations
(`DYNSolverKINAlgRestoration.cpp`) :
- **restauration algébrique** : inconnues = variables `ALGEBRAIC`, équations = `ALGEBRAIC_EQ` ;
- **restauration des dérivées** : inconnues = dérivées des variables `DIFFERENTIAL`,
  équations = `DIFFERENTIAL_EQ`.

Chaque sous-système doit être carré (`assert(numF == indexY_.size())` dans `initVarAndEqTypes()`)
et sa jacobienne ne doit avoir ni ligne ni colonne nulle (`checkJacobian`).

### Le défaut d'origine

Deux règles du générateur produisaient un typage faux :

1. **Variables** — `factory.py`, `prepare_for_evalstaticytype` forçait toute dummy derivative en
   `DIFFERENTIAL` :
   ```python
   if v.get_name() in self.reader.dummy_der_variables:
       spin = "DIFFERENTIAL"
   ```
2. **Équations** — un résidu est typé `DIFFERENTIAL_EQ` dès que son texte contient `der(`.
   `$DAEres7` et `$DAEres13` contiennent `der(x3)`, `der(x4)`… et sont donc `DIFFERENTIAL_EQ`.

Typage obtenu :

| | DIFFERENTIAL | ALGEBRAIC |
|---|---|---|
| Variables | 9 états + `x1_dummy_der` + `x2_dummy_der` = **11** | **13** |
| Équations | 9 équations d'état + `$DAEres7` + `$DAEres13` = **11** | **13** |

Les comptes sont égaux, donc l'assert passe. Mais le contenu est faux :
- `x1_dummy_der` est taguée `DIFFERENTIAL`, donc Dynawo considère sa **dérivée**
  (`d(x1_dummy_der)/dt`) comme une inconnue de la restauration des dérivées. Or aucune équation ne
  contient cette dérivée : seule la **valeur** de `x1_dummy_der` apparaît (dans `$DAEres6` et
  `$DAEres7`) ;
- dans ce sous-système, les 9 états occupent les indices 0 à 8 et `x1_dummy_der` l'indice 9 :
  c'est la ligne nulle signalée.

```
ERROR | jacobian has zero row 9: variable 'testindex_testindex_x1_dummy_der' is ill-formed
       ( DYNSolverKINAlgRestoration.cpp:318 )
```

Sur le fond, les deux équations « en trop » `$DAEres7` et `$DAEres13` ne déterminent aucune dérivée
d'état : `der(x3)`, `der(x4)`, `der(x5)` sont déjà fixés par `$DAEres0`, `2`, `4`. Le sous-système
des dérivées contient donc 11 équations pour seulement 9 dérivées réellement indépendantes. Le
forçage `DIFFERENTIAL` des dummy derivatives compensait ce surplus dans les comptes, sans le
corriger.

---

## 3. Ce qui a été fait dans le code

Seul `dynawo/sources/ModelicaCompiler/Scripts_OMC_1_13_2/factory.py` est modifié. La version
d'origine est conservée dans `factory_origin.py`. Le solveur C++ n'a pas été touché.

### 3.1 Les dummy derivatives redeviennent algébriques

`prepare_for_evalstaticytype`, forçage commenté :
```python
if is_alg_var(v) :
    spin = "ALGEBRAIC"
# if v.get_name() in self.reader.dummy_der_variables:
#     spin = "DIFFERENTIAL"
```
Une dummy derivative a le type OMC `rAlg`, donc `is_alg_var(v)` lui donne déjà `ALGEBRAIC`.

Ce correctif seul ne suffit pas. Les comptes deviennent 9 / 15 côté variables contre 11 / 13 côté
équations, et l'assert de `initVarAndEqTypes()` casse :
```
Assertion `numF == indexY_.size()' failed.   (DYNSolverKINAlgRestoration.cpp:140)
```

Une première tentative forçait en `ALGEBRAIC` « l'équation qui définit `der(x1)` », cherchée par
son nom dans `collect_eq_syst`. Elle n'avait aucun effet : en mode DAE, aucune équation ne porte le
nom `der(x1)`. Les résidus s'appellent `$DAEres7`, `$DAEres13`, etc. Elle a été retirée.

### 3.2 Retypage par appariement structurel

Nouvelle méthode `retype_redundant_differential_equations()`, appelée à la fin de
`collect_eq_syst` (bloc marqué `NEW CODE`).

1. Elle ne s'exécute que si le modèle contient des dummy derivatives. Tous les autres modèles
   gardent exactement leur typage actuel.
2. Elle construit l'ensemble des états `DIFFERENTIAL`, avec les mêmes exclusions que
   `prepare_for_evalstaticytype` (variables algébriques, auxiliaires, calculées, `MIXED`).
3. Pour chaque équation `DIFFERENTIAL`, elle relève les dérivées d'état qu'elle contient. Elle
   utilise pour cela `var_name_to_differential_dependency_variables`, rempli par `readerOMC.py`
   avec les `der(...)` du texte OMC. Les dummy derivatives, écrites `$DER.x1`, n'y figurent pas.
4. Elle calcule un appariement maximal entre équations et dérivées d'état (chemins augmentants).
   Les équations qui contiennent le moins de dérivées sont traitées en premier, ce qui fait passer
   les contraintes dérivées en dernier.
5. Toute équation `DIFFERENTIAL` restée sans dérivée attribuée est retypée `ALGEBRAIC`, avec une
   ligne dans le log de build.

Garde-fou : une équation `DIFFERENTIAL` dans laquelle aucune dérivée n'est détectée garde son type,
avec un warning.

Sur `TestIndex` :
- `$DAEres0`, `2`, `4`, `8`, `9`, `10`, `12`, `14`, `15` sont appariées à `der(x3)`, `der(x4)`,
  `der(x5)`, `der(x9)`, `der(x10)`, `der(x11)`, `der(x6)`, `der(x7)`, `der(x8)` ;
- `$DAEres7` ne trouve que `der(x3)`, `der(x4)`, `der(x5)`, déjà prises par des équations qui n'ont
  pas d'autre choix : elle reste non appariée. Idem pour `$DAEres13`.

```
[INFO]: Equation $DAEres13 retyped ALGEBRAIC: the state derivatives it contains are determined by other equations (index reduction).
[INFO]: Equation $DAEres7 retyped ALGEBRAIC: the state derivatives it contains are determined by other equations (index reduction).
```

### 3.3 Résultat

| | DIFFERENTIAL | ALGEBRAIC |
|---|---|---|
| Variables | 9 (`x3..x11`) | 15 |
| Équations | 9 | 15 |

- Les deux sous-systèmes sont carrés et chaque inconnue apparaît dans au moins une équation.
  Côté algébrique, `$DAEres7` détermine `x1_dummy_der` à partir des dérivées déjà connues, et
  `$DAEres6` relie ensuite `y1` à `x1_dummy_der`.
- `testIndex2.jobs` simule jusqu'à `stopTime = 0.5` : 316 pas de temps, 3 échecs de test d'erreur
  et 2 échecs de convergence, tous rattrapés par IDA, puis `end of job`.

### 3.4 Reproduire

```bash
# 1. installer le script modifié (sans rebuild de Dynawo)
cd build/gcc11/3152_GFM_DynVSM/Debug/shared/dynawo/sources/ModelicaCompiler/Scripts_OMC_1_13_2
make install
# 2. recompiler le modèle et lancer le cas
cd <racine du repo>
./myEnvDynawo.sh clean-build-models TestIndex
./myEnvDynawo.sh jobs-with-curves TestIndex/testIndex2.jobs
```
Les lignes `retyped ALGEBRAIC` apparaissent dans
`build/gcc11/3152_GFM_DynVSM/Debug/shared/dynawo/M/M/P/TestIndex.log`.

---

## 4. Mise en perspective avec l'article (Mattsson & Söderlind, 1993)

### Ce que dit la méthode

1. L'algorithme de Pantelides repère les équations à dériver : ici (C1) et (C2).
2. Le système augmenté (équations d'origine et dérivées) est surdéterminé pour les dérivées : il y
   a plus d'équations contenant des dérivées que de dérivées indépendantes.
3. Pour chaque équation ajoutée, on choisit une dérivée à remplacer par une nouvelle inconnue
   **algébrique**, la dummy derivative. Elle n'est pas discrétisée par l'intégrateur : rien ne
   l'oblige à rester égale à la dérivée de `x1`. C'est ce qui évite que les équations redondantes
   deviennent contradictoires après discrétisation.
4. Le choix des dérivées à remplacer se fait en sélectionnant une sous-matrice non singulière de
   la jacobienne par rapport aux dérivées d'ordre le plus élevé.

Le système obtenu est d'index 1 et l'article le résout d'un bloc avec un intégrateur BDF, sans
distinguer équations « différentielles » et « algébriques ».

### Ce qui était en contradiction dans Dynawo

- **Le forçage `DIFFERENTIAL`** contredisait directement le point 3 : une dummy derivative est par
  construction algébrique. La taguer `DIFFERENTIAL` revenait à demander au solveur sa dérivée, une
  quantité qui n'existe dans aucune équation.
- **Le typage des équations par recherche de `der(`** ignorait le point 2 : une équation peut
  contenir des dérivées sans en déterminer aucune, quand ces dérivées sont déjà fixées ailleurs.
  C'est exactement le statut de la contrainte dérivée `$DAEres7`.

### Pourquoi Dynawo a besoin d'une étape en plus

Contrairement à l'article, Dynawo ne résout pas toujours le système d'un bloc : ses restaurations
traitent séparément les équations algébriques et les équations des dérivées. Il lui faut donc une
étiquette par équation, ce que l'article n'a jamais à fournir.

Le bon critère pour cette étiquette est structurel : le sous-système des dérivées
(`∂F/∂x'`) a autant de degrés de liberté que d'états, ici 9. Une équation est « différentielle »
si elle sert à déterminer l'une de ces dérivées, « algébrique » sinon. L'appariement de la
section 3.2 applique exactement ce critère. C'est le même raisonnement que Pantelides (associer
équations et inconnues par un appariement sur la structure), appliqué cette fois aux seules
dérivées d'état, après la réduction d'index faite par OMC.

### Limites

- **Structurel, pas numérique.** L'appariement garantit que le sous-système est structurellement
  carré et sans ligne nulle, pas qu'il est bien conditionné. L'article fait la même distinction
  quand il impose que la sous-matrice choisie soit numériquement non singulière.
- **Sélection statique, pas de dummy pivoting.** L'article montre (exemple du pendule) que le choix
  des dummy derivatives peut devoir changer en cours de simulation. Ici OMC fait un choix unique à
  la compilation, et le typage Dynawo est figé de la même façon. Un modèle qui exigerait un
  changement de dummy derivative en cours de trajectoire n'est pas couvert (voir section 5).
- **Portée volontairement limitée** aux modèles qui contiennent des dummy derivatives. Il reste à
  vérifier sur un échantillon plus large de modèles de ce type (tests de non-régression).

---

## 5. État des lieux : dummy pivoting, modèles C++ et couplage entre modèles

En résumé :

- Le dummy pivoting n'est pas pris en charge, et rien dans la bibliothèque actuelle ne l'utilise.
- Les modèles C++ n'ont pas de réduction d'index : c'est le développeur qui écrit à la main une
  DAE d'index 1 et ses types.
- Le système couplé (plusieurs modèles reliés par le `.dyd`) n'est jamais réduit.

### 5.1 Dummy pivoting (section 4 de l'article)

**Rappel.** Dans un modèle non linéaire, la matrice M choisie pour les dummy derivatives peut
devenir singulière en cours de trajectoire. Il faut alors changer de dummy derivatives, et donc
d'états, pendant la simulation.

**Côté OMC.** C'est la *dynamic state selection* : des « state sets », avec des variables
`$STATESET`, une matrice de sélection et un pivotage numérique à l'exécution.

- C'est la méthode par défaut d'OMC, et les options de compilation de Dynawo ne la désactivent pas
  ([DYNCompileModelicaModel.cpp:334-335](dynawo/sources/ModelicaCompiler/DYNCompileModelicaModel.cpp#L334-L335)).
- OMC ne crée un state set que s'il ne peut pas trancher statiquement, typiquement pour le pendule
  en coordonnées cartésiennes. Pour `TestIndex` et `Example1`, il a fait un choix statique.

**Côté Dynawo, rien n'est en place :**

| Où | Constat |
|---|---|
| Générateur | [readerOMC.py:76-146](dynawo/sources/ModelicaCompiler/Scripts_OMC_1_13_2/readerOMC.py#L76-L146) liste les fichiers OMC lus, et `_04set.c` (celui des state sets) n'y figure pas. Aucun script ne mentionne `stateSet`. |
| Bibliothèque | Dans un build complet des modèles préassemblés, les 493 fichiers `_04set.c` générés contiennent tous `nStateSets = 0`. Le cas ne s'est jamais présenté. |
| Solveur | Les types ne changent qu'avec les modes : `evalDynamicFType` et `evalDynamicYType` sont appelés dans [DYNSolverKINAlgRestoration.cpp:90-91](dynawo/sources/Solvers/AlgebraicSolvers/DYNSolverKINAlgRestoration.cpp#L90-L91). Aucun critère numérique de conditionnement de M n'intervient. |

**Lors d'une restauration algébrique**
([DYNSolverIDA.cpp:802-857](dynawo/sources/Solvers/VariableTimeStep/SolverIDA/DYNSolverIDA.cpp#L802-L857)) :

- Le solveur résout d'abord en mode KIN_ALGEBRAIC, avec les états figés, puis en mode
  KIN_DERIVATIVES. Le choix des dummy derivatives n'est jamais remis en cause. Si M devient
  singulière au nouveau point, KINSOL échoue.
- Avec le `factory.py` corrigé, les dummy derivatives sont ALGEBRAIC. Elles sont donc recalculées en
  KIN_ALGEBRAIC, ce qui est conforme à l'article.
- Avec le `factory.py` original, elles sont DIFFERENTIAL. Elles ne sont pas recalculées en
  KIN_ALGEBRAIC, et en KIN_DERIVATIVES on cherche leur dérivée y', qui n'a pas de sens. C'est la
  ligne nulle de `TestIndex` (section 2).

**Ce qui s'en rapproche le plus : les variables mixtes.** Leur type change selon le mode. Le code
généré contient par exemple `if (yType[18] != DIFFERENTIAL) yType[18] = ALGEBRAIC` dans
`GridFormingConverterDroopControl`. C'est une bascule discrète décidée par le modélisateur, pas un
pivot numérique.

**Remarque sur l'assert.** Le contrôle de comptage de `initVarAndEqTypes` porte sur le système
global (`ModelMulti`), pas sur chaque modèle. Un déséquilibre dans un modèle peut donc être masqué
par un autre ; la matrice sera alors singulière sans que l'assert ne se déclenche.

### 5.2 Modèles C++

Il n'y a ni OMC, ni Pantelides, ni dummy derivatives. Le développeur écrit à la main :

- `evalF` ;
- `evalJt` et `evalJtPrim` ;
- les types statiques et dynamiques des variables et des équations.

C'est donc à lui de garantir l'index 1 :

- la jacobienne dF/dy' restreinte aux équations et variables DIFFERENTIAL doit être inversible ;
- la jacobienne dF/dy restreinte aux équations et variables ALGEBRAIC doit l'être aussi.

**Le cas d'école : la ligne dynamique C++** (paramètre `line_isDynamic`).

- **Les courants de branche** `irb` et `iib` sont DIFFERENTIAL quand la ligne est fermée et
  ALGEBRAIC quand elle est ouverte
  ([DYNModelLine.cpp:328-357](dynawo/sources/Models/CPP/ModelNetwork/DYNModelLine.cpp#L328-L357)).
- **Les deux bus passent en « tensions différentielles »**
  ([DYNModelLine.cpp:1160-1161](dynawo/sources/Models/CPP/ModelNetwork/DYNModelLine.cpp#L1160-L1161)) :
  la loi des nœuds devient DIFFERENTIAL_EQ
  ([DYNModelBusInjected.cpp:299-317](dynawo/sources/Models/CPP/ModelNetwork/DYNModelBusInjected.cpp#L299-L317)).
- **Ce typage est légitime, contrairement au forçage de `factory.py`.** Le modèle en π ajoute le
  terme capacitif `B/ω·u'` dans l'injection au nœud
  ([DYNModelLine.cpp:533-536](dynawo/sources/Models/CPP/ModelNetwork/DYNModelLine.cpp#L533-L536)).
  La loi des nœuds contient donc vraiment `u'`.
- **Les capacités aux nœuds rendent l'index 1 par construction.** Elles évitent la configuration
  d'inductances en série qui aurait donné un index 2. C'est une réduction d'index faite par la
  modélisation, et non par l'algorithme.
- **Limites, non testées.**
  - Aucune garde contre `B = 0` n'a été trouvée. Dans ce cas, `u'` disparaît de la loi des nœuds,
    et on retomberait sur une ligne nulle en KIN_DERIVATIVES, comme pour `TestIndex`. Ce point est
    confirmé et traité par la PR #4261 (section 7).
  - Les états CLOSED_1 et CLOSED_2, ainsi que les bus dynamiques, sont explicitement refusés
    ([DYNModelLine.cpp:1153-1158](dynawo/sources/Models/CPP/ModelNetwork/DYNModelLine.cpp#L1153-L1158)).

### 5.3 Le trou commun : le couplage entre modèles

OMC réduit l'index **modèle par modèle**, c'est-à-dire pour chaque `.so` compilé. Les connexions du
`.dyd` ajoutent des égalités et des lois des nœuds au moment de l'exécution, et **ce système couplé
n'est jamais réduit**. Par exemple, une inductance Modelica raccordée à un nœud C++ sans capacité,
sur lequel une source impose aussi le courant, donne un système global d'index 2. Rien dans Dynawo
ne le détecte ni ne le corrige ; le symptôme serait le même : jacobienne singulière ou ligne nulle
en restauration.

### 5.4 Synthèse

| | Modelica (OMC + générateur) | C++ |
|---|---|---|
| Réduction d'index | OMC, statique, par modèle | à la main, dans la modélisation |
| Dummy derivatives | oui ; typage corrigé dans `factory.py` | sans objet |
| Dummy pivoting / state sets | non pris en charge, jamais rencontré | non |
| Changement de type en cours de simulation | par mode (variables mixtes) | par mode (`evalDynamic*Type`) |
| Couplage inter-modèles | jamais réduit | jamais réduit |

**Tests possibles pour confirmer ces points :**

- un pendule cartésien en Modelica, pour forcer OMC à créer un state set et voir comment le
  générateur réagit ;
- une ligne C++ dynamique avec `B = 0`, pour vérifier la ligne nulle prédite.

---

## 6. La double résolution des restaurations dans Dynawo : état actuel

**Le problème à résoudre.** À l'initialisation et après chaque changement de mode, le solveur doit
trouver un point cohérent. Les états (variables DIFFERENTIAL) sont figés ; les inconnues sont les
variables algébriques `a` et les dérivées des états `d`, et toutes les équations `F = 0` doivent être
satisfaites.

**Ce que fait Dynawo : deux résolutions successives.** Les équations sont séparées selon leur type
(`fType`, seul endroit du solveur où ce type est lu :
[DYNSolverKINAlgRestoration.cpp:93](dynawo/sources/Solvers/AlgebraicSolvers/DYNSolverKINAlgRestoration.cpp#L93)) :

```
1. KIN_ALGEBRAIC   : équations ALGEBRAIC    → variables algébriques a   (dérivées d figées)
2. KIN_DERIVATIVES : équations DIFFERENTIAL → dérivées des états d      (a figées)
```

| Moment | Enchaînement |
|---|---|
| Initialisation (`calculateIC`) | KIN_ALGEBRAIC → KIN_DERIVATIVES → `IDACalcIC(IDA_YA_YDP_INIT)` ([DYNSolverIDA.cpp:425](dynawo/sources/Solvers/VariableTimeStep/SolverIDA/DYNSolverIDA.cpp#L425)) |
| Après un changement de mode (`reinit`) | KIN_ALGEBRAIC → KIN_DERIVATIVES → boucle `solveCoupledRestorations` ([DYNSolverIDA.cpp:811](dynawo/sources/Solvers/VariableTimeStep/SolverIDA/DYNSolverIDA.cpp#L811), appelée ligne 885) → `IDAReInit` |

**Pourquoi ce découpage est exact pour les modèles classiques.** Dans un modèle semi-explicite
d'index 1, les équations algébriques ne contiennent pas de dérivées (`∂F_A/∂d = 0`). Le système est
triangulaire par blocs : on calcule `a`, puis `d`, et le point est cohérent en une seule passe.

**Pourquoi il ne l'est plus après une réduction d'index.** Les contraintes dérivées par Pantelides
sont algébriques mais contiennent des dérivées d'état (par exemple f1'' : `x1'' + der(v2) = …` dans
`Example1`). KIN_ALGEBRAIC les résout avec les dérivées du point précédent, et une passe laisse un
résidu non nul sur ces équations.

**La boucle ajoutée par Florentine (commit `265f5a0676d`, marquée « POC #3152 »).** Après la première
passe, la paire KIN_ALGEBRAIC puis KIN_DERIVATIVES est répétée tant que le résidu des équations
ALGEBRAIC dépasse `fnormtolAlg` (10⁻⁴ par défaut), avec au plus 20 passes et un avertissement
`SolverIDACoupledRestorationNotConverged` en cas d'échec. C'est une itération de Gauss-Seidel par
blocs : l'erreur sur les dérivées est multipliée à chaque passe par

```
ρ = (∂F_D/∂d)⁻¹ · ∂F_D/∂a · (∂F_A/∂a)⁻¹ · ∂F_A/∂d
```

Pour un modèle classique, `ρ = 0` et une passe suffit. Avec des dummy derivatives, la boucle converge
si `|ρ| < 1`. **Ce facteur dépend du typage choisi en cas d'ex-aequo de l'appariement** : sur
`Example1`, le typage retenu (f1'' DIFFERENTIAL, f4 ALGEBRAIC) donne `ρ = 1/2`, le typage inverse,
structurellement tout aussi valide, donnerait `ρ = 2` et la boucle divergerait. Or le générateur
départage ces ex-aequo par l'ordre de numérotation d'OMC (`num_dyn`), sans regarder les coefficients.

**L'alternative : une restauration jointe.** Un seul Newton sur `(a, d)` avec toutes les équations :

```
J = [ ∂F_A/∂a   ∂F_A/∂d ]
    [ ∂F_D/∂a   ∂F_D/∂d ]
```

Elle n'a besoin que du type des variables, pas de celui des équations, et sa convergence ne dépend pas
du départage des ex-aequo. Dynawo la possède déjà : c'est `IDACalcIC(IDA_YA_YDP_INIT)`, mais elle
n'est appelée qu'à l'initialisation, pas dans `reinit`. Sa robustesse et son coût sur de gros réseaux
restent à mesurer.

| | `reinit` avant le commit | Avec la boucle de Florentine | Restauration jointe |
|---|---|---|---|
| Méthode | une passe A puis D | passes A puis D répétées (≤ 20) | un Newton sur (a, d) |
| Besoin du type des équations | oui | oui | non |
| Exact si `F_A` contient des `y'` | non | si ρ < 1 | oui |
| Disponible dans Dynawo | oui | oui (POC) | oui, à l'initialisation seulement |

**À retenir.** Le correctif de `factory.py` est structurel : il donne un typage cohérent, sans lequel
aucune des deux approches ne peut fonctionner. La convergence numérique de la restauration relève du
solveur.

---

## 7. La correction de la ligne dynamique C++ (issue #4256, PR #4261)

**Contexte.** Marco Chiaramello a ouvert l'issue
[#4256](https://github.com/dynawo/dynawo/issues/4256) et la PR
[#4261](https://github.com/dynawo/dynawo/pull/4261) (branche `4256_fix_dynamic_line_cpp_model` vers
`master`, ouverte, non relue à ce jour). Elles portent sur la ligne dynamique C++ (`ModelLine` avec
`line_isDynamic`), l'équivalent C++ de `DynLine.mo` décrit en section 5.2.

**Rappel physique.** La ligne est modélisée en π : une branche série R + L traversée par le courant de
branche `Ib`, et des capacités shunt (susceptances `B1`, `B2`) aux deux bouts. En modèle dynamique, on
garde les dérivées :

```
inductance :  L·dIb/dt = U1 − U2 − (R + jωref·L)·Ib     → Ib est un état (courant différentiel)
capacité   :  C·dU/dt  = Iinjecté − jωref·C·U           → U est un état (bus différentiel)
```

Un bus sans capacité a une loi des nœuds algébrique. Si ce bus ne relie que des branches inductives
(ou des sources de courant), la loi des nœuds devient une contrainte entre états (`Ib1 + Ib2 = 0`) :
c'est un index 2, la même situation que `x1 + x2 = u` dans `Example1`.

**Les problèmes relevés dans l'issue.**

- *Le problème principal* : une ligne dynamique déclare ses deux bus en tensions différentielles même
  si `B = 0`. La loi des nœuds est alors typée DIFFERENTIAL sans contenir de `dU/dt`, d'où une ligne
  nulle et l'échec de la restauration KIN_DERIVATIVES. C'est le symptôme de `TestIndex`, dans un
  modèle écrit à la main.
- *Des bugs d'implémentation* : index `ur`/`ui` inversés dans `evalDerivatives` ; colonnes sautées
  dans `evalJtPrim` à l'ouverture de la ligne ; courant compté deux fois dans `evalNodeInjection` ;
  courant de branche initial incluant le courant du shunt ; `omegaRef` connecté mais jamais lu ;
  injections aux nœuds non calculées pour les équations différentielles.

**Ce que fait la PR.**

- Elle corrige les bugs ci-dessus (`omegaRef()` lu dans la variable connectée, avec ses termes de
  jacobienne ; courant initial `Ib = I1 − (G1 + jB1)·U1` ; injections calculées dès qu'un bus est
  différentiel).
- **Typage des bus selon la topologie** (`flagDifferentialBuses`) : à chaque évaluation des types, les
  bus sont remis à « algébrique », puis chaque ligne dynamique fermée marque son bus comme
  différentiel seulement si sa susceptance de ce côté est non nulle. Le type d'un bus peut donc
  changer après un événement de topologie.
- **Repli quasi-statique** (`isSeriesDifferential`, point soumis à discussion par l'auteur) : si l'un
  des deux bus n'a pas de tensions différentielles, le courant de branche passe en ALGEBRAIC et
  l'équation de branche perd son terme `L·dIb/dt` :

  ```
  0 = ωn·(U1 − U2 + jL·ωref·Ib − R·Ib)
  ```

  Cela évite l'index 2 à l'initialisation et le courant inductif figé après un changement de
  topologie. Des logs signalent les lignes concernées (nombre en INFO, liste en DEBUG). Un test de
  non-régression est ajouté (IEEE30, perte du groupe G1 au nœud B2, lignes dynamiques).

**Mise en perspective avec les dummy derivatives.** Les deux approches traitent le même problème
d'index (une branche inductive qui arrive sur un nœud sans capacité), de deux façons différentes :

| | Modelica (`DynLine.mo` + OMC) | C++ (PR #4261) |
|---|---|---|
| Méthode | dérivation de la contrainte, dummy derivatives | suppression de `L·dIb/dt` (quasi-statique) |
| Dynamique de la branche | conservée exactement | perdue (approximation) |
| Typage | reconstruit par le générateur (`factory.py`) | écrit à la main, selon la topologie |

**Points d'attention.**

- Le repli est conservateur : il s'applique dès qu'un bus n'a pas de capacité, même si ce bus porte
  des injections qui dépendent de sa tension (charge, générateur), cas où l'index reste 1 et où la
  dynamique de la branche pourrait être gardée.
- Une ligne déclarée dynamique peut devenir statique selon les susceptances du jeu de données ; seul
  le log l'indique.
- Le couplage avec des modèles Modelica qui imposent un courant (section 5.3) n'est pas couvert.
- Le type des bus change avec la topologie, donc passe par `evalDynamicYType`, les changements de mode
  et `reinit` : l'interaction avec la boucle de restauration de la section 6 reste à vérifier.

---

## 8. Session du 23 novembre 2026 : la restauration itérée peut diverger (`Example1Event`)

Objectif : montrer, avec le `factory.py` actuel et sans rien forcer, que la boucle de restaurations
répétées ajoutée dans `SolverIDA::reinit` (section 6) peut converger, stagner ou diverger selon la
valeur d'un seul coefficient du modèle.

### 8.1 Le modèle et le cas test

`Examples/IndexReduction/Example1Event.mo` reprend `Example1` (f2 réécrite en f2 − f1) avec deux
changements :

- le coefficient de `der(v1)` dans f4 devient un paramètre `k` (2 dans l'article) ;
- une marche d'amplitude `uStepPu` à `tEvent` est appliquée sur l'entrée de f4, via une variable `u4` :

```modelica
u4 = if time < tEvent then cos(2 * time) else cos(2 * time) + uStepPu;
k * der(v1) + der(v2) + der(v3) + der(x4) + u4 = 0.0;
```

La marche sert à deux choses : déclencher un changement de mode (sans événement, `reinit` et donc la
boucle ne sont jamais appelés) et faire sauter `der(v2)`, pour que la restauration ait une erreur à
corriger.

Cas test : `Example1/Event/` (`example1event.jobs`, `.dyd`, `.par`, `.crv`). Les paramètres d'un modèle
préassemblé sont préfixés par l'identifiant du `unitDynamicModel` : `example1event_k`,
`example1event_tEvent`, `example1event_uStepPu`. Changer `k` dans le `.par` ne demande pas de
recompiler.

**Deux écueils rencontrés.**

- Avec le `if` écrit directement dans f4, l'assert `numF == indexY_.size()` revient. Cause : un défaut
  du correctif. `readerOMC.py` range toute équation contenant un `if` dans
  `var_name_to_mixed_residual_vars_types`
  ([readerOMC.py:714-735](dynawo/sources/ModelicaCompiler/Scripts_OMC_1_13_2/readerOMC.py#L714-L735)),
  même si toutes ses branches ont le même type. L'appariement exclut toute équation présente dans cette
  table ([factory.py:1081](dynawo/sources/ModelicaCompiler/Scripts_OMC_1_13_2/factory.py#L1081)) au
  lieu d'exclure seulement les équations de type `MIXED`. f4 n'est donc jamais retypée. Correction
  proposée, testée hors ligne et **non appliquée à ce jour** : garder seulement la condition
  `eq.get_type() != DIFFERENTIAL and eq.get_type() != ALGEBRAIC`. Contournement retenu ici : placer le
  `if` dans l'équation de `u4`, comme `u1` dans `TestIndex/Event`.
- Effet secondaire du même défaut : une relation contenue dans une équation typée DIFFERENTIAL produit
  un `DIFFERENTIAL_MODE`, pour lequel `reinit` ne lance pas la restauration algébrique (section 8.7).

### 8.2 La théorie : pourquoi `k` décide

Après réduction d'index, OMC garde `x2` et `v2` comme états. À l'événement, seules deux inconnues de la
restauration sont couplées, `v1d = x1''` (dummy derivative) et `v2'` (vraie dérivée), par deux
équations :

```
f1'' :      v1d + v2' = sin t*
f4   :    k·v1d + v2' = −C          (C : tout ce qui est connu dans f4, marche comprise)
```

Solution exacte : `(1 − k)·v2'* = −k·sin t* − C`. Le système est singulier pour `k = 1`. À
l'événement, `v2'*` saute de `−uStepPu / (1 − k)`.

Typage choisi par `factory.py` (ex-aequo départagé par l'ordre `num_dyn` d'OMC) : f1'' DIFFERENTIAL
(détermine `v2'`), f4 ALGEBRAIC (détermine `v1d`). Une passe de la boucle :

```
KIN_ALGEBRAIC   :  v1d(n) = −(v2'(n−1) + C) / k
KIN_DERIVATIVES :  v2'(n) = sin t* − v1d(n)
```

En notant `e(n) = v2'(n) − v2'*`, on obtient :

```
e(n) = e(n−1) / k = e(0) / kⁿ          ρ = 1/k          e(0) = uStepPu / (1 − k)
```

Le test d'arrêt de la boucle (`algebraicResidualNorm`) ne voit que le résidu de f4 :

```
r(n) = |e(n) − e(n−1)| = uStepPu / |k|ⁿ
```

La boucle converge si `|k| > 1` et diverge si `|k| < 1`. Avec le typage inverse, `ρ = k` : la règle
s'inverse. Pour `k = −1`, `ρ = −1` avec les deux typages : le système est bien posé (déterminant 2),
mais aucun typage ne fait converger la boucle.

En général, pour un bloc couplé `[[a, b], [c, d]]`, `ρ = (a·d)/(b·c)` pour un typage et l'inverse pour
l'autre. ρ ne dépend pas de l'échelle des équations ni des inconnues : ce sont les rapports qui
comptent, pas le fait qu'un coefficient soit plus grand ou plus petit que 1. Le bon typage est celui qui
maximise le produit des pivots. Quand `|a·d| = |b·c|` avec un déterminant non nul, aucun typage ne
convient.

### 8.3 Les résultats (même `.so`, seul `example1event_k` change)

| `k` | ρ | Boucle | `der(v2)` restaurée | Simulation |
|---|---|---|---|---|
| 2 | 1/2 | converge en 14 passes (prédit : 14), sans message | 2,656 (valeur exacte : 2,656) | va jusqu'à 2 s, 0 échec du test d'erreur |
| −1 | −1 | stagne : 20 passes, avertissement, résidu 0,9989 (prédit : 1) | 0,0565, soit la valeur d'avant l'événement (exacte : −0,443) | va jusqu'à 2 s, IDA rattrape l'erreur |
| 0,5 | 2 | diverge : 20 passes, avertissement, résidu 1,0495·10⁶ (prédit : 2²⁰ ≈ 1,0486·10⁶) | 2,099·10⁶ (prédit : 2²¹ ≈ 2,097·10⁶) | échec : test d'erreur répété, pas réduit à 4·10⁻⁹ |

Chaque passe coûte deux évaluations de résidu par solveur KINSOL (résidu initial plus une itération de
Newton, le système étant linéaire) : 28 évaluations pour `k = 2` (14 passes), 40 pour les cas à 20
passes.

Pour `k = −1`, après un nombre pair de passes, `der(v2)` revient exactement à sa valeur d'avant
l'événement : la boucle n'a rien fait. Pour `k = 0,5`, la boucle aggrave l'erreur : une passe unique
aurait laissé `e(1) = 4`, que 19 passes supplémentaires multiplient par 2¹⁹.

### 8.4 Pourquoi IDA ne suffit pas à rattraper la restauration

Au premier pas après l'événement, le Newton d'IDA résout tout le système conjointement, mais en
`t* + h` et non en `t*`, et son test d'erreur compare sa prédiction `y(t*) + h·ẏ(t*)` à la correction.
Une erreur `e` sur la dérivée restaurée impose donc :

```
h ≲ tol / e
```

Avec `tol = 10⁻⁴` : pour `e = 0,5` (`k = −1`), `h ≲ 2·10⁻⁴`, ce qui est possible ; pour `e = 2·10⁶`
(`k = 0,5`), `h ≲ 5·10⁻¹¹`, sous le pas minimal, d'où l'échec. IDA absorbe une incohérence modérée,
pas une grande.

De plus, les valeurs au point restauré servent avant qu'IDA ne reparte : `reinit` évalue les fonctions
de racine en `t*` (`evalG`) pour détecter les événements en cascade, et les sorties en `t*` sont celles
du point restauré. Après une réduction d'index, les variables algébriques dépendent des dérivées
(`v1d` dépend de `v2'`) : une dérivée fausse rend aussi ces variables fausses.

### 8.5 La restauration jointe : pourquoi elle n'est pas en place

Définition : à `x` figé (états continus, ou réinitialisés par l'événement), résoudre en un seul Newton
`F(t*, x, ẋ, y) = 0` pour `(ẋ, y)`, avec la jacobienne `[∂F/∂ẋ  ∂F/∂y]`. Ce système est bien posé
exactement quand la DAE est d'index 1, ce que garantit la réduction d'index. Il ne demande que le type
des variables, pas celui des équations. C'est ce que fait `IDACalcIC(IDA_YA_YDP_INIT)`.

Historique : la restauration en deux temps date du premier commit public (`598ed68ecbf`,
29 janvier 2019). `reinit` y enchaîne déjà un KINSOL pour les variables algébriques et un second en mode
`KIN_YPRIM`, et `IDACalcIC` n'est utilisé qu'à l'initialisation. Les commits suivants (`c8e5b76045c`
#384, #919, #1413, #1974) ont réorganisé ce code sans le remettre en cause. La justification du choix
n'apparaît pas dans le dépôt public ; elle est à demander aux auteurs (RTE).

Hypothèses, par ordre de plausibilité : (1) ce n'était pas nécessaire, la bibliothèque étant écrite en
forme semi-explicite d'index 1, où le découpage est exact ; (2) la performance sur de gros réseaux avec
beaucoup d'événements, les optimisations existantes supposant le découpage ; (3) la robustesse et le
réglage fin de KINSOL ; (4) le partage du code avec les solveurs à pas fixe, qui n'ont pas
d'`IDACalcIC`. Arguments pour et contre détaillés : section 6.

### 8.6 Les pistes et leur compatibilité

| Piste | Principe | Limites |
|---|---|---|
| A. Typage au plus grand pivot | choisir l'appariement qui maximise le produit des pivots | coefficients connus seulement à l'exécution (paramètres, point de fonctionnement) : impossible dans `factory.py`, à faire dans le solveur ; échoue pour `k = −1` |
| B. Arrêt sur résidu croissant | s'arrêter dès que le résidu ne baisse plus et garder la meilleure itération | ne rend pas le point cohérent, seulement « pas pire » |
| C. Restauration jointe en secours | si la boucle échoue, un Newton sur `(ẋ, y)` | à écrire (ou `IDACalcIC`, propre à IDA) |
| D. Accélération (Aitken, Anderson) | extrapoler à partir des itérations successives | exact pour un couplage linéaire à une dimension, `k = −1` compris ; moins garanti en général |
| E. Restauration jointe pour les seuls modèles couplés | détecter le couplage (termes de `JtPrim` sur des lignes ALGEBRAIC) et résoudre conjointement d'emblée | même travail d'écriture que C ; aucun impact sur les modèles classiques |
| F. Restauration par blocs (tri BLT) | ne résoudre en bloc que le sous-système couplé (`{v1d, v2'}`) | la plus complexe |
| G. Passe unique (état avant la boucle) | laisser IDA corriger | variables algébriques fausses en `t*` ; échec si l'erreur est grande |
| H. Côté modèle | écrire ou reformuler les modèles en index 1 | ne couvre pas les modèles qui ont besoin de la réduction |

Ces pistes se combinent. La combinaison simple et robuste est **B + C** : la boucle s'arrête dès que le
résidu ne baisse plus, puis la restauration jointe prend le relais si le résidu reste au-dessus de la
tolérance. D et A ne sont que des optimisations qui rendent le secours moins fréquent, D étant plus
efficace que A. E est l'alternative directe, sans boucle.

### 8.7 Où le type des équations intervient dans Dynawo

| Usage | Où | Effet |
|---|---|---|
| Restauration algébrique | [DYNSolverKINAlgRestoration.cpp:93](dynawo/sources/Solvers/AlgebraicSolvers/DYNSolverKINAlgRestoration.cpp#L93), `algebraicResidualNorm` ([DYNSolverIDA.cpp:801](dynawo/sources/Solvers/VariableTimeStep/SolverIDA/DYNSolverIDA.cpp#L801)) | découpage KIN_ALGEBRAIC / KIN_DERIVATIVES et test d'arrêt de la boucle |
| Classement des changements de mode (à la génération) | `evalMode` généré ([dataContainer.py:2201-2208](dynawo/sources/ModelicaCompiler/Scripts_OMC_1_13_2/dataContainer.py#L2201-L2208)) | relation dans une équation DIFFERENTIAL → `DIFFERENTIAL_MODE`, dans une équation ALGEBRAIC → `ALGEBRAIC_MODE`. Par défaut, la restauration n'est lancée qu'à partir d'`ALGEBRAIC_MODE` : le typage décide si elle a lieu |
| Solveurs à pas fixe (SIM, TRAP) | `SolverKINEuler::solve` ([DYNSolverKINEuler.cpp:166-169](dynawo/sources/Solvers/AlgebraicSolvers/DYNSolverKINEuler.cpp#L166-L169)), option `skipAlgebraicResidualsEvaluation` | à la première itération de Newton d'un pas, seules les équations DIFFERENTIAL sont évaluées |

L'avance en temps d'IDA n'utilise pas le type des équations ; elle ne reçoit que celui des variables
(`IDASetId`), pour appliquer la formule BDF et exclure les variables algébriques du test d'erreur.

Conséquence : une restauration jointe supprimerait le premier usage, pas les deux autres. Un typage
correct des équations dans `factory.py` resterait nécessaire.

### 8.8 Reste à faire

- Corriger l'exclusion des équations conditionnelles dans `factory.py` (ligne 1081, section 8.1) et
  signaler par un avertissement toute équation DIFFERENTIAL exclue de l'appariement.
- Présenter les trois cas d'`Example1Event` à Florentine, avec les pistes B + C ou E.
- Interroger les auteurs du code de restauration sur le choix historique de la restauration en deux
  temps.
- Supprimer les doublons `factory_new.py` et `factory_origin.py`, et lancer les tests de
  non-régression avec la correction et les commits de Florentine.
