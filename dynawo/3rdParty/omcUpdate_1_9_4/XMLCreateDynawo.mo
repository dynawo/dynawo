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
*/

 /****************************************************************************************************
 * This file is part of OpenModelica.
 *
 *  XMLCreateDynawo permits the dumping of DAE as XML file for Dynawo software
 *
 ****************************************************************************************************
 */

encapsulated package XMLCreateDynawo
" file:        XMLCreateDynawomo
  package:     XMLCreateDynawo
  description: Dumping of DAE as XML for Dynawo software

  Author : Alain DUTOYA - InckA - Juin 2014
  "

//... public imports
//--------------------------------------------------
public import Absyn;
public import BackendDAE;
public import DAE;
public import Values;
public import SCode;

//... protected imports
//--------------------------------------------------
protected
import Algorithm;
import Array;
import BackendDAETransform;
import BackendDAEUtil;
import BackendDump;
import BackendEquation;
import BackendDAEEXT;
import BackendVarTransform;
import BackendVariable;
import BaseHashTable;
import CheckModel;
import ClassInf;
import ComponentReference;
import DAEUtil;
import DAEDump;
import Debug;
import Differentiate;
import Expression;
import ExpressionDump;
import ExpressionSolve;
import ExpressionSimplify;
import Error;
import Flags;
import HashTableExpToIndex;
import HpcOmTaskGraph;
import List;
import Matching;
import Print;
import MetaModelica.Dangerous;
import RewriteRules;
import Sorting;
import SynchronousFeatures;
import Types;
import Util;
import ValuesUtil;

//... Parameters
//--------------------------------------------------

  // General
  //==========
  protected constant String HEADER  = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";

  protected constant String RTE_OPEN  = "model";
  protected constant String RTE_CLOSE = "model";

  protected constant String RTE_MODELNAME = "name";

  // VARIABLE
  //==========
  protected constant String RTE_VARIABLES_LIST       = "elements";
  protected constant String RTE_DESIGNATION_VARIABLE = "terminal";
  protected constant String RTE_STRUCT   = "struct";
  protected constant String RTE_SUBNODES = "subnodes";

  protected constant String RTE_STRUCTURE = "className";
  protected constant String VAR_PATH = "path";

  //This is the name that identifies the Variables' block. It's also used to compose the other
  //Variables' names, such as KnownVariables, OrderedVariables, and so on.
  protected constant String RTE_VARIABLES  = "variables";
  protected constant String RTE_VARIABLES_ = "Variables";
  //This is used all the time a variable is referenced.
  protected constant String RTE_VARIABLE = "variable";

  protected constant String ORDERED  = "var_dlow_";


  protected constant String ELEMENT  = "element";
  protected constant String ELEMENT_ = "Element";

  protected constant String INDEX = "index";
  protected constant String VALUE = "value";

  protected constant String LIST_ = "List";

  //Is the Dimension attribute of a list element.
  protected constant String DIMENSION              = "dimension";
  //Is the reference attribute for an element.
  protected constant String ID                     = "id";
  protected constant String ID_                    = "Id";
  protected constant String CONDITION              = "Condition";

  //This is the String attribute for the textual representation of the expressions.
  protected constant String EXP_STRING               = "string";

  protected constant String KNOWN    = "known";
  protected constant String EXTERNAL = "external";
  protected constant String ALIAS    = "alias";

  protected constant String CLASSES  = "classes";
  protected constant String CLASSES_ = "Classes";

  protected constant String CLASS   = "class";
  protected constant String CLASS_  = "Class";
  protected constant String NAMES_  = "Names";

  protected constant String VAR_COUNT    = "number";
  protected constant String VAR_ID       = ID;
  protected constant String VAR_NAME     = "name";
  protected constant String VAR_INDEX    = "differentiatedIndex";

  protected constant String STATE_SELECT_NEVER   = "Never";
  protected constant String STATE_SELECT_AVOID   = "Avoid";
  protected constant String STATE_SELECT_DEFAULT = "Default";
  protected constant String STATE_SELECT_PREFER  = "Prefer";
  protected constant String STATE_SELECT_ALWAYS  = "Always";

  // CONNECTOR
  //===========
  protected constant String VAR_CONNECTOR = "connector";
  protected constant String VAR_CONNECTOR_POTENTIAL    = "Potential";
  protected constant String VAR_CONNECTOR_FLOW         = "Flow";
  protected constant String VAR_CONNECTOR_STREAM       = "Stream";
  protected constant String VAR_CONNECTOR_NOTCONNECTOR = "Non_Connector";

  // VARIABILITY
  //============
  ///  TO CORRECT WITHIN THE OMC!!!  ///
  // The variability is related to the
  // possible values a variable can assume
  // In this case also information for the
  // variable are stored. For example it would be useful
  // to print the information about state, dummyState, dummyDer separately.

  //In addition to this there's a problem with the discrete states,
  //since they aren't recognised as states.
  protected constant String VAR_VARIABILITY = "kind";

  protected constant String VARIABILITY_CONTINUOUS            = "continuous";
  protected constant String VARIABILITY_CONTINUOUS_STATE      = "continuousState";
  protected constant String VARIABILITY_CONTINUOUS_DUMMYDER   = "continuousDummyDer";
  protected constant String VARIABILITY_CONTINUOUS_DUMMYSTATE = "continuousDummyState";
  protected constant String VARIABILITY_DISCRETE              = "discrete";
  protected constant String VARIABILITY_PARAMETER             = "parameter";
  protected constant String VARIABILITY_CONSTANT              = "constant";
  protected constant String VARIABILITY_EXTERNALOBJECT        = "externalObject";

  // TYPE
  //=====
  protected constant String VAR_TYPE                    = "type";
  protected constant String VARTYPE_INTEGER             = "Integer";
  protected constant String VARTYPE_REAL                = "Real";
  protected constant String VARTYPE_STRING              = "String";
  protected constant String VARTYPE_BOOLEAN             = "Boolean";
  protected constant String VARTYPE_ENUM                = "Enum";
  protected constant String VARTYPE_ENUMERATION         = "enumeration";
  protected constant String VARTYPE_EXTERNALOBJECT      = "ExternalObject";

  // DIRECTION
  //==========
  protected constant String VAR_DIRECTION         = "direction";
  protected constant String VARDIR_INPUT          = "input";
  protected constant String VARDIR_OUTPUT         = "output";
  protected constant String VARDIR_NONE           = "none";

  // ATTRIBUT
  //=========
  protected constant String VAR_FIXED             = "fixed";
  protected constant String VAR_COMMENT           = "comment";
  protected constant String VAR_ATTRIBUTES_VALUES = "attributesValues";
  protected constant String VAR_ATTR_QUANTITY     = "quantity";
  protected constant String VAR_ATTR_UNIT         = "unit";
  protected constant String VAR_ATTR_DISPLAY_UNIT = "displayUnit";
  protected constant String VAR_ATTR_STATESELECT  = "stateSelect";
  protected constant String VAR_ATTR_MINVALUE     = "minValue";
  protected constant String VAR_ATTR_MAXVALUE     = "maxValue";
  protected constant String VAR_ATTR_NOMINAL      = "nominal";
  protected constant String VAR_ATTR_INITIALVALUE = "initialValue";
  protected constant String VAR_ATTR_FIXED        = "fixed";

  //Name of the element representing the subscript, for example the array's index.
  protected constant String SUBSCRIPT               = "subscript";

  //Additional info for variables.
  protected constant String HASH_TB_CREFS_LIST          = "hashTb";
  protected constant String HASH_TB_STRING_LIST_OLDVARS = "hashTbOldVars";

  //All this constants below are used in the createDAE2Dynawo method.
  protected constant String SIMPLE             = "simple";
  protected constant String INITIAL            = "initial";
  protected constant String ZERO_CROSSING      = "zeroCrossing";
  protected constant String SAMPLES            = "Samples";

  protected constant String RESIDUAL     = "residual";
  protected constant String RESIDUAL_    = "Residual";

  protected constant String FUNCTIONS               = "functions";
  protected constant String FUNCTION                = "function";
  protected constant String FUNCTION_NAME           = "name";
  protected constant String NAME_BINDINGS           = "nameBindings";
  protected constant String C_NAME                  = "cName";
  protected constant String C_IMPLEMENTATIONS       = "cImplementations";
  protected constant String MODELICA_IMPLEMENTATION = "ModelicaImplementation";


  protected constant String MATH                   = "math";
  protected constant String MathML                 = "MathML";
  protected constant String MathMLApply            = "apply";
  protected constant String MathMLWeb              = "http://www.w3.org/1998/Math/MathML";
  protected constant String MathMLXmlns            = "xmlns";
  protected constant String MathMLType             = "type";
  protected constant String MathMLNumber           = "cn";
  protected constant String MathMLVariable         = "ci";
  protected constant String MathMLConstant         = "constant";
  protected constant String MathMLInteger          = "integer";
  protected constant String MathMLReal             = "real";
  protected constant String MathMLVector           = "vector";
  protected constant String MathMLMatrixrow        = "matrixrow";
  protected constant String MathMLMatrix           = "matrix";
  protected constant String MathMLTrue             = "true";
  protected constant String MathMLFalse            = "false";
  protected constant String MathMLAnd              = "and";
  protected constant String MathMLOr               = "or";
  protected constant String MathMLNot              = "not";
  protected constant String MathMLEqual            = "eq";
  protected constant String MathMLLessThan         = "lt";
  protected constant String MathMLLessEqualThan    = "leq";
  protected constant String MathMLGreaterThan      = "gt";
  protected constant String MathMLGreaterEqualThan = "geq";
  protected constant String MathMLEquivalent       = "equivalent";
  protected constant String MathMLNotEqual         = "neq";
  protected constant String MathMLPlus             = "plus";
  protected constant String MathMLMinus            = "minus";
  protected constant String MathMLTimes            = "times";
  protected constant String MathMLDivide           = "divide";
  protected constant String MathMLPower            = "power";
  protected constant String MathMLTranspose        = "transpose";
  protected constant String MathMLScalarproduct    = "scalarproduct";
  protected constant String MathMLVectorproduct    = "vectorproduct";
  protected constant String MathMLInterval         = "interval";
  protected constant String MathMLSelector         = "selector";

  protected constant String MathMLIfClause         = "piecewise";
  protected constant String MathMLIfBranch         = "piece";
  protected constant String MathMLElseBranch       = "otherwise";

  protected constant String MathMLOperator         = "mo";
  protected constant String MathMLArccos           = "arccos";
  protected constant String MathMLArcsin           = "arcsin";
  protected constant String MathMLArctan           = "arctan";
  protected constant String MathMLLn               = "ln";
  protected constant String MathMLLog              = "log";

//---------------------------------------------------------------------------
public function binopSymbol "
function: binopSymbol
  Return a string representation of the Operator
  corresponding to the MathML encode. "
  input DAE.Operator inOperator;
  output String outString;
algorithm
  outString:=
  match (inOperator)
    local
      DAE.Ident s;
      DAE.Operator op;
    case op
      equation
        s = binopSymbol2(op);
      then
        s;
  end match;
end binopSymbol;

public function binopSymbol2 "
Helper function to binopSymbol"
  input DAE.Operator inOperator;
  output String outString;
algorithm
  outString:=
  match (inOperator)
    local String error_msg;
    case (DAE.ADD(ty = _)) then MathMLPlus;
    case (DAE.SUB(ty = _)) then MathMLMinus;
    case (DAE.MUL(ty = _)) then MathMLTimes;
    case (DAE.DIV(ty = _)) then MathMLDivide;
    case (DAE.POW(ty = _)) then MathMLPower;
    case (DAE.ADD_ARR(ty = _)) then MathMLPlus;
    case (DAE.SUB_ARR(ty = _)) then MathMLMinus;
    case (DAE.MUL_ARRAY_SCALAR(ty = _)) then MathMLTimes;
    case (DAE.MUL_SCALAR_PRODUCT(ty = _)) then MathMLScalarproduct;
    case (DAE.MUL_MATRIX_PRODUCT(ty = _)) then MathMLVectorproduct;
    case (DAE.DIV_ARRAY_SCALAR(ty = _)) then MathMLDivide;
    else
      equation
        error_msg = "in XMLCreateDynawo.binopSymbol2 - Unknown operator: ";
        error_msg = error_msg + ExpressionDump.debugBinopSymbol(inOperator);
        Error.addMessage(Error.INTERNAL_ERROR, {error_msg});
      then
        fail();
  end match;
end binopSymbol2;

public function dumpAbsynPathLst "
This function prints a list of Absyn.Path using an XML representation.
If the list of element is empty the methods doesn't print nothing,
otherwise, depending on the value of the second input (the String content) prints:
<Content>
  ...//List of paths
</Content>
"
  input list<Absyn.Path> absynPathLst;
  input String Content;
algorithm
  _ := matchcontinue (absynPathLst,Content)
    local
      Integer len;
    case ({},_)
      then();
    case (_,_)
      equation
        len = listLength(absynPathLst);
        len >= 1 = false;
      then ();
    case (_,_)
      equation
        len = listLength(absynPathLst);
        len >= 1 = true;
        dumpStrOpenTag(Content);

        //str =Absyn.pathStringNoQual(absynPathLst); Avoir Alain
        dumpAbsynPathLst2(absynPathLst);

        dumpStrCloseTag(Content);
      then();
  end matchcontinue;
end dumpAbsynPathLst;

protected function dumpAbsynPathLst2 "
This is an helper function to the dunmAbsynPathList method.
"
  input list<Absyn.Path> absynPathLst;
algorithm
  _:= match (absynPathLst)
        local
          list<Absyn.Path> apLst;
          Absyn.Path ap;
          String str;
      case {} then ();
      case (ap :: apLst)
      equation
        str=Absyn.pathStringNoQual(ap);
        dumpStrTagContent(ELEMENT,str);
        dumpAbsynPathLst2(apLst);
      then();
    end match;
end dumpAbsynPathLst2;

protected function dumpComment "
Function for adding comments using the XML tag.
"
  input String inComment;
algorithm
  Print.printBuf("<!--");
  Print.printBuf(Util.xmlEscape(inComment));
  Print.printBuf("-->");
end dumpComment;

protected function getEqsList
  input BackendDAE.EqSystem syst;
  input list<BackendDAE.Equation> inEqns;
  output list<BackendDAE.Equation> outEqns;
protected
  list<BackendDAE.Equation> eqnsl;
algorithm
  eqnsl := BackendEquation.equationList(BackendEquation.getEqnsFromEqSystem(syst));
  outEqns := listAppend(inEqns,eqnsl);
end getEqsList;

public function dumpDirectionStr "
This function dumps the varDirection of a variable:
 it could be:
 - input
 - output
"
  input DAE.VarDirection inVarDirection;
  output String outString;
algorithm
  outString:=
  match (inVarDirection)
    local String error_msg;
    case DAE.INPUT()  then VARDIR_INPUT;
    case DAE.OUTPUT() then VARDIR_OUTPUT;
    case DAE.BIDIR()  then VARDIR_NONE;
    else
      equation
        error_msg = "in XMLCreateDynawo.dumpDirectionStr - Unknown var direction";
        Error.addMessage(Error.INTERNAL_ERROR, {error_msg});
      then
        fail();
  end match;
end dumpDirectionStr;

public function dumpExp
"This function prints a complete expression
  as a MathML. The content is like:
  <MathML>
  <MATH xmlns=\"http://www.w3.org/1998/Math/MathML\">
  DAE.Exp
  </MATH>
  </MathML>"
  input DAE.Exp e;
  //output String s;
  input Boolean addMathMLCode;
algorithm
  _:=
  matchcontinue (e,addMathMLCode)
    local
      DAE.Exp inExp;
    case(inExp,true)
      equation
        dumpStrOpenTag(MathML);
        dumpStrOpenTagAttr(MATH, MathMLXmlns, MathMLWeb);
        dumpExp2(inExp);
        dumpStrCloseTag(MATH);
        dumpStrCloseTag(MathML);
      then();
    case(_,false)
      then();
    case(_,_) then();
  end matchcontinue;
end dumpExp;

public function dumpExp2
"Helper function to dumpExpression. It can also
  be used if it's not necessary to print the headers
  (MathML and MATH tags)."
  input DAE.Exp inExp;
algorithm
  _:=
  matchcontinue (inExp)
    local
      DAE.Ident s,sym,res,str;
      DAE.Ident fs;
      Integer x,ival;
      Real rval;
      DAE.ComponentRef c;
      DAE.Type t,tp;
      DAE.Exp e1,e2,e,start,stop,step,cr,dim,cond,tb,fb;
      DAE.Operator op;
      Absyn.Path fcn;
      list<DAE.Exp> args,es;
      list<list<DAE.Exp>> ebs;
    case (DAE.ICONST(integer = x))
      equation
        dumpStrMathMLNumberAttr(intString(x),MathMLType,MathMLInteger);
      then ();
    case (DAE.RCONST(real = rval))
      equation
        dumpStrMathMLNumberAttr(realString(rval),MathMLType,MathMLReal);
      then ();
    case (DAE.SCONST(string = s))
      equation
        dumpStrMathMLNumberAttr(Util.xmlEscape(s),MathMLType,MathMLConstant);
      then ();
    case (DAE.BCONST(bool = false))
      equation
        dumpStrOpenTag(MathMLApply);
        dumpStrVoidTag(MathMLFalse);
        dumpStrCloseTag(MathMLApply);
      then ();
    case (DAE.BCONST(bool = true))
      equation
        dumpStrOpenTag(MathMLApply);
        dumpStrVoidTag(MathMLTrue);
        dumpStrCloseTag(MathMLApply);
      then ();
    case (DAE.CREF(componentRef = c,ty = t))
      equation
        s = ComponentReference.printComponentRefStr(c);
        dumpStrMathMLVariable(s);
      then ();
    case (e as DAE.BINARY(e1,op,e2))
      equation
        sym = binopSymbol(op);
        dumpStrOpenTag(MathMLApply);
        dumpStrVoidTag(sym);
        dumpExp2(e1);
        dumpExp2(e2);
        dumpStrCloseTag(MathMLApply);
      then ();
     case ((e as DAE.UNARY(op,e1)))
      equation
        sym = unaryopSymbol(op);
        dumpStrOpenTag(MathMLApply);
        dumpStrVoidTag(sym);
        dumpExp2(e1);
        dumpStrCloseTag(MathMLApply);
      then ();
   case ((e as DAE.LBINARY(e1,op,e2)))
      equation
        sym = lbinopSymbol(op);
        dumpStrOpenTag(MathMLApply);
        dumpStrVoidTag(sym);
        dumpExp2(e1);
        dumpExp2(e2);
        dumpStrCloseTag(MathMLApply);
      then ();
   case ((e as DAE.LUNARY(op,e1)))
      equation
        sym = lunaryopSymbol(op);
        dumpStrOpenTag(MathMLApply);
        dumpStrVoidTag(sym);
        dumpExp2(e1);
        dumpStrCloseTag(MathMLApply);
      then();
   case ((e as DAE.RELATION(exp1=e1,operator=op,exp2=e2)))
      equation
        sym = relopSymbol(op);
        dumpStrOpenTag(MathMLApply);
        dumpStrVoidTag(sym);
        dumpExp2(e1);
        dumpExp2(e2);
        dumpStrCloseTag(MathMLApply);
      then ();
    case ((e as DAE.IFEXP(cond,tb,fb)))
      equation
        dumpStrOpenTag(MathMLApply);
        dumpStrOpenTag(MathMLIfClause);
        dumpStrOpenTag(MathMLIfBranch);
        dumpExp2(tb);
        dumpExp2(cond);
        dumpStrCloseTag(MathMLIfBranch);
        dumpStrOpenTag(MathMLElseBranch);
        dumpExp2(fb);
        dumpStrCloseTag(MathMLElseBranch);
        dumpStrCloseTag(MathMLIfClause);
        dumpStrCloseTag(MathMLApply);
      then ();
    case (DAE.CALL(path = Absyn.IDENT(name = "der"),expLst = args))
      equation
        dumpStrOpenTag(MathMLApply);
        dumpStrVoidTag("diff");
        dumpList(args,dumpExp2);
        dumpStrCloseTag(MathMLApply);
      then ();
    case (DAE.CALL(path = Absyn.IDENT(name = "acos"),expLst = args))
      equation
        dumpStrOpenTag(MathMLApply);
        dumpStrVoidTag(MathMLArccos);
        dumpList(args,dumpExp2);
        dumpStrCloseTag(MathMLApply);
      then ();
    case (DAE.CALL(path = Absyn.IDENT(name = "asin"),expLst = args))
      equation
        dumpStrOpenTag(MathMLApply);
        dumpStrVoidTag(MathMLArcsin);
        dumpList(args,dumpExp2);
        dumpStrCloseTag(MathMLApply);
      then ();
    case (DAE.CALL(path = Absyn.IDENT(name = "atan"),expLst = args))
      equation
        dumpStrOpenTag(MathMLApply);
        dumpStrVoidTag(MathMLArctan);
        dumpList(args,dumpExp2);
        dumpStrCloseTag(MathMLApply);
      then ();
    case (DAE.CALL(path = Absyn.IDENT(name = "atan2"),expLst = args))
      equation
        dumpStrOpenTag(MathMLApply);
        dumpStrOpenTag(MathMLOperator);
        Print.printBuf("atan2");
        dumpStrCloseTag(MathMLOperator);
        dumpStrOpenTag(MathMLOperator);
        Print.printBuf("(");
        dumpStrCloseTag(MathMLOperator);
        dumpList(args,dumpExp2);
        dumpComment("atan2 is not a MathML element it could be possible to use arg in future");
        dumpStrOpenTag(MathMLOperator);
        Print.printBuf(")");
        dumpStrCloseTag(MathMLOperator);
        dumpStrCloseTag(MathMLApply);
      then ();
    case (DAE.CALL(path = Absyn.IDENT(name = "log"),expLst = args))
      equation
        dumpStrOpenTag(MathMLApply);
        dumpStrVoidTag(MathMLLn);
        dumpList(args,dumpExp2);
        dumpStrCloseTag(MathMLApply);
      then ();
    case (DAE.CALL(path = Absyn.IDENT(name = "log10"),expLst = args))
      equation
        dumpStrOpenTag(MathMLApply);
        dumpStrVoidTag(MathMLLog);
        dumpList(args,dumpExp2);
        dumpStrCloseTag(MathMLApply);
      then ();
/*
    case (DAE.CALL(path = Absyn.IDENT(name = "pre"),expLst = args))
      equation
        fs = Absyn.pathStringNoQual(fcn);
        dumpStrOpenTag(MathMLApply);
        dumpStrVoidTag("selector");          ----THIS IS FOR ALGORITHM----
        dumpList(args,dumpExp2);
        dumpStrMathMLVariable("t-1");
        dumpStrCloseTag("apMathMLApply;
      then ();
*/
    case (DAE.CALL(path = fcn,expLst = args))
      equation
        // Add the ref to path
        fs = Absyn.pathStringNoQual(fcn);
        dumpStrOpenTag(MathMLApply);
        dumpStrVoidTag(fs);
        dumpList(args,dumpExp2);
        dumpStrCloseTag(MathMLApply);
      then ();
    case (DAE.ARRAY(array = es,ty=tp))//Array are dumped as vector
      equation
        dumpStrOpenTag(MathMLApply);
        dumpStrVoidTag(MathMLTranspose);
        dumpStrOpenTag(MathMLVector);
        dumpList(es,dumpExp3);
        dumpStrCloseTag(MathMLVector);
        dumpStrCloseTag(MathMLApply);
      then ();
    case (DAE.TUPLE(PR = es))//Tuple are dumped as vector
      equation
        dumpStrOpenTag(MathMLApply);
        dumpStrVoidTag(MathMLTranspose);
        dumpStrOpenTag(MathMLVector);
        dumpList(es,dumpExp2);
        dumpStrCloseTag(MathMLVector);
        dumpStrCloseTag(MathMLApply);
      then ();
    case (DAE.MATRIX(matrix = ebs,ty=tp))
      equation
        dumpStrOpenTag(MathMLMatrix);
        dumpStrOpenTag(MathMLMatrixrow);
        dumpListSeparator(ebs, dumpRow, stringAppendList({"\n</",MathMLMatrixrow,">\n<",MathMLMatrixrow,">"}));
        dumpStrCloseTag(MathMLMatrixrow);
        dumpStrCloseTag(MathMLMatrix);
      then ();
    case (e as DAE.RANGE(_,start,NONE(),stop))
      equation
        dumpStrOpenTag(MathMLApply);
        dumpStrOpenTag(MathMLInterval);
        dumpExp2(start);
        dumpExp2(stop);
        dumpStrCloseTag(MathMLInterval);
        dumpStrCloseTag(MathMLApply);
      then ();
    case ((e as DAE.RANGE(_,start,SOME(step),stop)))
      equation
        dumpStrOpenTag(MathMLApply);
        dumpStrOpenTag(MathMLOperator);
        Print.printBuf("{");
        dumpStrCloseTag(MathMLOperator);
        dumpExp2(start);
        dumpStrOpenTag(MathMLOperator);
        Print.printBuf(":");
        dumpStrCloseTag(MathMLOperator);
        dumpExp2(step);
        dumpStrOpenTag(MathMLOperator);
        Print.printBuf(":");
        dumpStrCloseTag(MathMLOperator);
        dumpExp2(stop);
        dumpComment("Interval range specification is not supported by MathML standard");
        dumpStrOpenTag(MathMLOperator);
        Print.printBuf("}");
        dumpStrCloseTag(MathMLOperator);
        dumpStrCloseTag(MathMLApply);
      then ();
    case (DAE.CAST(ty = DAE.T_REAL(source = _),exp = DAE.ICONST(integer = ival)))
      equation
        false = Config.modelicaOutput();
        rval = intReal(ival);
        res = realString(rval);
        dumpStrMathMLNumberAttr(res,MathMLType,MathMLReal);
      then ();
    case (DAE.CAST(ty = DAE.T_REAL(source = _),exp = DAE.UNARY(operator = DAE.UMINUS(ty = _),exp = DAE.ICONST(integer = ival))))
      equation
        false = Config.modelicaOutput();
        rval = intReal(ival);
        res = realString(rval);
        dumpStrOpenTag(MathMLApply);
        dumpStrVoidTag(MathMLMinus);
        dumpStrMathMLNumberAttr(res,MathMLType,MathMLReal);
        dumpStrCloseTag(MathMLApply);
      then ();
    case (DAE.CAST(ty = DAE.T_REAL(source = _),exp = e))
      equation
        false = Config.modelicaOutput();
        dumpStrOpenTag(MathMLApply);
        dumpStrVoidTag(MathMLReal);
        dumpExp2(e);
        dumpStrCloseTag(MathMLApply);
      then ();
    case (DAE.CAST(ty = DAE.T_REAL(source = _),exp = e))
      equation
        true = Config.modelicaOutput();
        dumpExp2(e);
      then ();
    case (DAE.CAST(ty = tp,exp = e))
      equation
        str = Types.unparseType(tp);
        dumpStrOpenTag(MathMLApply);
        dumpStrOpenTag(MathMLOperator);
        Print.printBuf("(");
        dumpStrCloseTag(MathMLOperator);
        dumpStrOpenTag(MathMLOperator);
        Print.printBuf("CAST as ");Print.printBuf(str);
        dumpStrCloseTag(MathMLOperator);
        dumpExp2(e);
        dumpComment("CAST operator is not supported by MathML standard.");
        dumpStrOpenTag(MathMLOperator);
        Print.printBuf(")");
        dumpStrCloseTag(MathMLOperator);
        dumpStrCloseTag(MathMLApply);
      then ();
    case (e as DAE.ASUB(exp = e1,sub = {e2}))
      equation
        dumpStrOpenTag(MathMLApply);
        dumpStrVoidTag(MathMLSelector);
        dumpExp2(e1);
        dumpExp2(e2);
        dumpStrCloseTag(MathMLApply);
      then ();
    case (DAE.ENUM_LITERAL(name = fcn))
      equation
        dumpStrMathMLVariable(Absyn.pathStringNoQual(fcn));
      then ();
    case (DAE.SIZE(exp = cr,sz = SOME(dim)))
      equation
        // NOT PART OF THE MODELICA LANGUAGE
      then ();
    case (DAE.SIZE(exp = cr,sz = NONE()))
      equation
        // NOT PART OF THE MODELICA LANGUAGE
      then ();
    case (DAE.REDUCTION(expr = _))
      equation
        // NOT PART OF THE MODELICA LANGUAGE
      then  ();
      // MetaModelica list
    case (DAE.LIST(valList=es))
      equation
        // NOT PART OF THE MODELICA LANGUAGE
      then ();
        // MetaModelica list cons
    case (DAE.CONS(car=e1,cdr=e2))
      equation
        // NOT PART OF THE MODELICA LANGUAGE
      then ();
    case (_)
      equation
        dumpComment("UNKNOWN EXPRESSION");
      then ();
  end matchcontinue;
end dumpExp2;

public function dumpExp3
"This function is an auxiliary function for dumpExp2 function.
"
  input DAE.Exp e;
  //output String s;
algorithm
  dumpStrOpenTag(MathML);
  dumpStrOpenTagAttr(MATH, MathMLXmlns, MathMLWeb);
  dumpExp2(e);
  dumpStrCloseTag(MATH);
  dumpStrCloseTag(MathML);
end dumpExp3;

public function dumpLibs
  input list<String> libs;
algorithm
  _:=
  matchcontinue (libs)
    local
      String s;
      list<String> remaining;
  case ({}) then ();
  case (s :: remaining)
    equation
      Print.printBuf(s);
    then();
  end matchcontinue;
end dumpLibs;

public function dumpKind "
This function returns a string containing
the kind of a variable, that could be:
 - Variable
 - State
 - Dummy_der
 - Dummy_state
 - Discrete
 - Parameter
 - Constant
 - ExternalObject:PathRef
"
  input BackendDAE.VarKind inVarKind;
  output String outString;
algorithm
  outString :=
  match (inVarKind)
    local Absyn.Path path; String error_msg;
    case BackendDAE.VARIABLE()     then (VARIABILITY_CONTINUOUS);
    case BackendDAE.STATE(index=_)        then (VARIABILITY_CONTINUOUS_STATE);
    case BackendDAE.DUMMY_DER()    then (VARIABILITY_CONTINUOUS_DUMMYDER);
    case BackendDAE.DUMMY_STATE()  then (VARIABILITY_CONTINUOUS_DUMMYSTATE);
    case BackendDAE.DISCRETE()     then (VARIABILITY_DISCRETE);
    case BackendDAE.PARAM()        then (VARIABILITY_PARAMETER);
    case BackendDAE.CONST()        then (VARIABILITY_CONSTANT);
    case BackendDAE.EXTOBJ(path)
      then (stringAppend(VARIABILITY_EXTERNALOBJECT,stringAppend(":",Absyn.pathStringNoQual(path))));
    else
      equation
        error_msg = "in XMLCreateDynawo.dumpKind - Unknown kind";
        Error.addMessage(Error.INTERNAL_ERROR, {error_msg});
      then
        fail();
  end match;
end dumpKind;


public function dumpList
"Print a list of values given a print function."
  input list<Type_a> inTypeALst;
  input FuncTypeType_aTo inFuncTypeTypeATo;
  replaceable type Type_a subtypeof Any;
  partial function FuncTypeType_aTo
    input Type_a inTypeA;
  end FuncTypeType_aTo;
algorithm
  _:=
  matchcontinue (inTypeALst,inFuncTypeTypeATo)
    local
      Type_a h;
      FuncTypeType_aTo r;
      list<Type_a> t;
    case ({},_)  then ();
    case ({h},r) equation  r(h);  then  ();
    case ((h :: t),r)
      equation
        r(h);
        dumpList(t, r);
      then ();
  end matchcontinue;
end dumpList;


public function dumpListSeparator
"Print a list of values given a print
  function and a separator string."
  input list<Type_a> inTypeALst;
  input FuncTypeType_aTo inFuncTypeTypeATo;
  input String inString;
  replaceable type Type_a subtypeof Any;
  partial function FuncTypeType_aTo
    input Type_a inTypeA;
  end FuncTypeType_aTo;
algorithm
  _:=
  matchcontinue (inTypeALst,inFuncTypeTypeATo,inString)
    local
      Type_a h;
      FuncTypeType_aTo r;
      list<Type_a> t;
      DAE.Ident sep;
    case ({},_,_)  then ();
    case ({h},r,_) equation  r(h);  then  ();
    case ((h :: t),r,sep)
      equation
        r(h);
        Print.printBuf(sep);
        dumpListSeparator(t, r, sep);
      then ();
  end matchcontinue;
end dumpListSeparator;


public function dumpLstExp "
This function dumps an array of Equation using an XML format.
It takes as input the list and a String
for the content.
If the list is empty then is doesn't print anything, otherwise
the output is like:
<ContentList Dimesion=...>
  <Content>
    ...
  </Content>
  ...
</ContentList>
 "
  input list<DAE.Exp> inLstExp;
  input String inContent;
  input Boolean addMathMLCode;
algorithm
  _:=
  matchcontinue (inLstExp,inContent,addMathMLCode)
    local
      Integer len;
      String Lst;
    case ({},_,_) then ();
    case (_,_,_)
      equation
        len = listLength(inLstExp);
        len >= 1 = false;
      then();
    else
      equation
        len = listLength(inLstExp);
        len >= 1 = true;
        Lst = stringAppend(inContent,LIST_);
        dumpStrOpenTagAttr(Lst, DIMENSION, intString(len));
        dumpLstExp2(inLstExp,inContent,addMathMLCode);
        dumpStrCloseTag(Lst);
      then ();
  end matchcontinue;
end dumpLstExp;


protected function dumpLstExp2 "
This is the help function of the dumpLstExp function.
It takes the list of DAE.Exp and print out the
list in a XML format.
The output, if the list is not empty is something like this:
<ARRAY_EQUATION String=ExpressionDump.printExpStr(firstEquation)>
  <MathML>
    <MATH>
      ...
    </MATH>
  </MathML>
</ARRAY_EQUATION>
...
<ARRAY_EQUATION String=ExpressionDump.printExpStr(lastEquation)>
  <MathML>
    <MATH>
      ...
    </MATH>
  </MathML>
</ARRAY_EQUATION>
"
  input list<DAE.Exp> inLstExp;
  input String Content;
  input Boolean addMathMLCode;
algorithm
  _:=
  match (inLstExp,Content,addMathMLCode)
    local
      String s;
      DAE.Exp e;
      list<DAE.Exp> es;
    case ({},_,_) then ();
    case ((e :: es),_,_)
      equation
        s = printExpStr(e);
        dumpStrOpenTagAttr(Content, EXP_STRING, s);
        dumpExp(e,addMathMLCode);
        dumpStrCloseTag(Content);
        dumpLstExp2(es,Content,addMathMLCode);
      then ();
  end match;
end dumpLstExp2;

protected function printExpStr
  input DAE.Exp e;
  output String s;
algorithm
  s := Util.xmlEscape(ExpressionDump.printExpStr(e));
end printExpStr;

public function dumpLstInt "
function dumpLsTStr dumps a list
of Integer as a list of XML Element.
The method takes the String list and
the element name as inputs.
The output is:

<ElementName>FirstIntegerOfList</ElementName>
..
<ElementName>LastIntegerOfList</ElementName>

"
  input list<Integer> inLstStr;
  input String inElementName;
algorithm
  _:=
  matchcontinue(inLstStr,inElementName)
      local
        Integer h;
        list<Integer> t;
    case ({},_) then ();
    case ({h},"") then ();
    case ({h},_)
      equation
        dumpStrTagContent(inElementName,intString(h));
    then  ();
    case ((h :: t),_)
      equation
        dumpStrTagContent(inElementName,intString(h));
        dumpLstInt(t,inElementName);
    then();
  end matchcontinue;
end dumpLstInt;


public function dumpLstIntAttr "
This function, if the list is not empty, prints
the XML delimiters tag of the list.
"
  input list<Integer> lst;
  input String inContent;
  input String inElementContent;
algorithm
  _:= matchcontinue (lst,inContent,inElementContent)
  local
    list<Integer> l;
    String inLst,inEl;
    case ({},_,_) then ();
    case (l,inLst,inEl)
      equation
        dumpStrOpenTag(inLst);
        dumpLstInt(l,inEl);
        dumpStrCloseTag(inLst);
      then();
  end matchcontinue;
end dumpLstIntAttr;

public function dumpLstStr "
Function dumpLsTStr dumps a list
of String as a list of XML Element.
The method takes the String list as
input. The output is:
<ELEMENT>FirstStringOfList</ELEMENT>
..
<ELEMENT>LastStringOfList</ELEMENT>
"
  input list<String> inLstStr;
algorithm
  _:=
  matchcontinue(inLstStr)
      local
        String h;
        list<String> t;
    case {} then ();
    case {h}
      equation
        dumpStrTagContent(ELEMENT,h);
    then  ();
    case (h :: t)
      equation
        dumpStrTagContent(ELEMENT,h);
        dumpLstStr(t);
    then();
  end matchcontinue;
end dumpLstStr;

public function dumpOptExp "
This function print to a new line the content of
a Optional<DAE.Exp> in a XML element like:
<Content =ExpressionDump.printExpStr(e)/>. It also print
the content of the expression as MathML like:
<MathML><MATH xmlns=...>DAE.Exp</MATH></MathML>.
See dumpExp function for more details.
"
  input Option<DAE.Exp> inExpExpOption;
  input String Content;
  input Boolean addMathMLCode;
algorithm
  _:=
  match (inExpExpOption,Content,addMathMLCode)
    local
      DAE.Exp e;
    case (NONE(),_,_) then ();
    case (SOME(e),_,_)
      equation
        dumpStrOpenTagAttr(Content,EXP_STRING,printExpStr(e));
        dumpExp(e,addMathMLCode);
        dumpStrCloseTag(Content);
      then ();
  end match;
end dumpOptExp;

public function dumpOptInteger "
This function print to a new line the content of
a Optional<Integer> in a XML element like:
<Content index = intString(e)/>.
"
  input Option<Integer> inOption;
  input String Content;
  input Boolean addMathMLCode;
algorithm
  _:=
  match (inOption,Content,addMathMLCode)
    local
      Integer i;

    case (NONE(),_,_) then ();

    case (SOME(i),_,_)
      equation
        dumpStrOpenTagAttr(Content,INDEX,intString(i));
        dumpStrCloseTag(Content);
      then ();

  end match;
end dumpOptInteger;

public function dumpOptionDAEStateSelect "
This function is used to print in a new line
an element corresponding to the StateSelection
choice of a variable. Depending from the String
input, that defines the element's name, the
element is something like:
<Content=StateSelection/>,
"
  input Option<DAE.StateSelect> ss;
  input String Content;
algorithm
  _ :=
  match (ss,Content)
    case (NONE(),_)
      equation
        Print.printBuf("");
      then ();
    case (SOME(DAE.NEVER()),_)
      equation dumpStrTagContent(Content, STATE_SELECT_NEVER);   then ();
    case (SOME(DAE.AVOID()),_)
      equation dumpStrTagContent(Content, STATE_SELECT_AVOID);   then ();
    case (SOME(DAE.DEFAULT()),_)
      equation dumpStrTagContent(Content, STATE_SELECT_DEFAULT); then ();
    case (SOME(DAE.PREFER()),_)
      equation dumpStrTagContent(Content, STATE_SELECT_PREFER);  then ();
    case (SOME(DAE.ALWAYS()),_)
      equation dumpStrTagContent(Content, STATE_SELECT_ALWAYS);  then ();
  end match;
end dumpOptionDAEStateSelect;

public function dumpOptValue "
 This function print an Optional Values.Value variable
as one attribute of a within a specific XML element.
It takes the optional Values.Value and element name
as input an prints on a new line a string to the
standard output like:
<Content = \"ExpressionDump.printExpStr(ValuesUtil.valueExp(Optional<Values.Value>)/>
"
  input Option<Values.Value> inValueValueOption;
  input String Content;
  input Boolean addMathMLCode;
algorithm
  _ :=
  match (inValueValueOption,Content,addMathMLCode)
    local
      Values.Value v;
      Boolean addMMLCode;
    case (NONE(),_,_)  then ();
    case (SOME(v),_,addMMLCode)
      equation
        dumpStrOpenTagAttr(Content,EXP_STRING,printExpStr(ValuesUtil.valueExp(v)));
        dumpExp(ValuesUtil.valueExp(v),addMMLCode);
        dumpStrCloseTag(Content);
      then ();
  end match;
end dumpOptValue;

public function dumpRow
"Prints a list of expressions to a string."
  input list<DAE.Exp> es_1;
  annotation(__OpenModelica_EarlyInline=true);
algorithm
  dumpList(es_1, dumpExp2);
end dumpRow;

public function dumpStrMathMLNumber "
This function prints a new MathML element
containing a number, like:
<cn> inNumber </cn>
"
  input String inNumber;
algorithm
  dumpStrOpenTag(MathMLNumber);
  Print.printBuf(" ");Print.printBuf(inNumber);Print.printBuf(" ");
  dumpStrCloseTag(MathMLNumber);
end dumpStrMathMLNumber;

public function dumpStrMathMLNumberAttr "
This function prints a new MathML element
containing a number and one of its attributes,
like:
<cn inAttribute=\"inAttributeValue\"> inNumber
</cn>
"
  input String inNumber;
  input String inAttribute;
  input String inAttributeContent;
algorithm
  dumpStrOpenTagAttr(MathMLNumber, inAttribute, inAttributeContent);
  Print.printBuf(" ");Print.printBuf(inNumber);Print.printBuf(" ");
  dumpStrCloseTag(MathMLNumber);
end dumpStrMathMLNumberAttr;

public function dumpStrMathMLVariable"
This function prints a new MathML element
containing a variable (identifier), like:
<ci> inVariable </ci>"
  input String inVariable;
algorithm
  dumpStrOpenTag(MathMLVariable);
  Print.printBuf(" ");Print.printBuf(inVariable);Print.printBuf(" ");
  dumpStrCloseTag(MathMLVariable);
end dumpStrMathMLVariable;

public function dumpStrOpenTagAttr "
  Function necessary to print the begin of a new
  XML element containing an attribute. The XML
  element's name, the name and the content of the
  element's attribute are passed as String inputs.
  The result is to print on a new line
  a string like:
  <Content Attribute=AttributeContent>
  "
  input String inContent;
  input String Attribute;
  input String AttributeContent;
algorithm
  _:=
  matchcontinue (inContent,Attribute,AttributeContent)
      local String inString,inAttribute,inAttributeContent;
  case ("",_,_)  equation  Print.printBuf("");  then();
  case (_,"",_)  equation  Print.printBuf("");  then();
  case (_,_,"")  equation  Print.printBuf("");  then();
  case (inString,"",_)  equation dumpStrOpenTag(inString);  then ();
  case (inString,_,"")  equation dumpStrOpenTag(inString);  then ();
  case (inString,inAttribute,inAttributeContent)
    equation
      Print.printBuf("\n<");Print.printBuf(inString);Print.printBuf(" ");Print.printBuf(Attribute);Print.printBuf("=\"");Print.printBuf(inAttributeContent);Print.printBuf("\">");
    then();
  end matchcontinue;
end dumpStrOpenTagAttr;

public function dumpStrTagAttrNoChild "
  Function necessary to print a new
  XML element containing an attribute. The XML
  element's name, the name and the content of the
  element's attribute are passed as String inputs.
  The result is to print on a new line
  a string like:
  <Content Attribute=AttributeContent>
  "
  input String inContent;
  input String Attribute;
  input String AttributeContent;
algorithm
  _:=
  matchcontinue (inContent,Attribute,AttributeContent)
      local String inString,inAttribute,inAttributeContent;
  case ("",_,_)  equation  Print.printBuf("");  then();
  case (_,"",_)  equation  Print.printBuf("");  then();
  case (_,_,"")  equation  Print.printBuf("");  then();
  case (inString,"",_)  equation dumpStrOpenTag(inString);  then ();
  case (inString,_,"")  equation dumpStrOpenTag(inString);  then ();
  case (inString,inAttribute,inAttributeContent)
    equation
      Print.printBuf("\n<");Print.printBuf(inString);Print.printBuf(" ");Print.printBuf(Attribute);Print.printBuf("=\"");Print.printBuf(inAttributeContent);Print.printBuf("\" />");
    then();
  end matchcontinue;
end dumpStrTagAttrNoChild;

public function dumpSubscript "
This function print an DAE.Subscript eventually
using the ExpressionDump.printExpStr function.
"
  input DAE.Subscript inSubscript;
algorithm
  _:=
  matchcontinue (inSubscript)
    local DAE.Exp e1;
    case (DAE.WHOLEDIM())
      equation
        Print.printBuf(":");
      then
        ();
    case (DAE.INDEX(exp = e1))
      equation
        Print.printBuf(printExpStr(e1));
      then
        ();
    case (DAE.SLICE(exp = e1))
      equation
        Print.printBuf(printExpStr(e1));
      then
        ();
  end matchcontinue;
end dumpSubscript;

public function dumpTypeStr "
This function output the Type of a variable, it could be:
 - Integer
 - Real
 - Boolean
 - String
 - Enum
 "
  input BackendDAE.Type inType;
  output String outString;
algorithm
  outString:=
  match (inType)
    local
      DAE.Ident s1,s2,str;
      list<DAE.Ident> l;
    case DAE.T_INTEGER(source = _) then VARTYPE_INTEGER;
    case DAE.T_REAL(source = _)    then VARTYPE_REAL;
    case DAE.T_BOOL(source = _)    then VARTYPE_BOOLEAN;
    case DAE.T_STRING(source = _)  then VARTYPE_STRING;
    case DAE.T_ENUMERATION(names = l)
      equation
        s1 = stringDelimitList(l, ", ");
        s2 = stringAppend(VARTYPE_ENUMERATION,stringAppend("(", s1));
        str = stringAppend(s2, ")");
      then
        str;
    case DAE.T_COMPLEX(complexClassType = ClassInf.EXTERNAL_OBJ(_))
      then VARTYPE_EXTERNALOBJECT;
  end match;
end dumpTypeStr;

public function lbinopSymbol "
function: lbinopSymbol
  Return string representation of logical binary operator.
"
  input DAE.Operator inOperator;
  output String outString;
algorithm
  outString:=
  match (inOperator)
    local String error_msg;
    case (DAE.AND(ty = _)) then MathMLAnd;
    case (DAE.OR(ty = _)) then MathMLOr;
    else
      equation
        error_msg = "in XMLCreateDynawo.lbinopSymbol - Unknown operator";
  error_msg = error_msg + ExpressionDump.debugBinopSymbol(inOperator);
        Error.addMessage(Error.INTERNAL_ERROR, {error_msg});
      then
        fail();
  end match;
end lbinopSymbol;

public function lunaryopSymbol "
function: lunaryopSymbol
  Return string representation of logical unary operator
  corresponding to the MathML encode.
"
  input DAE.Operator inOperator;
  output String outString;
algorithm
  outString:=
  match (inOperator)
    local String error_msg;
    case (DAE.NOT(ty = _)) then MathMLNot;
    else
      equation
        error_msg = "in XMLCreateDynawo.lunaryopSymbol - Unknown operator";
        error_msg = error_msg + ExpressionDump.debugBinopSymbol(inOperator);
        Error.addMessage(Error.INTERNAL_ERROR, {error_msg});
      then
        fail();
  end match;
end lunaryopSymbol;

public function relopSymbol "
function: relopSymbol
  Return string representation of function operator.
"
  input DAE.Operator inOperator;
  output String outString;
algorithm
  outString:=
  match (inOperator)
    local String error_msg;
    case (DAE.LESS(ty = _))      then MathMLLessThan;
    case (DAE.LESSEQ(ty = _))    then MathMLLessEqualThan;
    case (DAE.GREATER(ty = _))   then MathMLGreaterThan;
    case (DAE.GREATEREQ(ty = _)) then MathMLGreaterEqualThan;
    case (DAE.EQUAL(ty = _))     then MathMLEquivalent;
    case (DAE.NEQUAL(ty = _))    then MathMLNotEqual;
    else
      equation
        error_msg = "in XMLCreateDynawo.relopSymbol - Unknown operator";
        error_msg = error_msg + ExpressionDump.debugBinopSymbol(inOperator);
        Error.addMessage(Error.INTERNAL_ERROR, {error_msg});
      then
        fail();
  end match;
end relopSymbol;

public function unaryopSymbol "
function: unaryopSymbol
  Return string representation of unary operators
  corresponding to the MathML encode.
"
  input DAE.Operator inOperator;
  output String outString;
algorithm
  outString:=
  match (inOperator)
    case (DAE.UMINUS(ty = _))     then MathMLMinus;
    case (DAE.UMINUS_ARR(ty = _)) then MathMLMinus;
  end match;
end unaryopSymbol;

//-------------------------------------
public function unparseCommentOptionNoAnnotation "
function: unparseCommentOptionNoAnnotation
  Prettyprints a Comment without printing the annotation part.
"
  input Option<SCode.Comment> inAbsynCommentOption;
  output String outString;
algorithm
  outString:= matchcontinue (inAbsynCommentOption)
    local String str,cmt;
    case (SOME(SCode.COMMENT(_,SOME(cmt))))
      equation
        //str = stringAppendList({" \"",cmt,"\""});
        str = cmt;
      then
        str;
    case (_) then "";
  end matchcontinue;
end unparseCommentOptionNoAnnotation;

//-------------------------------------
public function dumpStrVoidTag
"
This function takes as input the name
of the void element to print and then
print on a new line an XML code like:
<ElementName/>
"
  input String inElementName;
algorithm
  _:=matchcontinue(inElementName)
  local String ElementName,str2write;
    case("") then();
    case(ElementName)
      equation
        str2write = stringAppendList({"\n<",ElementName,"/>"});
        Print.printBuf(str2write);
      then();
  end matchcontinue;
end dumpStrVoidTag;

//-------------------------------------
public function dumpStrTagContent "
  Function necessary to print an XML element
  with a String content. The XML element's name
  and the content are passed as String inputs.
  The result is to print on a new line
  a string like:
  <inElementName>inContent</inElementName>
  "
  input String inElementName;
  input String inContent;
algorithm
  _:=
  matchcontinue (inElementName,inContent)
      local String inTagString,inTagContent;
  case ("",_)  then ();
  case (inTagString,"")  then ();
  case (inTagString,inTagContent)
    equation
      dumpStrOpenTag(inTagString);
      Print.printBuf(stringAppend("\n",inTagContent));
      dumpStrCloseTag(inTagString);
    then ();
  end matchcontinue;
end dumpStrTagContent;

//------------------------------------
public function dumpConnectorBlock
 "Print the line dedicated to connector as <connector name=... type=... />"
  input String inTag;
  input String inType;
  input String inName;
algorithm
  _:= matchcontinue (inTag,inType,inName)
      local String str2write,inName1;
    case (_,_,"")
     equation
        dumpStrBlock(inTag,inType);
     then ();
    case (_,_,_)
     equation
        inName1 = Util.stringReplaceChar(inName,".","");
        str2write = stringAppendList({"\n<",inTag," name=\"",inName1,"\" type=\"",inType,"\" ","/>"});
        Print.printBuf(str2write);
     then ();
  end matchcontinue;
end dumpConnectorBlock;

//-------------------------------------
public function dumpStrBlock
 "Print a line such as : <intag> inString </intag>"
  input String inTag;
  input String inString;
algorithm
  _:= matchcontinue (inTag,inString)
       local
           String inTagString;
           String inTagContent;
           String str2write;
    case ("",_) then ();
    case (_,"") then ();
    case (inTagString,inTagContent)
    equation
        str2write = stringAppendList({"\n<",inTag,">",inString,"</",inTag,">"});
        Print.printBuf(str2write);
    then ();
  end matchcontinue;
end dumpStrBlock;

protected function transformModelicaIdentifierToXMLElementTag
  input String modelicaIdentifier;
  output String xmlElementTag;
algorithm
  // XML element names cannot handle $ in identifiers
  // TODO! FIXME!, there are many other characters valid in Modelica
  // function names and identifiers that aren't valid in XML element tags.
  xmlElementTag := System.stringReplace(modelicaIdentifier, "$", "_dollar_");

  // TODO! FIXME!, we have issues with accented chars in comments
  // that end up in the Model_init.xml file and makes it not well
  // formed but the line below does not work if the xmlElementTag is
  // already UTF-8. We should somehow detect the encoding.
  // xmlElementTag := System.iconv(xmlElementTag, "", "UTF-8");

end transformModelicaIdentifierToXMLElementTag;

//-------------------------------------
public function dumpStrOpenTag "
   Function necessary to print the begin of a new XML element <Content>
   "
  input String inContent;
algorithm
  _:=
  matchcontinue (inContent)
      local String inString, str2write;
  case ("")
    equation
      Print.printBuf("");
    then ();
  case (inString)
    equation
      str2write = stringAppendList({"\n<",inString,">"});
      Print.printBuf(str2write);
    then ();
  end matchcontinue;
end dumpStrOpenTag;

//-------------------------------------
public function dumpStrCloseTag "
  Function necessary to print the end of an
  XML element. </Content> "
  input String inContent;
algorithm
  _:=
  matchcontinue (inContent)
      local String inString,str2write;
  case ("")
    equation
    then ();
  case (inString)
    equation
         str2write = stringAppendList({"\n</",inString,">"});
         Print.printBuf(str2write);
    then ();
  end matchcontinue;
end dumpStrCloseTag;

//-------------------------------------
public function dumpConnectorStr "
This function returns a string with
the content of the connector type of a variable.
It could be:
 - Potential
 - Flow
 - Stream
 - Non_Connector
"
  input DAE.ConnectorType inVarFlow;
  output String outString;
algorithm
  outString:=
  match (inVarFlow)
    case DAE.POTENTIAL()     then VAR_CONNECTOR_POTENTIAL;
    case DAE.FLOW()          then VAR_CONNECTOR_FLOW;
    case DAE.STREAM()        then VAR_CONNECTOR_STREAM;
    case DAE.NON_CONNECTOR() then VAR_CONNECTOR_NOTCONNECTOR;
  end match;
end dumpConnectorStr;

//-------------------------------------
protected function getConnectorName
" Get the tackled connector name."
      input  DAE.ElementSource source;
      output String connectorName;
algorithm
 connectorName := match (source)
    local
      String name;
      list<Absyn.Path> paths;
      list<String> paths_lst;
    case (_)
     equation
        paths     = DAEUtil.getElementSourceTypes(source);
        paths_lst = list(Absyn.pathString(p) for p in paths);
        name = if listLength(paths_lst) >= 3 then List.second(paths_lst) else "";
     then
        name;
  end match;
end getConnectorName;

//-------------------------------------
protected function decoupCref
 " Get the first and the last string of a variable Component Reference"
  input DAE.ComponentRef cr;
  output String crStr;
  output String varCrefStr1;
  output String varCrefStr2;
algorithm
  (crStr,varCrefStr1,varCrefStr2) :=
  matchcontinue (cr)
    local
       String crStr0;
       String varCrStr1;
       String varCrStr2;

       Integer lensCref;
       DAE.ComponentRef varCref1,varCref2,varCr2;
       list<DAE.ComponentRef> allCrefParts;
       list<DAE.ComponentRef> mCref;
       list<DAE.ComponentRef> sCref;
  case(_)
    equation
      varCref1 = ComponentReference.crefFirstCref(cr);
      varCref2 = ComponentReference.crefLastCref(cr);

      allCrefParts = ComponentReference.explode(cr);
      (mCref, sCref) = List.split(allCrefParts, ComponentReference.identifierCount(varCref1));

      lensCref = listLength(sCref);

      crStr0    = ComponentReference.printComponentRefStr(cr);
      varCrStr1 = ComponentReference.printComponentRefStr(varCref1);

      varCr2    = if lensCref>1 then ComponentReference.implode(sCref) else varCref2;
      varCrStr2 = ComponentReference.printComponentRefStr(varCr2);
    then
      (crStr0,varCrStr1,varCrStr2);
  end matchcontinue;
end decoupCref;

//-------------------------------------
public function writeBeginStructBlock
   input String varCrefStr1;
algorithm
  _:= matchcontinue (varCrefStr1)
     local
       String str2write;
    case (_)
     equation
      str2write = stringAppendList({"\n<",RTE_STRUCT,">"});
      Print.printBuf(str2write);

      dumpStrBlock(VAR_NAME,varCrefStr1);

      str2write = stringAppendList({"\n<",RTE_SUBNODES,">"});
      Print.printBuf(str2write);
     then ();
  end matchcontinue;
end writeBeginStructBlock;

//-------------------------------------
public function writeEndStructBlock
algorithm
      dumpStrCloseTag(RTE_DESIGNATION_VARIABLE);
      dumpStrCloseTag(RTE_SUBNODES);
      dumpStrCloseTag(RTE_STRUCT);
end writeEndStructBlock;

//-------------------------------------
public function dumpVariableRTE "
This function print to the standard output the content of a variable.
 In particular it takes:
* cr   : the var name
* kind : variable, state, dummy_der, dummy_state,..
* varno: the variable number
* dir  : input, output or bi-directional
* var_type: builtin type or enumeration
* old_name: the original name of the variable
* varFixed: fixed attribute for variables (default fixed
    value is used if not found. Default is true for parameters
   (and constants) and false for variables)
* connectorPrefix : Tells if it is a potential, flow, stream variable or not
* connectorName   : Name of the connector
* comment         : A comment associated to the variable.
* isConnector     : True if the varibale belongs to a connector
"
  input String varno;
  input DAE.ComponentRef cr;
  input String kind,dir,var_type,varFixed,connectorPrefix,connectorName,comment;
  input Boolean isConnector;
algorithm
  _:=
  matchcontinue (varno,cr,kind,dir,var_type,varFixed,connectorPrefix,connectorName,comment,isConnector)
      local
       Boolean isConnect;
       String str2write;
       String crStr,varCrefStr1,varCrefStr2;

    case (_,_,_,_,_,_,_,_,"",true)
    equation
      (crStr,varCrefStr1,varCrefStr2) = decoupCref(cr);

      writeBeginStructBlock(varCrefStr1);

      str2write = stringAppendList({"\n<",RTE_DESIGNATION_VARIABLE,">"});
      Print.printBuf(str2write);
      dumpStrBlock(VAR_NAME,varCrefStr2);

      dumpStrBlock(VAR_VARIABILITY,kind);
      dumpStrBlock(VAR_COUNT,varno);
      dumpStrBlock(VAR_ID,crStr);
      dumpStrBlock(VAR_TYPE,var_type);
      dumpStrBlock(VAR_DIRECTION,dir);

      dumpStrBlock(VAR_FIXED,varFixed);
      dumpConnectorBlock(VAR_CONNECTOR,connectorPrefix,connectorName);

      writeEndStructBlock();
    then ();
    case (_,_,_,_,_,_,_,_,_,true)
    equation
      (crStr,varCrefStr1,varCrefStr2) = decoupCref(cr);

      writeBeginStructBlock(varCrefStr1);

      str2write = stringAppendList({"\n<",RTE_DESIGNATION_VARIABLE,">"});
      Print.printBuf(str2write);
      dumpStrBlock(VAR_NAME,varCrefStr2);

      dumpStrBlock(VAR_VARIABILITY,kind);
      dumpStrBlock(VAR_COUNT,varno);
      dumpStrBlock(VAR_ID,crStr);
      dumpStrBlock(VAR_TYPE,var_type);
      dumpStrBlock(VAR_DIRECTION,dir);

      dumpStrBlock(VAR_FIXED,varFixed);
      dumpConnectorBlock(VAR_CONNECTOR,connectorPrefix,connectorName);

      dumpStrBlock(VAR_COMMENT,Util.xmlEscape(comment));

      writeEndStructBlock();
    then ();
    case (_,_,_,_,_,_,_,_,"",false)
    equation
      str2write = stringAppendList({"\n<",RTE_DESIGNATION_VARIABLE,">"});
      Print.printBuf(str2write);

      dumpStrBlock(VAR_NAME,ComponentReference.printComponentRefStr(cr));

      dumpStrBlock(VAR_VARIABILITY,kind);
      dumpStrBlock(VAR_COUNT,varno);
      dumpStrBlock(VAR_TYPE,var_type);
      dumpStrBlock(VAR_DIRECTION,dir);

      dumpStrBlock(VAR_FIXED,varFixed);
      dumpConnectorBlock(VAR_CONNECTOR,connectorPrefix,connectorName);
      dumpStrCloseTag(RTE_DESIGNATION_VARIABLE);
    then();
    case (_,_,_,_,_,_,_,_,_,false)
    equation
      str2write = stringAppendList({"\n<",RTE_DESIGNATION_VARIABLE,">"});
      Print.printBuf(str2write);

      dumpStrBlock(VAR_NAME,ComponentReference.printComponentRefStr(cr));
      dumpStrBlock(VAR_VARIABILITY,kind);
      dumpStrBlock(VAR_COUNT,varno);
      dumpStrBlock(VAR_TYPE,var_type);
      dumpStrBlock(VAR_DIRECTION,dir);

      dumpStrBlock(VAR_FIXED,varFixed);
      dumpConnectorBlock(VAR_CONNECTOR,connectorPrefix,connectorName);

      dumpStrBlock(VAR_COMMENT,Util.xmlEscape(comment));
      dumpStrCloseTag(RTE_DESIGNATION_VARIABLE);
    then ();
  end matchcontinue;
end dumpVariableRTE;

//-------------------------------------
protected function dumpVars2RTE "
This function is one of the two help function to the dumpVarRTE method.
The two help functions differ from the number of the output.
This function is used for printing the content
of a variable with no AdditionalInfo.
"
  input list<BackendDAE.Var> inVarLst;
  input Integer inInteger;
algorithm
  _ := match (inVarLst,inInteger)
    local
      Integer varno;

      Integer var_1;
      BackendDAE.Var v;
      list<BackendDAE.Var> varsLst;

      String connectorName;
      DAE.ComponentRef   cr;
      BackendDAE.VarKind kind;
      DAE.VarDirection   dir;
      BackendDAE.Type    var_type;
      DAE.ElementSource  source    "The element origin";
      Option<SCode.Comment> comment;
      DAE.ConnectorType    ct;

    case ({},_) then ();
    case (((v as BackendDAE.VAR(varName      = cr,
                                varKind      = kind,
                                varDirection = dir,
                                varType      = var_type,
                                source       = source,
                                comment      = comment,
                                connectorType = ct)) :: varsLst),varno)
      equation
        connectorName = getConnectorName(source);

        //... Dump one variable
        dumpVariableRTE(intString(varno),cr,
      dumpKind(kind),dumpDirectionStr(dir),dumpTypeStr(var_type),
                        boolString(BackendVariable.varFixed(v)),
           dumpConnectorStr(ct),connectorName,
                        unparseCommentOptionNoAnnotation(comment),
                        BackendVariable.isVarConnector(v));

        var_1 = varno + 1;
        dumpVars2RTE(varsLst,var_1);
      then ();
  end match;
end dumpVars2RTE;

//-------------------------------------
public function dumpVarsRTE "
This function prints a list of Var in a XML format.
If the list is not empty (in that case nothing is printed)
the output is:
  <elements DIMENSION= ...>
        ...
  </elements>
"
  input list<BackendDAE.Var> vars;
algorithm
  _ := matchcontinue (vars)
    local
      Integer len,iNextAD;
    case ({})
      then ();
    case (_)
      equation
        len = listLength(vars);
        len >= 1 = true;

        //... Dump all the model variables
        dumpStrOpenTagAttr(RTE_VARIABLES_LIST,DIMENSION,intString(len));

        iNextAD = 1;
        dumpVars2RTE(vars,iNextAD);

        dumpStrCloseTag(RTE_VARIABLES_LIST);
      then ();
  end matchcontinue;
end dumpVarsRTE;

//-------------------------------------
public function printStrCref "print StrCref."
  input list<String> inStrCR;
algorithm
  _ := List.fold(inStrCR, printStrCref1, 1);
end printStrCref;
//-------------------------------------
protected function printStrCref1
  input  String inStrCR;
  input  Integer inVarNo;
  output Integer outVarNo;
algorithm
  printStrCref2(inStrCR);
  outVarNo := inVarNo + 1;
end printStrCref1;
//-------------------------------------
public function printStrCref2
  input String inStrCR;
algorithm
  _ := matchcontinue (inStrCR)
      local String CR1;
  case("") then ();
  case(CR1)
   equation
      print(CR1 + "\n");
   then ();
  end matchcontinue;
end printStrCref2;

//-------------------------------------
public function printVarCref "print VarCref."
  input list<DAE.ComponentRef> inCR;
algorithm
  _ := List.fold(inCR, printVarCref1, 1);
end printVarCref;
//-------------------------------------
protected function printVarCref1
  input DAE.ComponentRef inCR;
  input  Integer inVarNo;
  output Integer outVarNo;
algorithm
  print(intString(inVarNo));
  print(": ");
  print(ComponentReference.printComponentRefStr(inCR) + "\n");
  outVarNo := inVarNo + 1;
end printVarCref1;

//-------------------------------------
protected function getCrefs
  input list<BackendDAE.Var> inVars;
  input  list<DAE.ComponentRef> inCR;
  output list<DAE.ComponentRef> outCR;
algorithm
  outCR := match(inVars,inCR)
    local
      BackendDAE.Var v1;
      list<BackendDAE.Var> tail;
      DAE.ComponentRef lCR;
    case ({},_) then inCR;
    case (v1 :: tail,_)
    equation
      lCR = BackendVariable.varCref(v1);
      then getCrefs(tail,listAppend(inCR,{lCR}));
  end match;
end getCrefs;

//-------------------------------------
protected function sortCrefs_RTE
  input  list<BackendDAE.Var> inVars;
  input  list<String> inStrCR;
  output list<String> outStrConnectorCref;
algorithm
  outStrConnectorCref := matchcontinue (inVars,inStrCR)
     local
      BackendDAE.Var v1;
      list<BackendDAE.Var> tail1;
      DAE.ComponentRef cr1;
      String selectCR;
    case ({},_) then inStrCR;
    case (v1 :: tail1,_)
      equation
       cr1 = BackendVariable.varCref(v1);
       selectCR = if BackendVariable.isVarConnector(v1) then ComponentReference.printComponentRefStr(cr1) else "";
      //then sortCrefs_RTE(tail1,listAppend(inStrCR,{selectCR}));
      then sortCrefs_RTE(tail1,selectCR :: inStrCR);
  end matchcontinue;
end sortCrefs_RTE;

//-------------------------------------
protected function getVars_RTE
  input  BackendDAE.EqSystem syst;
  input  list<BackendDAE.Var> inVars;
  output list<BackendDAE.Var> outVars;
protected
  list<BackendDAE.Var> vars;
algorithm
  //local integer n;
  vars := BackendVariable.varList(BackendVariable.daeVars(syst));
  //n  := numVariables(vars);
  outVars := listAppend(inVars,vars);
end getVars_RTE;

//-------------------------------------
public function createDAE2Dynawo "
  This function dumps all variables of BackendDAE representation to stdout as XML format.
"
  input BackendDAE.BackendDAE inBackendDAE;
  input String                modelName;
algorithm
  _ := matchcontinue (inBackendDAE,modelName)
    local
      list<BackendDAE.EqSystem> systs;
      String  cName;

      list<BackendDAE.Var>   vars;
      list<DAE.ComponentRef> vars_cref;
      list<String>           connectorCref;
      list<list<String>>     connectorCref2;
      list<Integer>          subNodeCref;

      //Known Variables: constant & parameter variables.
      BackendDAE.Variables vars_knownVars;
      array<list<BackendDAE.CrefIndex>> crefIdxLstArr_knownVars;
      BackendDAE.VariableArray varArr_knownVars;
      Integer bucketSize_knownVars;
      Integer numberOfVars_knownVars;

      //External Object: external variables.
      list<BackendDAE.Var> extvars;
      BackendDAE.Variables vars_externalObject;
      array<list<BackendDAE.CrefIndex>> crefIdxLstArr_externalObject;
      BackendDAE.VariableArray varArr_externalObject;
      Integer bucketSize_externalObject;
      Integer numberOfVars_externalObject;

      //Alias Variables: alias variables
      list<BackendDAE.Var> aliasvars;
      BackendDAE.Variables vars_aliasVars;
      array<list<BackendDAE.CrefIndex>> crefIdxLstArr_aliasVars;
      BackendDAE.VariableArray varArr_aliasVars;
      Integer bucketSize_aliasVars;
      Integer numberOfVars_aliasVars;

      //External Classes
      BackendDAE.ExternalObjectClasses extObjCls;

      BackendDAE.EquationArray reqns,ieqns;
      list<DAE.Constraint> constrs;
      list<DAE.ClassAttributes> clsAttrs;

      BackendDAE.BackendDAEType    btp;
      BackendDAE.SymbolicJacobians symjacs;
      DAE.FunctionTree             funcs;
      BackendDAE.EventInfo         eventInfo;

    case (BackendDAE.DAE(systs,
                 BackendDAE.SHARED(
                 vars_knownVars as BackendDAE.VARIABLES(crefIndices=crefIdxLstArr_knownVars,varArr=varArr_knownVars,bucketSize=bucketSize_knownVars,numberOfVars=numberOfVars_knownVars),
                 vars_externalObject as BackendDAE.VARIABLES(crefIndices=crefIdxLstArr_externalObject,varArr=varArr_externalObject,bucketSize=bucketSize_externalObject,numberOfVars=numberOfVars_externalObject),
                 vars_aliasVars as BackendDAE.VARIABLES(crefIndices=crefIdxLstArr_aliasVars,varArr=varArr_aliasVars,bucketSize=bucketSize_aliasVars,numberOfVars=numberOfVars_aliasVars),
                 ieqns,reqns,constrs,clsAttrs,_,_,funcs,eventInfo,extObjCls,btp,symjacs,_)),
     cName)
      equation
        //... Get all the variables
        vars = List.fold(systs,getVars_RTE,{});

        //... Get all the variables Component Reference
        vars_cref = getCrefs(vars,{});

        //... Verification printing

        //... Select the variables Component References
        connectorCref  = sortCrefs_RTE(vars,{});
        connectorCref  = listReverse(connectorCref);

        //... Building of the specific XML file
        Print.printBuf(HEADER);
        dumpStrOpenTag(RTE_OPEN);

        //... Information about modelName
        dumpStrBlock(RTE_MODELNAME,cName);

        dumpVarsRTE(vars);

        dumpStrCloseTag(RTE_CLOSE);
      then ();
    else
      equation
        Error.addMessage(Error.INTERNAL_ERROR, {"XMLCreateDynawo.createDAE2Dynawo failed"});
      then
        fail();
  end matchcontinue;
end createDAE2Dynawo;

//================================================================================
//   A.D :  Programmation en cours pour regroupement des struct => A debbuger
//================================================================================
//-------------------------------------
// ===> Programmation pour obtenir la liste d'entiers
        //subNodeCref = countStrCref(connectorCref,{});

//-------------------------------------
public function getCountBefore
  input  list<Integer> indexList;
  output Integer nbCrefPrevious;
algorithm
 nbCrefPrevious := matchcontinue(indexList)
  case({}) then 1;
  case(_)  then List.last(indexList);
 end matchcontinue;
end getCountBefore;

//-------------------------------------
public function countStrCref "Specific count about StrCref."
  input  list<String> inList;
  input  list<Integer> indexList;
  output list<Integer> outList;
algorithm
  outList := matchcontinue(inList,indexList)
    local
       String elem;
       list<String> tail;

       Integer nbCref,nbCrefPrevious,elemPosition1;
       list<Integer> nbCrefIndex;
       list<String> inList2;
    case({},_)
       then {};
    case(elem :: tail,_)
     equation
       nbCrefPrevious = getCountBefore(indexList);

       print("3\n");
       elemPosition1 = List.position(elem,tail);

       print("4\n");
       elemPosition1 = elemPosition1 + 1;

       inList2  = if stringEqual(elem,List.last(tail)) then {} else List.lastN(tail,elemPosition1);

       print("4.1\n");
       nbCrefIndex = count3(inList2,elem,{});

       nbCref = count2(nbCrefPrevious,nbCrefIndex);
       print("5\n");
     then
        countStrCref(tail,listAppend(indexList,{nbCref}));
  end matchcontinue;
end countStrCref;

public function count2
  input Integer nbCrefPrevious;
  input list<Integer> nbCrefIndex;
  output Integer nbCref;
algorithm
   nbCref := matchcontinue(nbCrefPrevious,nbCrefIndex)
      local
         Integer n,nout;
         Integer n1;
         Integer n2;
    case(n,{})
      then 1;
    case(n,_)
      equation
       print("4.2\n");
       n2 = if n == 1 or n == -1 then List.reduce(nbCrefIndex,intAdd) else 1;
       n1 = if n<0 and n<-1 then n+1 else n2;
       nout = if n > 1 then -n+1 else  n1;
       print("4.3\n");
      then
         nout;
    end matchcontinue;
end count2;

public function count3
   input  list<String> inList;
   input  String strCrefToCompare;
   input  list<Integer> nbCrefLst;
   output list<Integer> nbCref;
algorithm
  nbCref := matchcontinue(inList,strCrefToCompare,nbCrefLst)
     local
        Integer nbFirstCref;
        list<String> strCrefIndxLst;
        String  strCrefIndx,elem;
        list<String> tail;
    case({},_,_)
  then {};
    case(elem :: tail,_,_)
     equation
       print("4.1.1\n");
       //strCrefIndx = listGet(elem,1);
       strCrefIndxLst = Util.stringSplitAtChar(elem,".");
       strCrefIndx = listGet(strCrefIndxLst,1);
       print("4.1.2\n");
       nbFirstCref = if stringEqual(strCrefToCompare,strCrefIndx) then 1 else 0;
       print("4.1.3\n");
     then count3(tail,strCrefToCompare,listAppend(nbCrefLst,{nbFirstCref}));
 end matchcontinue;
end count3;


annotation(__OpenModelica_Interface="backend");
end XMLCreateDynawo;
