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
- Avec `factory_new.py`, les dummy derivatives sont ALGEBRAIC. Elles sont donc recalculées en
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
    et on retomberait sur une ligne nulle en KIN_DERIVATIVES, comme pour `TestIndex`.
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
| Dummy derivatives | oui ; typage corrigé par `factory_new.py` | sans objet |
| Dummy pivoting / state sets | non pris en charge, jamais rencontré | non |
| Changement de type en cours de simulation | par mode (variables mixtes) | par mode (`evalDynamic*Type`) |
| Couplage inter-modèles | jamais réduit | jamais réduit |

**Tests possibles pour confirmer ces points :**

- un pendule cartésien en Modelica, pour forcer OMC à créer un state set et voir comment le
  générateur réagit ;
- une ligne C++ dynamique avec `B = 0`, pour vérifier la ligne nulle prédite.
