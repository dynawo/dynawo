//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file DYNModelicaOverridenFunctions.cpp
 *
 */

#include "DYNModelicaOverridenFunctions.h"
#include "DYNMacrosMessage.h"
#include <cfloat>
#include <cstdarg>


#ifdef _ADEPT_

// Copied from ModelicaExternalC library
// Copied from ModelicaStandardTables.c
/* ----- Interface enumerations ----- */

enum Smoothness {
    LINEAR_SEGMENTS = 1,
    CONTINUOUS_DERIVATIVE,
    CONSTANT_SEGMENTS,
    FRITSCH_BUTLAND_MONOTONE_C1,
    STEFFEN_MONOTONE_C1,
    AKIMA_C1 = CONTINUOUS_DERIVATIVE
};

enum Extrapolation {
    HOLD_LAST_POINT = 1,
    LAST_TWO_POINTS,
    PERIODIC,
    NO_EXTRAPOLATION
};

enum TimeEvents {
    UNDEFINED = 0,
    ALWAYS,
    AT_DISCONT,
    NO_TIMEEVENTS
};

/* ----- Internal enumerations ----- */

enum PointInterval {
    LEFT = -1,
    IN_TABLE = 0,
    RIGHT = 1
};

enum TableSource {
    TABLESOURCE_MODEL = 1,
    TABLESOURCE_FILE,
    TABLESOURCE_FUNCTION,
    TABLESOURCE_FUNCTION_TRANSPOSE
};

/* ----- Internal table memory ----- */

/* 3 (of 4) 1D cubic Hermite spline coefficients (per interval) */
typedef double CubicHermite1D[3];

/* 15 (of 16) 2D cubic Hermite spline coefficients (per grid) */
typedef double CubicHermite2D[15];

/* Left and right interval indices (per interval) */
typedef size_t Interval[2];

typedef struct CombiTimeTable {
    char* key; /* Key consisting of concatenated names of file and table */
    double* table; /* Table values */
    size_t nRow; /* Number of rows of table */
    size_t nCol; /* Number of columns of table */
    size_t last; /* Last accessed row index of table */
    enum Smoothness smoothness; /* Smoothness kind */
    enum Extrapolation extrapolation; /* Extrapolation kind */
    enum TableSource source; /* Source kind */
    enum TimeEvents timeEvents; /* Kind of time event handling */
    int* cols; /* Columns of table to be interpolated */
    size_t nCols; /* Number of columns of table to be interpolated */
    double startTime; /* Start time of inter-/extrapolation */
    double shiftTime; /* Shift time of first table column */
    CubicHermite1D* spline; /* Pre-calculated cubic Hermite spline coefficients */
    size_t nEvent; /* Time event counter, discrete */
    double preNextTimeEvent; /* Time of previous time event, discrete */
    double preNextTimeEventCalled; /* Time of previous call of nextTimeEvent, discrete */
    size_t maxEvents; /* Maximum number of time events (per period/cycle) */
    size_t eventInterval; /* Event interval marker, discrete. */
    double tOffset; /* Time offset, calculated by floor function, discrete */
    Interval* intervals; /* Event interval indices */
} CombiTimeTable;

typedef struct CombiTable1D {
    char* key; /* Key consisting of concatenated names of file and table */
    double* table; /* Table values */
    size_t nRow; /* Number of rows of table */
    size_t nCol; /* Number of columns of table */
    size_t last; /* Last accessed row index of table */
    enum Smoothness smoothness; /* Smoothness kind */
    enum Extrapolation extrapolation; /* Extrapolation kind */
    enum TableSource source; /* Source kind */
    int* cols; /* Columns of table to be interpolated */
    size_t nCols; /* Number of columns of table to be interpolated */
    CubicHermite1D* spline; /* Pre-calculated cubic Hermite spline coefficients */
} CombiTable1D;

typedef struct CombiTable2D {
    char* key; /* Key consisting of concatenated names of file and table */
    double* table; /* Table values */
    size_t nRow; /* Number of rows of table */
    size_t nCol; /* Number of columns of table */
    size_t last1; /* Last accessed row index of table */
    size_t last2; /* Last accessed column index of table */
    enum Smoothness smoothness; /* Smoothness kind */
    enum Extrapolation extrapolation; /* Extrapolation kind */
    enum TableSource source; /* Source kind */
    CubicHermite2D* spline; /* Pre-calculated cubic Hermite spline coefficients */
} CombiTable2D;

/* ----- Internal constants ----- */

#if !defined(_EPSILON)
#define _EPSILON (1e-10)
#endif
#if !defined(MAX_TABLE_DIMENSIONS)
#define MAX_TABLE_DIMENSIONS (3)
#endif
/* ----- Internal shortcuts ----- */

#define IDX(i, j, n) ((i)*(n) + (j))
#define TABLE(i, j) table[IDX(i, j, nCol)]
#define TABLE_ROW0(j) table[j]
#define TABLE_COL0(i) table[(i)*nCol]

#define BILINEAR_DER(u1, u2) \
do {\
    const double u10 = TABLE_COL0(last1 + 1); \
    const double u11 = TABLE_COL0(last1 + 2); \
    const double u20 = TABLE_ROW0(last2 + 1); \
    const double u21 = TABLE_ROW0(last2 + 2); \
    const double y00 = TABLE(last1 + 1, last2 + 1); \
    const double y01 = TABLE(last1 + 1, last2 + 2); \
    const double y10 = TABLE(last1 + 2, last2 + 1); \
    const double y11 = TABLE(last1 + 2, last2 + 2); \
    der_y = (u21*(y10 - y00) + u20*(y01 - y11) + \
        u2*(y00 - y01 - y10 + y11))*der_u1; \
    der_y += (u11*(y01 - y00) + u10*(y10 - y11) + \
        u1*(y00 - y01 - y10 + y11))*der_u2; \
    der_y /= (u10 - u11); \
    der_y /= (u20 - u21); \
} while (0)

/* ----- Internal functions ----- */

static int isNearlyEqual(double x, double y) {
    const double fx = fabs(x);
    const double fy = fabs(y);
    double cmp = fx > fy ? fx : fy;
    if (cmp < _EPSILON) {
        cmp = _EPSILON;
    }
    cmp *= _EPSILON;
    return fabs(y - x) < cmp;
}

static size_t findRowIndex(const double* table, size_t nRow, size_t nCol,
                           size_t last, double x) {
    size_t i0 = 0;
    size_t i1 = nRow - 1;
    if (x < TABLE_COL0(last)) {
        i1 = last;
    } else if (x >= TABLE_COL0(last + 1)) {
        i0 = last;
    } else {
        return last;
    }

    /* Binary search */
    while (i1 > i0 + 1) {
        const size_t i = (i0 + i1)/2;
        if (x < TABLE_COL0(i)) {
            i1 = i;
        } else {
            i0 = i;
        }
    }
    return i0;
}

static size_t findColIndex(const double* table, size_t nCol, size_t last,
                           double x) {
    size_t i0 = 0;
    size_t i1 = nCol - 1;
    if (x < TABLE_ROW0(last)) {
        i1 = last;
    } else if (x >= TABLE_ROW0(last + 1)) {
        i0 = last;
    } else {
        return last;
    }

    /* Binary search */
    while (i1 > i0 + 1) {
        const size_t i = (i0 + i1)/2;
        if (x < TABLE_ROW0(i)) {
            i1 = i;
        } else {
            i0 = i;
        }
    }
    return i0;
}


// Copied from DYNMOdelicaUtilies.c
void ModelicaError(const char *string) {
  throw DYNError(DYN::Error::GENERAL, ModelicaError, string);
}

void ModelicaVFormatError(const char *string, va_list args) {
  char buff[512];
  vsnprintf(buff, sizeof(buff), string, args);
  std::string buffAsStdStr = buff;
  throw DYNError(DYN::Error::GENERAL, ModelicaError, buffAsStdStr);
}

void ModelicaFormatError(const char *string, ...) {
  va_list args;
  va_start(args, string);
  ModelicaVFormatError(string, args);
  va_end(args);
}
// End of copied from ModelicaExternalC library

adept::adouble ModelicaStandardTables_CombiTable1D_getDerValue_adept(void* _tableID, int iCol,
                                                       adept::adouble der_u) {
    adept::adouble der_y = 0.;
    double u = der_u.value();
    CombiTable1D* tableID = reinterpret_cast<CombiTable1D*>(_tableID);
    if (NULL != tableID && NULL != tableID->table && NULL != tableID->cols) {
        const double* table = tableID->table;
        const size_t nRow = tableID->nRow;
        const size_t nCol = tableID->nCol;
        const size_t col = (size_t)tableID->cols[iCol - 1] - 1;

        if (nRow > 1) {
            enum PointInterval extrapolate = IN_TABLE;
            const double uMin = TABLE_ROW0(0);
            const double uMax = TABLE_COL0(nRow - 1);
            size_t last;

            /* Periodic extrapolation */
            if (tableID->extrapolation == PERIODIC) {
                const double T = uMax - uMin;

                if (u < uMin) {
                    do {
                        u += T;
                    } while (u < uMin);
                } else if (u > uMax) {
                    do {
                        u -= T;
                    } while (u > uMax);
                }
                last = findRowIndex(table, nRow, nCol, tableID->last, u);
                tableID->last = last;
            } else if (u < uMin) {
                extrapolate = LEFT;
                last = 0;
            } else if (u > uMax) {
                extrapolate = RIGHT;
                last = nRow - 2;
            } else {
                last = findRowIndex(table, nRow, nCol, tableID->last, u);
                tableID->last = last;
            }

            if (extrapolate == IN_TABLE) {
                switch (tableID->smoothness) {
                    case LINEAR_SEGMENTS:
                        der_y = (TABLE(last + 1, col) - TABLE(last, col))/
                            (TABLE_COL0(last + 1) - TABLE_COL0(last));
                        der_y *= der_u;
                        break;

                    case CONSTANT_SEGMENTS:
                        break;

                    case AKIMA_C1:
                    case FRITSCH_BUTLAND_MONOTONE_C1:
                    case STEFFEN_MONOTONE_C1:
                        if (NULL != tableID->spline) {
                            const double* c = tableID->spline[
                                IDX(last, (size_t)(iCol - 1), tableID->nCols)];
                            const double v = u - TABLE_COL0(last);
                            der_y = (3*c[0]*v + 2*c[1])*v + c[2];
                            der_y *= der_u;
                        }
                        break;

                    default:
                        ModelicaError("Unknown smoothness kind\n");
                        return der_y;
                }
            } else {
                /* Extrapolation */
                switch (tableID->extrapolation) {
                    case LAST_TWO_POINTS:
                        switch (tableID->smoothness) {
                            case LINEAR_SEGMENTS:
                            case  CONSTANT_SEGMENTS: {
                                const double u0 = TABLE_COL0(last);
                                const double u1 = TABLE_COL0(last + 1);
                                der_y = (TABLE(last + 1, col) - TABLE(last, col))/
                                    (u1 - u0);
                                break;
                            }

                            case AKIMA_C1:
                            case FRITSCH_BUTLAND_MONOTONE_C1:
                            case STEFFEN_MONOTONE_C1:
                                if (NULL != tableID->spline) {
                                    const double* c = tableID->spline[
                                        IDX(last, (size_t)(iCol - 1), tableID->nCols)];
                                    if (extrapolate == LEFT) {
                                        der_y = c[2];
                                    } else /* if (extrapolate == RIGHT) */ {
                                        der_y = uMax - TABLE_COL0(nRow - 2);
                                        der_y = (3*c[0]*der_y + 2*c[1])*
                                            der_y + c[2];
                                    }
                                }
                                break;

                            default:
                                ModelicaError("Unknown smoothness kind\n");
                                return der_y;
                        }
                        der_y *= der_u;
                        break;

                    case HOLD_LAST_POINT:
                        break;

                    case NO_EXTRAPOLATION:
                        ModelicaFormatError("Extrapolation error: The value u "
                            "(=%lf) must be %s or equal\nthan the %s abscissa "
                            "value %s (=%lf) defined in the table.\n", u,
                            (extrapolate == LEFT) ? "greater" : "less",
                            (extrapolate == LEFT) ? "minimum" : "maximum",
                            (extrapolate == LEFT) ? "u_min" : "u_max",
                            (extrapolate == LEFT) ? uMin : uMax);
                        return der_y;

                    case PERIODIC:
                        /* Should not be possible to get here */
                        break;

                    default:
                        ModelicaError("Unknown extrapolation kind\n");
                        return der_y;
                }
            }
        }
    }
    return der_y;
}

adept::adouble ModelicaStandardTables_CombiTable2D_getDerValue_adept(void* _tableID, adept::adouble der_u1,
                                                       adept::adouble der_u2) {
    adept::adouble der_y = 0;
    double u1 = der_u1.value();
    double u2 = der_u2.value();
    CombiTable2D* tableID = reinterpret_cast<CombiTable2D*>(_tableID);
    if (NULL != tableID && NULL != tableID->table) {
        const double* table = tableID->table;
        const size_t nRow = tableID->nRow;
        const size_t nCol = tableID->nCol;
        const double u1Min = TABLE_COL0(1);
        const double u1Max = TABLE_COL0(nRow - 1);
        const double u2Min = TABLE_ROW0(1);
        const double u2Max = TABLE_ROW0(nCol - 1);

        if (nRow == 2) {
            if (nCol > 2) {
                enum PointInterval extrapolate2 = IN_TABLE;
                size_t last2;

                /* Periodic extrapolation */
                if (tableID->extrapolation == PERIODIC) {
                    const double T = u2Max - u2Min;

                    if (u2 < u2Min) {
                        do {
                            u2 += T;
                        } while (u2 < u2Min);
                    } else if (u2 > u2Max) {
                        do {
                            u2 -= T;
                        } while (u2 > u2Max);
                    }
                    last2 = findColIndex(&TABLE(0, 1), nCol - 1,
                        tableID->last2, u2);
                    tableID->last2 = last2;
                } else if (u2 < u2Min) {
                    extrapolate2 = LEFT;
                    last2 = 0;
                } else if (u2 > u2Max) {
                    extrapolate2 = RIGHT;
                    last2 = nCol - 3;
                } else {
                    last2 = findColIndex(&TABLE(0, 1), nCol - 1,
                        tableID->last2, u2);
                    tableID->last2 = last2;
                }

                if (extrapolate2 == IN_TABLE) {
                    switch (tableID->smoothness) {
                        case LINEAR_SEGMENTS:
                            der_y = (TABLE(1, last2 + 2) - TABLE(1, last2 + 1))/
                                (TABLE_ROW0(last2 + 2) - TABLE_ROW0(last2 + 1));
                            der_y *= der_u2;
                            break;

                        case CONSTANT_SEGMENTS:
                            break;

                        case AKIMA_C1:
                            if (NULL != tableID->spline) {
                                const double* c = tableID->spline[last2];
                                const double u20 = TABLE_ROW0(last2 + 1);
                                u2 -= u20;
                                der_y = (3*c[0]*u2 + 2*c[1])*u2 + c[2];
                                der_y *= der_u2;
                            }
                            break;

                        case FRITSCH_BUTLAND_MONOTONE_C1:
                        case STEFFEN_MONOTONE_C1:
                            ModelicaError("Bivariate monotone C1 interpolation is "
                                "not implemented\n");
                            return der_y;

                        default:
                            ModelicaError("Unknown smoothness kind\n");
                            return der_y;
                    }
                } else {
                    /* Extrapolation */
                    switch (tableID->extrapolation) {
                        case LAST_TWO_POINTS:
                            switch (tableID->smoothness) {
                                case LINEAR_SEGMENTS:
                                case CONSTANT_SEGMENTS:
                                    der_y = (TABLE(1, last2 + 2) - TABLE(1, last2 + 1))/
                                        (TABLE_ROW0(last2 + 2) - TABLE_ROW0(last2 + 1));
                                    der_y *= der_u2;
                                    break;

                                case AKIMA_C1:
                                    if (NULL != tableID->spline) {
                                        const double* c = tableID->spline[last2];
                                        if (extrapolate2 == LEFT) {
                                            der_y = c[2];
                                        } else /* if (extrapolate2 == RIGHT) */ {
                                            const double u20 = TABLE_ROW0(last2 + 1);
                                            const double u21 = TABLE_ROW0(last2 + 2);
                                            der_y = u21 - u20;
                                            der_y = (3*c[0]*der_y + 2*c[1])*der_y + c[2];
                                        }
                                        der_y *= der_u2;
                                    }
                                    break;

                                case FRITSCH_BUTLAND_MONOTONE_C1:
                                case STEFFEN_MONOTONE_C1:
                                    ModelicaError("Bivariate monotone C1 interpolation is "
                                        "not implemented\n");
                                    return der_y;

                                default:
                                    ModelicaError("Unknown smoothness kind\n");
                                    return der_y;
                            }
                            break;

                        case HOLD_LAST_POINT:
                            break;

                        case NO_EXTRAPOLATION:
                            ModelicaFormatError("Extrapolation error: The value u2 "
                                "(=%lf) must be %s or equal\nthan the %s abscissa "
                                "value %s (=%lf) defined in the table.\n", u2,
                                (extrapolate2 == LEFT) ? "greater" : "less",
                                (extrapolate2 == LEFT) ? "minimum" : "maximum",
                                (extrapolate2 == LEFT) ? "u_min[2]" : "u_max[2]",
                                (extrapolate2 == LEFT) ? u2Min : u2Max);
                            return der_y;

                        case PERIODIC:
                            /* Should not be possible to get here */
                            break;

                        default:
                            ModelicaError("Unknown extrapolation kind\n");
                            return der_y;
                    }
                }
            }
        } else if (nRow > 2) {
            enum PointInterval extrapolate1 = IN_TABLE;
            size_t last1;

            /* Periodic extrapolation */
            if (tableID->extrapolation == PERIODIC) {
                const double T = u1Max - u1Min;

                if (u1 < u1Min) {
                    do {
                        u1 += T;
                    } while (u1 < u1Min);
                } else if (u1 > u1Max) {
                    do {
                        u1 -= T;
                    } while (u1 > u1Max);
                }
                last1 = findRowIndex(&TABLE(1, 0), nRow - 1, nCol,
                    tableID->last1, u1);
                tableID->last1 = last1;
            } else if (u1 < u1Min) {
                extrapolate1 = LEFT;
                last1 = 0;
            } else if (u1 > u1Max) {
                extrapolate1 = RIGHT;
                last1 = nRow - 3;
            } else {
                last1 = findRowIndex(&TABLE(1, 0), nRow - 1, nCol,
                    tableID->last1, u1);
                tableID->last1 = last1;
            }
            if (nCol == 2) {
                if (extrapolate1 == IN_TABLE) {
                    switch (tableID->smoothness) {
                        case LINEAR_SEGMENTS:
                            der_y = (TABLE(last1 + 2, 1) - TABLE(last1 + 1, 1))/
                                (TABLE_COL0(last1 + 2) - TABLE_COL0(last1 + 1));
                            der_y *= der_u1;
                            break;

                        case CONSTANT_SEGMENTS:
                            break;

                        case AKIMA_C1:
                            if (NULL != tableID->spline) {
                                const double* c = tableID->spline[last1];
                                const double u10 = TABLE_COL0(last1 + 1);
                                u1 -= u10;
                                der_y = (3*c[0]*u1 + 2*c[1])*u1 + c[2];
                                der_y *= der_u1;
                            }
                            break;

                        case FRITSCH_BUTLAND_MONOTONE_C1:
                        case STEFFEN_MONOTONE_C1:
                            ModelicaError("Bivariate monotone C1 interpolation is "
                                "not implemented\n");
                            return der_y;

                        default:
                            ModelicaError("Unknown smoothness kind\n");
                            return der_y;
                    }
                } else {
                    /* Extrapolation */
                    switch (tableID->extrapolation) {
                        case LAST_TWO_POINTS:
                            switch (tableID->smoothness) {
                                case LINEAR_SEGMENTS:
                                case CONSTANT_SEGMENTS:
                                    der_y = (TABLE(last1 + 2, 1) - TABLE(last1 + 1, 1))/
                                        (TABLE_COL0(last1 + 2) - TABLE_COL0(last1 + 1));
                                    der_y *= der_u1;
                                    break;

                                case AKIMA_C1:
                                    if (NULL != tableID->spline) {
                                        const double* c = tableID->spline[last1];
                                        if (extrapolate1 == LEFT) {
                                            der_y = c[2];
                                        } else /* if (extrapolate1 == RIGHT) */ {
                                            const double u10 = TABLE_COL0(last1 + 1);
                                            const double u11 = TABLE_COL0(last1 + 2);
                                            der_y = u11 - u10;
                                            der_y = (3*c[0]*der_y + 2*c[1])*der_y + c[2];
                                        }
                                        der_y *= der_u1;
                                    }
                                    break;

                                case FRITSCH_BUTLAND_MONOTONE_C1:
                                case STEFFEN_MONOTONE_C1:
                                    ModelicaError("Bivariate monotone C1 interpolation is "
                                        "not implemented\n");
                                    return der_y;

                                default:
                                    ModelicaError("Unknown smoothness kind\n");
                                    return der_y;
                            }
                            break;

                        case HOLD_LAST_POINT:
                            break;

                        case NO_EXTRAPOLATION:
                            ModelicaFormatError("Extrapolation error: The value u1 "
                                "(=%lf) must be %s or equal\nthan the %s abscissa "
                                "value %s (=%lf) defined in the table.\n", u1,
                                (extrapolate1 == LEFT) ? "greater" : "less",
                                (extrapolate1 == LEFT) ? "minimum" : "maximum",
                                (extrapolate1 == LEFT) ? "u_min[1]" : "u_max[1]",
                                (extrapolate1 == LEFT) ? u1Min : u1Max);
                            return der_y;

                        case PERIODIC:
                            /* Should not be possible to get here */
                            break;

                        default:
                            ModelicaError("Unknown extrapolation kind\n");
                            return der_y;
                    }
                }
            } else if (nCol > 2) {
                enum PointInterval extrapolate2 = IN_TABLE;
                size_t last2;

                /* Periodic extrapolation */
                if (tableID->extrapolation == PERIODIC) {
                    const double T = u2Max - u2Min;

                    if (u2 < u2Min) {
                        do {
                            u2 += T;
                        } while (u2 < u2Min);
                    } else if (u2 > u2Max) {
                        do {
                            u2 -= T;
                        } while (u2 > u2Max);
                    }
                    last2 = findColIndex(&TABLE(0, 1), nCol - 1,
                        tableID->last2, u2);
                    tableID->last2 = last2;
                } else if (u2 < u2Min) {
                    extrapolate2 = LEFT;
                    last2 = 0;
                } else if (u2 > u2Max) {
                    extrapolate2 = RIGHT;
                    last2 = nCol - 3;
                } else {
                    last2 = findColIndex(&TABLE(0, 1), nCol - 1,
                        tableID->last2, u2);
                    tableID->last2 = last2;
                }

                if (extrapolate1 == IN_TABLE) {
                    if (extrapolate2 == IN_TABLE) {
                        switch (tableID->smoothness) {
                            case LINEAR_SEGMENTS:
                                BILINEAR_DER(u1, u2);
                                break;

                            case CONSTANT_SEGMENTS:
                                break;

                            case AKIMA_C1:
                                if (NULL != tableID->spline) {
                                    const double* c = tableID->spline[
                                        IDX(last1, last2, nCol - 2)];
                                    double der_y1, der_y2;
                                    double p1, p2, p3;
                                    double dp1_u2, dp2_u2, dp3_u2, dp4_u2;
                                    u1 -= TABLE_COL0(last1 + 1);
                                    u2 -= TABLE_ROW0(last2 + 1);
                                    p1 = ((c[0]*u2 + c[1])*u2 + c[2])*u2 + c[3];
                                    p2 = ((c[4]*u2 + c[5])*u2 + c[6])*u2 + c[7];
                                    p3 = ((c[8]*u2 + c[9])*u2 + c[10])*u2 + c[11];
                                    dp1_u2 = (3*c[0]*u2 + 2*c[1])*u2 + c[2];
                                    dp2_u2 = (3*c[4]*u2 + 2*c[5])*u2 + c[6];
                                    dp3_u2 = (3*c[8]*u2 + 2*c[9])*u2 + c[10];
                                    dp4_u2 = (3*c[12]*u2 + 2*c[13])*u2 + c[14];
                                    der_y1 = (3*p1*u1 + 2*p2)*u1 + p3;
                                    der_y2 = ((dp1_u2*u1 + dp2_u2)*u1 + dp3_u2)*u1 + dp4_u2;
                                    der_y = der_y1*der_u1 + der_y2*der_u2;
                                 }
                                 break;

                            case FRITSCH_BUTLAND_MONOTONE_C1:
                            case STEFFEN_MONOTONE_C1:
                                ModelicaError("Bivariate monotone C1 interpolation is "
                                    "not implemented\n");
                                return der_y;

                            default:
                                ModelicaError("Unknown smoothness kind\n");
                                return der_y;
                        }
                    } else if (extrapolate2 == LEFT) {
                        switch (tableID->extrapolation) {
                            case LAST_TWO_POINTS:
                                switch (tableID->smoothness) {
                                    case LINEAR_SEGMENTS:
                                    case CONSTANT_SEGMENTS:
                                        BILINEAR_DER(u1, u2);
                                        break;

                                    case AKIMA_C1:
                                        if (NULL != tableID->spline) {
                                            const double* c = tableID->spline[
                                                IDX(last1, 0, nCol - 2)];
                                            double der_y1, der_y2;
                                            u1 -= TABLE_COL0(last1 + 1);
                                            u2 -= u2Min;
                                            der_y1 = (3*c[3]*u1 + 2*c[7])*u1 + c[11];
                                            der_y1 += ((3*c[2]*u1 + 2*c[6])*u1 + c[10])*u2;
                                            der_y2 = ((c[2]*u1 + c[6])*u1 + c[10])*u1 + c[14];
                                            der_y = der_y1*der_u1 + der_y2*der_u2;
                                         }
                                         break;

                                    case FRITSCH_BUTLAND_MONOTONE_C1:
                                    case STEFFEN_MONOTONE_C1:
                                        ModelicaError("Bivariate monotone C1 interpolation is "
                                            "not implemented\n");
                                        return der_y;

                                    default:
                                        ModelicaError("Unknown smoothness kind\n");
                                        return der_y;
                                 }
                                 break;

                            case HOLD_LAST_POINT:
                                break;

                            case NO_EXTRAPOLATION:
                                ModelicaFormatError("Extrapolation error: The value u2 "
                                    "(=%lf) must be greater or equal\nthan the minimum abscissa "
                                    "value u_min[2] (=%lf) defined in the table.\n", u2, u2Min);
                                return der_y;

                            case PERIODIC:
                                /* Should not be possible to get here */
                                break;

                            default:
                                ModelicaError("Unknown extrapolation kind\n");
                                return der_y;
                        }
                    } else /* if (extrapolate2 == RIGHT) */ {
                        switch (tableID->extrapolation) {
                            case LAST_TWO_POINTS:
                                switch (tableID->smoothness) {
                                    case LINEAR_SEGMENTS:
                                    case CONSTANT_SEGMENTS:
                                        BILINEAR_DER(u1, u2);
                                        break;

                                    case AKIMA_C1:
                                        if (NULL != tableID->spline) {
                                            const double* c = tableID->spline[
                                                IDX(last1, nCol - 3, nCol - 2)];
                                            double der_y1, der_y2;
                                            const double v2 = u2Max - TABLE_ROW0(nCol - 2);
                                            double p1, p2, p3;
                                            double dp1_u2, dp2_u2, dp3_u2, dp4_u2;
                                            u1 -= TABLE_COL0(last1 + 1);
                                            u2 -= u2Max;
                                            p1 = ((c[0]*v2 + c[1])*v2 + c[2])*v2 + c[3];
                                            p2 = ((c[4]*v2 + c[5])*v2 + c[6])*v2 + c[7];
                                            p3 = ((c[8]*v2 + c[9])*v2 + c[10])*v2 + c[11];
                                            dp1_u2 = (3*c[0]*v2 + 2*c[1])*v2 + c[2];
                                            dp2_u2 = (3*c[4]*v2 + 2*c[5])*v2 + c[6];
                                            dp3_u2 = (3*c[8]*v2 + 2*c[9])*v2 + c[10];
                                            dp4_u2 = (3*c[12]*v2 + 2*c[13])*v2 + c[14];
                                            der_y1 = (3*p1*u1 + 2*p2)*u1 + p3;
                                            der_y1 += ((3*dp1_u2*u1 + 2*dp2_u2)*u1 + dp3_u2)*u2;
                                            der_y2 = ((dp1_u2*u1 + dp2_u2)*u1 + dp3_u2)*u1 + dp4_u2;
                                            der_y = der_y1*der_u1 + der_y2*der_u2;
                                         }
                                         break;

                                    case FRITSCH_BUTLAND_MONOTONE_C1:
                                    case STEFFEN_MONOTONE_C1:
                                        ModelicaError("Bivariate monotone C1 interpolation is "
                                            "not implemented\n");
                                        return der_y;

                                    default:
                                        ModelicaError("Unknown smoothness kind\n");
                                        return der_y;
                                 }
                                 break;

                            case HOLD_LAST_POINT:
                                break;

                            case NO_EXTRAPOLATION:
                                ModelicaFormatError("Extrapolation error: The value u2 "
                                    "(=%lf) must be less or equal\nthan the maximum abscissa "
                                    "value u_max[2] (=%lf) defined in the table.\n", u2, u2Max);
                                return der_y;

                            case PERIODIC:
                                /* Should not be possible to get here */
                                break;

                            default:
                                ModelicaError("Unknown extrapolation kind\n");
                                return der_y;
                        }
                    }
                } else if (extrapolate1 == LEFT) {
                    if (extrapolate2 == IN_TABLE) {
                        switch (tableID->extrapolation) {
                            case LAST_TWO_POINTS:
                                switch (tableID->smoothness) {
                                    case LINEAR_SEGMENTS:
                                    case CONSTANT_SEGMENTS:
                                        BILINEAR_DER(u1, u2);
                                        break;

                                    case AKIMA_C1:
                                        if (NULL != tableID->spline) {
                                            const double* c = tableID->spline[
                                                IDX(0, last2, nCol - 2)];
                                            double der_y1, der_y2;
                                            u1 -= u1Min;
                                            u2 -= TABLE_ROW0(last2 + 1);
                                            der_y1 = ((c[8]*u2 + c[9])*u2 + c[10])*u2 + c[11];
                                            der_y2 = (3*c[12]*u2 + 2*c[13])*u2 + c[14];
                                            der_y2 += ((3*c[8]*u2 + 2*c[9])*u2 + c[10])*u1;
                                            der_y = der_y1*der_u1 + der_y2*der_u2;
                                         }
                                         break;

                                    case FRITSCH_BUTLAND_MONOTONE_C1:
                                    case STEFFEN_MONOTONE_C1:
                                        ModelicaError("Bivariate monotone C1 interpolation is "
                                            "not implemented\n");
                                        return der_y;

                                    default:
                                        ModelicaError("Unknown smoothness kind\n");
                                        return der_y;
                                 }
                                 break;

                            case HOLD_LAST_POINT:
                                break;

                            case NO_EXTRAPOLATION:
                                ModelicaFormatError("Extrapolation error: The value u1 "
                                    "(=%lf) must be greater or equal\nthan the minimum abscissa "
                                    "value u_min[1] (=%lf) defined in the table.\n", u1, u1Min);
                                return der_y;

                            case PERIODIC:
                                /* Should not be possible to get here */
                                break;

                            default:
                                ModelicaError("Unknown extrapolation kind\n");
                                return der_y;
                        }
                    } else if (extrapolate2 == LEFT) {
                        switch (tableID->extrapolation) {
                            case LAST_TWO_POINTS:
                                switch (tableID->smoothness) {
                                    case LINEAR_SEGMENTS:
                                    case CONSTANT_SEGMENTS:
                                        BILINEAR_DER(u1, u2);
                                        break;

                                    case AKIMA_C1:
                                        if (NULL != tableID->spline) {
                                            const double* c = tableID->spline[
                                                IDX(0, 0, nCol - 2)];
                                            double der_y1, der_y2, der_y12;
                                            u1 -= u1Min;
                                            u2 -= u2Min;
                                            der_y1 = c[11];
                                            der_y2 = c[14];
                                            der_y12 = c[10];
                                            der_y = (der_y1 + der_y12*u2)*der_u1;
                                            der_y += (der_y2 + der_y12*u1)*der_u2;
                                         }
                                         break;

                                    case FRITSCH_BUTLAND_MONOTONE_C1:
                                    case STEFFEN_MONOTONE_C1:
                                        ModelicaError("Bivariate monotone C1 interpolation is "
                                            "not implemented\n");
                                        return der_y;

                                    default:
                                        ModelicaError("Unknown smoothness kind\n");
                                        return der_y;
                                 }
                                 break;

                            case HOLD_LAST_POINT:
                                break;

                            case NO_EXTRAPOLATION:
                                ModelicaFormatError("Extrapolation error: The value u1 "
                                    "(=%lf) must be greater or equal\nthan the minimum abscissa "
                                    "value u_min[1] (=%lf) defined in the table.\n"
                                    "Extrapolation error: The value u2 (=%lf) must be greater "
                                    "or equal\nthan the minimum abscissa value u_min[2] (=%lf) "
                                    "defined in the table.\n", u1, u1Min, u2, u2Min);
                                return der_y;

                            case PERIODIC:
                                /* Should not be possible to get here */
                                break;

                            default:
                                ModelicaError("Unknown extrapolation kind\n");
                                return der_y;
                        }
                    } else /* if (extrapolate2 == RIGHT) */ {
                        switch (tableID->extrapolation) {
                            case LAST_TWO_POINTS:
                                switch (tableID->smoothness) {
                                    case LINEAR_SEGMENTS:
                                    case CONSTANT_SEGMENTS:
                                        BILINEAR_DER(u1, u2);
                                        break;

                                    case AKIMA_C1:
                                        if (NULL != tableID->spline) {
                                            const double* c = tableID->spline[
                                                IDX(0, nCol - 3, nCol - 2)];
                                            const double v2 = u2Max - TABLE_ROW0(nCol - 2);
                                            double der_y1, der_y2, der_y12;
                                            u1 -= u1Min;
                                            u2 -= u2Max;
                                            der_y1 = ((c[8]*v2 + c[9])*v2 + c[10])*v2 + c[11];
                                            der_y2 =(3*c[12]*v2 + 2*c[13])*v2 + c[14];
                                            der_y12 = (3*c[8]*v2 + 2*c[9])*v2 + c[10];
                                            der_y = (der_y1 + der_y12*u2)*der_u1;
                                            der_y += (der_y2 + der_y12*u1)*der_u2;
                                         }
                                         break;

                                    case FRITSCH_BUTLAND_MONOTONE_C1:
                                    case STEFFEN_MONOTONE_C1:
                                        ModelicaError("Bivariate monotone C1 interpolation is "
                                            "not implemented\n");
                                        return der_y;

                                    default:
                                        ModelicaError("Unknown smoothness kind\n");
                                        return der_y;
                                 }
                                 break;

                            case HOLD_LAST_POINT:
                                break;

                            case NO_EXTRAPOLATION:
                                ModelicaFormatError("Extrapolation error: The value u1 "
                                    "(=%lf) must be greater or equal\nthan the minimum abscissa "
                                    "value u_min[1] (=%lf) defined in the table.\n"
                                    "Extrapolation error: The value u2 (=%lf) must be less "
                                    "or equal\nthan the maximum abscissa value u_max[2] (=%lf) "
                                    "defined in the table.\n", u1, u1Min, u2, u2Max);
                                return der_y;

                            case PERIODIC:
                                /* Should not be possible to get here */
                                break;

                            default:
                                ModelicaError("Unknown extrapolation kind\n");
                                return der_y;
                        }
                    }
                } else /* if (extrapolate1 == RIGHT) */ {
                    if (extrapolate2 == IN_TABLE) {
                        switch (tableID->extrapolation) {
                            case LAST_TWO_POINTS:
                                switch (tableID->smoothness) {
                                    case LINEAR_SEGMENTS:
                                    case CONSTANT_SEGMENTS:
                                        BILINEAR_DER(u1, u2);
                                        break;

                                    case AKIMA_C1:
                                        if (NULL != tableID->spline) {
                                            const double* c = tableID->spline[
                                                IDX(nRow - 3, last2, nCol - 2)];
                                            const double v1 = u1Max - TABLE_COL0(nRow - 2);
                                            double p1, p2, p3;
                                            double dp1_u2, dp2_u2, dp3_u2, dp4_u2;
                                            double der_y1, der_y2;
                                            u1 -= u1Max;
                                            u2 -= TABLE_ROW0(last2 + 1);
                                            p1 = ((c[0]*u2 + c[1])*u2 + c[2])*u2 + c[3];
                                            p2 = ((c[4]*u2 + c[5])*u2 + c[6])*u2 + c[7];
                                            p3 = ((c[8]*u2 + c[9])*u2 + c[10])*u2 + c[11];
                                            dp1_u2 = (3*c[0]*u2 + 2*c[1])*u2 + c[2];
                                            dp2_u2 = (3*c[4]*u2 + 2*c[5])*u2 + c[6];
                                            dp3_u2 = (3*c[8]*u2 + 2*c[9])*u2 + c[10];
                                            dp4_u2 = (3*c[12]*u2 + 2*c[13])*u2 + c[14];
                                            der_y1 = (3*p1*v1 + 2*p2)*v1 + p3;
                                            der_y2 = ((dp1_u2*v1 + dp2_u2)*v1 + dp3_u2)*v1 + dp4_u2;
                                            der_y2 += ((3*dp1_u2*v1 + 2*dp2_u2)*v1 + dp3_u2)*u1;
                                            der_y = der_y1*der_u1 + der_y2*der_u2;
                                         }
                                         break;

                                    case FRITSCH_BUTLAND_MONOTONE_C1:
                                    case STEFFEN_MONOTONE_C1:
                                        ModelicaError("Bivariate monotone C1 interpolation is "
                                            "not implemented\n");
                                        return der_y;

                                    default:
                                        ModelicaError("Unknown smoothness kind\n");
                                        return der_y;
                                 }
                                 break;

                            case HOLD_LAST_POINT:
                                break;

                            case NO_EXTRAPOLATION:
                                ModelicaFormatError("Extrapolation error: The value u1 "
                                    "(=%lf) must be less or equal\nthan the maximum abscissa "
                                    "value u_max[1] (=%lf) defined in the table.\n", u1, u1Max);
                                return der_y;

                            case PERIODIC:
                                /* Should not be possible to get here */
                                break;

                            default:
                                ModelicaError("Unknown extrapolation kind\n");
                                return der_y;
                        }
                    } else if (extrapolate2 == LEFT) {
                        switch (tableID->extrapolation) {
                            case LAST_TWO_POINTS:
                                switch (tableID->smoothness) {
                                    case LINEAR_SEGMENTS:
                                    case CONSTANT_SEGMENTS:
                                        BILINEAR_DER(u1, u2);
                                        break;

                                    case AKIMA_C1:
                                        if (NULL != tableID->spline) {
                                            const double* c = tableID->spline[
                                                IDX(nRow - 3, 0, nCol - 2)];
                                            const double v1 = u1Max - TABLE_COL0(nRow - 2);
                                            double der_y1, der_y2, der_y12;
                                            u1 -= u1Max;
                                            u2 -= u2Min;
                                            der_y1 = (3*c[3]*v1 + 2*c[7])*v1 + c[11];
                                            der_y2 = ((c[2]*v1 + c[6])*v1 + c[10])*v1 + c[14];
                                            der_y12 = (3*c[2]*v1 + 2*c[6])*v1 + c[10];
                                            der_y = (der_y1 + der_y12*u2)*der_u1;
                                            der_y += (der_y2 + der_y12*u1)*der_u2;
                                         }
                                         break;

                                    case FRITSCH_BUTLAND_MONOTONE_C1:
                                    case STEFFEN_MONOTONE_C1:
                                        ModelicaError("Bivariate monotone C1 interpolation is "
                                            "not implemented\n");
                                        return der_y;

                                    default:
                                        ModelicaError("Unknown smoothness kind\n");
                                        return der_y;
                                 }
                                 break;

                            case HOLD_LAST_POINT:
                                break;

                            case NO_EXTRAPOLATION:
                                ModelicaFormatError("Extrapolation error: The value u1 "
                                    "(=%lf) must be less or equal\nthan the maximum abscissa "
                                    "value u_max[1] (=%lf) defined in the table.\n"
                                    "Extrapolation error: The value u2 (=%lf) must be greater "
                                    "or equal\nthan the minimum abscissa value u_min[2] (=%lf) "
                                    "defined in the table.\n", u1, u1Max, u2, u2Min);
                                return der_y;

                            case PERIODIC:
                                /* Should not be possible to get here */
                                break;

                            default:
                                ModelicaError("Unknown extrapolation kind\n");
                                return der_y;
                        }
                    } else /* if (extrapolate2 == RIGHT) */ {
                        switch (tableID->extrapolation) {
                            case LAST_TWO_POINTS:
                                switch (tableID->smoothness) {
                                    case LINEAR_SEGMENTS:
                                    case CONSTANT_SEGMENTS:
                                        BILINEAR_DER(u1, u2);
                                        break;

                                    case AKIMA_C1:
                                        if (NULL != tableID->spline) {
                                            const double* c = tableID->spline[
                                                IDX(nRow - 3, nCol - 3, nCol - 2)];
                                            const double v1 = u1Max - TABLE_COL0(nRow - 2);
                                            const double v2 = u2Max - TABLE_ROW0(nCol - 2);
                                            double p1, p2, p3;
                                            double dp1_u2, dp2_u2, dp3_u2, dp4_u2;
                                            double der_y1, der_y2, der_y12;
                                            u1 -= u1Max;
                                            u2 -= u2Max;
                                            p1 = ((c[0]*v2 + c[1])*v2 + c[2])*v2 + c[3];
                                            p2 = ((c[4]*v2 + c[5])*v2 + c[6])*v2 + c[7];
                                            p3 = ((c[8]*v2 + c[9])*v2 + c[10])*v2 + c[11];
                                            dp1_u2 = (3*c[0]*v2 + 2*c[1])*v2 + c[2];
                                            dp2_u2 = (3*c[4]*v2 + 2*c[5])*v2 + c[6];
                                            dp3_u2 = (3*c[8]*v2 + 2*c[9])*v2 + c[10];
                                            dp4_u2 = (3*c[12]*v2 + 2*c[13])*v2 + c[14];
                                            der_y1 = (3*p1*v1 + 2*p2)*v1 + p3;
                                            der_y2 = ((dp1_u2*v1 + dp2_u2)*v1 + dp3_u2)*v1 + dp4_u2;
                                            der_y12 = (3*dp1_u2*v1 + 2*dp2_u2)*v1 + dp3_u2;
                                            der_y = (der_y1 + der_y12*u2)*der_u1;
                                            der_y += (der_y2 + der_y12*u1)*der_u2;
                                         }
                                         break;

                                    case FRITSCH_BUTLAND_MONOTONE_C1:
                                    case STEFFEN_MONOTONE_C1:
                                        ModelicaError("Bivariate monotone C1 interpolation is "
                                            "not implemented\n");
                                        return der_y;

                                    default:
                                        ModelicaError("Unknown smoothness kind\n");
                                        return der_y;
                                 }
                                 break;

                            case HOLD_LAST_POINT:
                                break;

                            case NO_EXTRAPOLATION:
                                ModelicaFormatError("Extrapolation error: The value u1 "
                                    "(=%lf) must be less or equal\nthan the maximum abscissa "
                                    "value u_max[1] (=%lf) defined in the table.\n"
                                    "Extrapolation error: The value u2 (=%lf) must be less "
                                    "or equal\nthan the maximum abscissa value u_max[2] (=%lf) "
                                    "defined in the table.\n", u1, u1Max, u2, u2Max);
                                return der_y;

                            case PERIODIC:
                                /* Should not be possible to get here */
                                break;

                            default:
                                ModelicaError("Unknown extrapolation kind\n");
                                return der_y;
                        }
                    }
                }
            }
        }
    }
    return der_y;
}

adept::adouble ModelicaStandardTables_CombiTimeTable_getDerValue_adept(void* _tableID, int iCol,
                                                         adept::adouble der_t,
                                                         double nextTimeEvent,
                                                         double preNextTimeEvent) {
    adept::adouble der_y = 0.;
    double t = der_t.value();
    CombiTimeTable* tableID = reinterpret_cast<CombiTimeTable*>(_tableID);
    if (NULL != tableID && NULL != tableID->table && NULL != tableID->cols &&
        t >= tableID->startTime) {
        if (nextTimeEvent < DBL_MAX && nextTimeEvent == preNextTimeEvent &&
            tableID->startTime >= nextTimeEvent) {
            /* Before start time event iteration: Return zero */
            return der_y;
        } else {
            const double* table = tableID->table;
            const size_t nRow = tableID->nRow;
            const size_t nCol = tableID->nCol;
            const size_t col = (size_t)tableID->cols[iCol - 1] - 1;

            if (nRow > 1) {
                enum PointInterval extrapolate = IN_TABLE;
                const double tMin = TABLE_ROW0(0);
                const double tMax = TABLE_COL0(nRow - 1);
                size_t last = 0;
                int haveLast = 0;
                /* Shift time */
                const double tOld = t;
                t -= tableID->shiftTime;

                /* Periodic extrapolation */
                if (tableID->extrapolation == PERIODIC) {
                    const double T = tMax - tMin;
                    /* Event handling for periodic extrapolation */
                    if (nextTimeEvent == preNextTimeEvent &&
                        tOld >= nextTimeEvent) {
                        /* Before event iteration: Return previous
                           interval value */
                        last = tableID->intervals[
                            tableID->eventInterval - 1][1] - 1;
                        haveLast = 1;
                    } else if (nextTimeEvent > preNextTimeEvent &&
                        tOld >= preNextTimeEvent &&
                        tableID->startTime < preNextTimeEvent) {
                        /* In regular (= not start time) event iteration:
                           Return left interval value */
                        last = tableID->intervals[
                            tableID->eventInterval - 1][0];
                        haveLast = 1;
                    } else {
                        /* After event iteration */
                        const size_t i0 = tableID->intervals[
                            tableID->eventInterval - 1][0];
                        const size_t i1 = tableID->intervals[
                            tableID->eventInterval - 1][1];

                        t -= tableID->tOffset;
                        if (t < tMin) {
                            do {
                                t += T;
                            } while (t < tMin);
                        } else if (t > tMax) {
                            do {
                                t -= T;
                            } while (t > tMax);
                        }
                        last = findRowIndex(
                            table, nRow, nCol, tableID->last, t);
                        tableID->last = last;
                        /* Event interval correction */
                        if (last < i0) {
                            t = TABLE_COL0(i0);
                        }
                        if (last >= i1) {
                            if (tableID->eventInterval == 1) {
                                t = TABLE_COL0(i0);
                            } else {
                                t = TABLE_COL0(i1);
                            }
                        }
                    }
                } else if (t < tMin) {
                    extrapolate = LEFT;
                } else if (t >= tMax) {
                    extrapolate = RIGHT;
                    /* Event handling for non-periodic extrapolation */
                    if (nextTimeEvent == preNextTimeEvent &&
                        nextTimeEvent < DBL_MAX && tOld >= nextTimeEvent) {
                        /* Before event iteration */
                        extrapolate = IN_TABLE;
                    }
                }

                if (extrapolate == IN_TABLE) {
                    if (tableID->extrapolation != PERIODIC) {
                        /* Event handling for non-periodic extrapolation */
                        if (nextTimeEvent == preNextTimeEvent &&
                            nextTimeEvent < DBL_MAX && tOld >= nextTimeEvent) {
                            /* Before event iteration */
                            if (tableID->eventInterval == 1) {
                                last = 0;
                                extrapolate = LEFT;
                            } else if (tableID->smoothness == CONSTANT_SEGMENTS) {
                                last = tableID->intervals[
                                    tableID->eventInterval - 2][0];
                            } else if (tableID->smoothness == LINEAR_SEGMENTS) {
                                last = tableID->intervals[
                                    tableID->eventInterval - 2][1];
                            } else if (t >= tMax) {
                                last = nRow - 1;
                            } else {
                                last = findRowIndex(table, nRow, nCol,
                                    tableID->last, t);
                                tableID->last = last;
                            }
                            if (last > 0 && extrapolate == IN_TABLE) {
                                last--;
                            }
                            haveLast = 1;
                        }
                    }

                    if (!haveLast) {
                        last = findRowIndex(table, nRow, nCol, tableID->last, t);
                        tableID->last = last;
                    }

                    if (tableID->extrapolation != PERIODIC &&
                        tableID->eventInterval > 1) {
                        const size_t i0 = tableID->intervals[
                            tableID->eventInterval - 2][0];
                        const size_t i1 = tableID->intervals[
                            tableID->eventInterval - 2][1];

                       if (last < i0) {
                            last = i0;
                        }
                        if (last >= i1) {
                            last = i0;
                        }
                    }
                }

                if (extrapolate == IN_TABLE) {
                    /* Interpolation */
                    switch (tableID->smoothness) {
                        case LINEAR_SEGMENTS: {
                            const double t0 = TABLE_COL0(last);
                            const double t1 = TABLE_COL0(last + 1);
                            if (!isNearlyEqual(t0, t1)) {
                                der_y = (TABLE(last + 1, col) - TABLE(last, col))/
                                    (t1 - t0);
                                der_y *= der_t;
                            }
                            break;
                        }

                        case CONSTANT_SEGMENTS:
                            break;

                        case AKIMA_C1:
                        case FRITSCH_BUTLAND_MONOTONE_C1:
                        case STEFFEN_MONOTONE_C1:
                            if (NULL != tableID->spline) {
                                const double* c = tableID->spline[
                                    IDX(last, (size_t)(iCol - 1), tableID->nCols)];
                                t -= TABLE_COL0(last);
                                der_y = (3*c[0]*t + 2*c[1])*t + c[2];
                                der_y *= der_t;
                            }
                            break;

                        default:
                            ModelicaError("Unknown smoothness kind\n");
                            return der_y;
                    }
                } else {
                    /* Extrapolation */
                    switch (tableID->extrapolation) {
                        case LAST_TWO_POINTS:
                            last = (extrapolate == RIGHT) ? nRow - 2 : 0;
                            switch (tableID->smoothness) {
                                case LINEAR_SEGMENTS:
                                case CONSTANT_SEGMENTS: {
                                    const double t0 = TABLE_COL0(last);
                                    const double t1 = TABLE_COL0(last + 1);
                                    if (!isNearlyEqual(t0, t1)) {
                                        der_y = (TABLE(last + 1, col) - TABLE(last, col))/
                                            (t1 - t0);
                                    }
                                    break;
                                }

                                case AKIMA_C1:
                                case FRITSCH_BUTLAND_MONOTONE_C1:
                                case STEFFEN_MONOTONE_C1:
                                    if (NULL != tableID->spline) {
                                        const double* c = tableID->spline[
                                            IDX(last, (size_t)(iCol - 1), tableID->nCols)];
                                        if (extrapolate == LEFT) {
                                            der_y = c[2];
                                        } else /* if (extrapolate == RIGHT) */ {
                                            der_y = tMax - TABLE_COL0(nRow - 2);
                                            der_y = (3*c[0]*der_y + 2*c[1])*
                                                der_y + c[2];
                                        }
                                    }
                                    break;

                                default:
                                    ModelicaError("Unknown smoothness kind\n");
                                    return der_y;
                            }
                            der_y *= der_t;
                            break;

                        case HOLD_LAST_POINT:
                            break;

                        case NO_EXTRAPOLATION:
                            ModelicaFormatError("Extrapolation error: Time "
                                "(=%lf) must be %s or equal\nthan the %s abscissa "
                                "value %s (=%lf) defined in the table.\n", tOld,
                                (extrapolate == LEFT) ? "greater" : "less",
                                (extrapolate == LEFT) ? "minimum" : "maximum",
                                (extrapolate == LEFT) ? "t_min" : "t_max",
                                (extrapolate == LEFT) ? tMin : tMax);
                            return der_y;

                        case PERIODIC:
                            /* Should not be possible to get here */
                            break;

                        default:
                            ModelicaError("Unknown extrapolation kind\n");
                            return der_y;
                    }
                }
            }
        }
    }
    return der_y;
}
#endif
