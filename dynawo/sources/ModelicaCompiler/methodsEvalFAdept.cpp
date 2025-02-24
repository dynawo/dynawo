#include <utility>
#include <math.h>
#include <string>

using namespace std;

class Delay {
  public:
    pair<double, double> getLastRegisteredPoint() const {
      pair<double, double> pair(1, 2);
      return pair;
    }

    bool isTriggered() const {
      return true;
    }
};

class DelayManager {
  public:
    const Delay& getDelayById(int id) const {
      static Delay delay = Delay();
      return delay;
    }
    double getDelay(int id, double delayValue) const {
      return 1.;
    }
};

class ModelManager {
  public:
    const DelayManager& getDelayManager() const {
      static DelayManager delayManager = DelayManager();
      return delayManager;
    }
};

ModelManager* getModelManager() {
  static ModelManager* modelManager = new ModelManager();
  return modelManager;
}

bool doubleEquals(double a, double b) {
  return false;
}

bool doubleIsZero(double a) {
  return true;
}

void incorrectDelay(double a, double b, double c) {
}

bool toNativeBool(const double& dynawoBool) {
    return dynawoBool >  0.0;
}

double pow(double base, double exponent) {
  return base;
}

double sqrt(double base) {
  return base;
}

typedef int m_integer;
typedef double adouble;
typedef m_integer modelica_integer;
typedef signed char modelica_boolean;
typedef double* real_array;
typedef double modelica_real;

template<typename T>
modelica_boolean Less(T a, T b) {
  return a < b;
}

template<typename T>
modelica_boolean Greater(T a, T b) {
  return a > b;
}

template<typename T>
modelica_boolean LessEq(T a, T b) {
  return a <= b;
}

template<typename T>
modelica_boolean GreaterEq(T a, T b) {
  return a >= b;
}

template<>
modelica_boolean Less<double>(double a, double b) {
  return a < b;
}

template<>
modelica_boolean Greater<double>(double a, double b) {
  return a > b;
}

template<>
modelica_boolean LessEq<double>(double a, double b) {
  return a < b;
}

template<>
modelica_boolean GreaterEq<double>(double a, double b) {
  return a > b;
}

double RELATIONHYSTERESIS(double res, double exp1, double exp2, double index, double op_w) {
  return res;
}

double derDelayImpl(int exprNumber, double exprValue, double time, double delayTime, double delayMax) {
  return exprValue;
}

double omc_Modelica_Blocks_Tables_Internal_getTable1DValue(double a, int b , double c) {
  return a;
}

double ModelicaStandardTables_CombiTable1D_getDerValue_adept(double _tableID, int iCol, double der_u) {
  return der_u;
}

double omc_Modelica_Blocks_Tables_Internal_getTable2DValue(double a, int b , double c, double d) {
  return a;
}


double ModelicaStandardTables_CombiTable2D_getDerValue_adept(double _tableID, double der_u1, double der_u2) {
  return der_u1;
}

double omc_Modelica_Blocks_Tables_Internal_getTimeTableValue(double a, int b, double c) {
  return a;
}

double ModelicaStandardTables_CombiTimeTable_getDerValue_adept(double tableID, int icol, double der_t, double nextTimeEvent, double preNextTimeEvent) {
  return der_t;
}

double omc_Modelica_Blocks_Tables_Internal_getTimeTableValueNoDer(double _tableID, int _icol, double _timeIn, double _nextTimeEvent, double _pre_nextTimeEvent) {
  return _timeIn;
}

void throwStreamPrintWithEquationIndexes(std::string str, double a) {
}

void array_alloc_scalar_real_array(double* dest, int n, modelica_real first, ...) {
}

modelica_real min_real_array(const double* a) {
  return 1;
}

modelica_real max_real_array(const double* a) {
  return 1;
}

typedef struct Complex_s_adept {
 double _im;
 double _re;
} Complex_adept;

typedef Complex_adept ComplexInput_adept;

Complex_adept omc_Complex_adept(double omc_re, double omc_im) {
  Complex_adept complex;
  complex._re = omc_re;
  complex._im = omc_im;
  return complex;
}
ComplexInput_adept omc_ComplexInput_adept(double omc_re, double omc_im) {
  return omc_Complex_adept(omc_re, omc_im);
}