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
 * @file  DYNModelManagerOwnFunctions.cpp
 *
 * @brief implementation of functions needed by dynawo (specific implementation)
 *
 */
#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-function"
# endif  // __clang__

#include <cstdlib>
#include <cstdarg>
#include <cassert>
#include <cstring>
#include <cctype>
#include "DYNModelManagerOwnFunctions.h"

#if defined(_LP64)
#define MMC_LOG2_SIZE_INT 3
#elif defined(_LLP64) || defined(_WIN64) || defined(__MINGW64__)
#define MMC_LOG2_SIZE_INT 3
#else
#define MMC_LOG2_SIZE_INT 2
#endif

#define MMC_STRINGHDR(nbytes)     ((((mmc_uint_t)nbytes) << (3))+((1 << (3+MMC_LOG2_SIZE_INT))+5))
#define MMC_HDRISSTRING(hdr)      (((hdr) & (7)) == 5)
#define MMC_HDRSTRINGSLOTS(hdr)   ((hdr) >> (3+MMC_LOG2_SIZE_INT))
#define MMC_HDRSLOTS(hdr)         ((MMC_HDRISSTRING(hdr)) ? (MMC_HDRSTRINGSLOTS(hdr)) : ((hdr) >> 10))
#define MMC_TAGPTR(p)             (reinterpret_cast<void*>(reinterpret_cast<char*>(p) + 0))
#define MMC_REFSTRINGLIT(NAME) MMC_TAGPTR(&(NAME).header)
#define MMC_DEFSTRINGLIT(NAME, LEN, VAL)  \
    struct {        \
      mmc_uint_t header;    \
      const char data[(LEN)+1];    \
    } NAME = { MMC_STRINGHDR(LEN), VAL }
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_0, 0, "");
void* mmc_emptystring = MMC_REFSTRINGLIT(OMC_STRINGLIT_0);
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_01, 1, "\x01");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_02, 1, "\x02");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_03, 1, "\x03");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_04, 1, "\x04");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_05, 1, "\x05");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_06, 1, "\x06");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_07, 1, "\x07");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_08, 1, "\x08");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_09, 1, "\x09");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_0A, 1, "\x0A");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_0B, 1, "\x0B");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_0C, 1, "\x0C");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_0D, 1, "\x0D");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_0E, 1, "\x0E");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_0F, 1, "\x0F");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_10, 1, "\x10");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_11, 1, "\x11");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_12, 1, "\x12");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_13, 1, "\x13");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_14, 1, "\x14");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_15, 1, "\x15");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_16, 1, "\x16");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_17, 1, "\x17");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_18, 1, "\x18");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_19, 1, "\x19");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_1A, 1, "\x1A");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_1B, 1, "\x1B");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_1C, 1, "\x1C");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_1D, 1, "\x1D");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_1E, 1, "\x1E");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_1F, 1, "\x1F");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_20, 1, "\x20");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_21, 1, "\x21");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_22, 1, "\x22");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_23, 1, "\x23");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_24, 1, "\x24");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_25, 1, "\x25");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_26, 1, "\x26");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_27, 1, "\x27");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_28, 1, "\x28");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_29, 1, "\x29");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_2A, 1, "\x2A");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_2B, 1, "\x2B");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_2C, 1, "\x2C");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_2D, 1, "\x2D");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_2E, 1, "\x2E");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_2F, 1, "\x2F");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_30, 1, "\x30");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_31, 1, "\x31");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_32, 1, "\x32");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_33, 1, "\x33");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_34, 1, "\x34");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_35, 1, "\x35");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_36, 1, "\x36");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_37, 1, "\x37");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_38, 1, "\x38");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_39, 1, "\x39");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_3A, 1, "\x3A");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_3B, 1, "\x3B");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_3C, 1, "\x3C");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_3D, 1, "\x3D");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_3E, 1, "\x3E");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_3F, 1, "\x3F");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_40, 1, "\x40");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_41, 1, "\x41");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_42, 1, "\x42");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_43, 1, "\x43");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_44, 1, "\x44");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_45, 1, "\x45");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_46, 1, "\x46");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_47, 1, "\x47");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_48, 1, "\x48");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_49, 1, "\x49");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_4A, 1, "\x4A");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_4B, 1, "\x4B");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_4C, 1, "\x4C");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_4D, 1, "\x4D");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_4E, 1, "\x4E");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_4F, 1, "\x4F");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_50, 1, "\x50");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_51, 1, "\x51");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_52, 1, "\x52");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_53, 1, "\x53");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_54, 1, "\x54");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_55, 1, "\x55");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_56, 1, "\x56");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_57, 1, "\x57");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_58, 1, "\x58");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_59, 1, "\x59");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_5A, 1, "\x5A");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_5B, 1, "\x5B");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_5C, 1, "\x5C");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_5D, 1, "\x5D");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_5E, 1, "\x5E");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_5F, 1, "\x5F");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_60, 1, "\x60");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_61, 1, "\x61");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_62, 1, "\x62");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_63, 1, "\x63");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_64, 1, "\x64");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_65, 1, "\x65");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_66, 1, "\x66");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_67, 1, "\x67");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_68, 1, "\x68");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_69, 1, "\x69");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_6A, 1, "\x6A");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_6B, 1, "\x6B");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_6C, 1, "\x6C");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_6D, 1, "\x6D");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_6E, 1, "\x6E");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_6F, 1, "\x6F");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_70, 1, "\x70");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_71, 1, "\x71");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_72, 1, "\x72");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_73, 1, "\x73");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_74, 1, "\x74");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_75, 1, "\x75");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_76, 1, "\x76");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_77, 1, "\x77");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_78, 1, "\x78");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_79, 1, "\x79");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_7A, 1, "\x7A");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_7B, 1, "\x7B");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_7C, 1, "\x7C");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_7D, 1, "\x7D");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_7E, 1, "\x7E");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_7F, 1, "\x7F");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_80, 1, "\x80");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_81, 1, "\x81");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_82, 1, "\x82");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_83, 1, "\x83");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_84, 1, "\x84");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_85, 1, "\x85");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_86, 1, "\x86");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_87, 1, "\x87");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_88, 1, "\x88");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_89, 1, "\x89");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_8A, 1, "\x8A");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_8B, 1, "\x8B");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_8C, 1, "\x8C");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_8D, 1, "\x8D");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_8E, 1, "\x8E");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_8F, 1, "\x8F");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_90, 1, "\x90");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_91, 1, "\x91");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_92, 1, "\x92");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_93, 1, "\x93");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_94, 1, "\x94");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_95, 1, "\x95");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_96, 1, "\x96");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_97, 1, "\x97");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_98, 1, "\x98");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_99, 1, "\x99");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_9A, 1, "\x9A");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_9B, 1, "\x9B");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_9C, 1, "\x9C");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_9D, 1, "\x9D");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_9E, 1, "\x9E");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_9F, 1, "\x9F");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_A0, 1, "\xA0");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_A1, 1, "\xA1");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_A2, 1, "\xA2");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_A3, 1, "\xA3");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_A4, 1, "\xA4");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_A5, 1, "\xA5");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_A6, 1, "\xA6");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_A7, 1, "\xA7");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_A8, 1, "\xA8");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_A9, 1, "\xA9");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_AA, 1, "\xAA");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_AB, 1, "\xAB");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_AC, 1, "\xAC");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_AD, 1, "\xAD");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_AE, 1, "\xAE");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_AF, 1, "\xAF");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_B0, 1, "\xB0");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_B1, 1, "\xB1");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_B2, 1, "\xB2");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_B3, 1, "\xB3");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_B4, 1, "\xB4");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_B5, 1, "\xB5");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_B6, 1, "\xB6");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_B7, 1, "\xB7");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_B8, 1, "\xB8");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_B9, 1, "\xB9");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_BA, 1, "\xBA");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_BB, 1, "\xBB");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_BC, 1, "\xBC");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_BD, 1, "\xBD");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_BE, 1, "\xBE");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_BF, 1, "\xBF");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_C0, 1, "\xC0");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_C1, 1, "\xC1");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_C2, 1, "\xC2");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_C3, 1, "\xC3");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_C4, 1, "\xC4");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_C5, 1, "\xC5");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_C6, 1, "\xC6");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_C7, 1, "\xC7");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_C8, 1, "\xC8");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_C9, 1, "\xC9");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_CA, 1, "\xCA");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_CB, 1, "\xCB");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_CC, 1, "\xCC");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_CD, 1, "\xCD");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_CE, 1, "\xCE");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_CF, 1, "\xCF");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_D0, 1, "\xD0");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_D1, 1, "\xD1");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_D2, 1, "\xD2");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_D3, 1, "\xD3");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_D4, 1, "\xD4");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_D5, 1, "\xD5");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_D6, 1, "\xD6");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_D7, 1, "\xD7");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_D8, 1, "\xD8");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_D9, 1, "\xD9");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_DA, 1, "\xDA");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_DB, 1, "\xDB");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_DC, 1, "\xDC");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_DD, 1, "\xDD");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_DE, 1, "\xDE");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_DF, 1, "\xDF");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_E0, 1, "\xE0");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_E1, 1, "\xE1");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_E2, 1, "\xE2");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_E3, 1, "\xE3");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_E4, 1, "\xE4");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_E5, 1, "\xE5");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_E6, 1, "\xE6");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_E7, 1, "\xE7");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_E8, 1, "\xE8");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_E9, 1, "\xE9");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_EA, 1, "\xEA");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_EB, 1, "\xEB");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_EC, 1, "\xEC");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_ED, 1, "\xED");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_EE, 1, "\xEE");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_EF, 1, "\xEF");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_F0, 1, "\xF0");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_F1, 1, "\xF1");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_F2, 1, "\xF2");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_F3, 1, "\xF3");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_F4, 1, "\xF4");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_F5, 1, "\xF5");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_F6, 1, "\xF6");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_F7, 1, "\xF7");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_F8, 1, "\xF8");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_F9, 1, "\xF9");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_FA, 1, "\xFA");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_FB, 1, "\xFB");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_FC, 1, "\xFC");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_FD, 1, "\xFD");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_FE, 1, "\xFE");
static MMC_DEFSTRINGLIT(OMC_STRINGLIT_1_FF, 1, "\xFF");
void* mmc_strings_len1[256] = {
NULL,
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_01),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_02),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_03),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_04),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_05),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_06),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_07),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_08),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_09),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_0A),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_0B),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_0C),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_0D),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_0E),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_0F),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_10),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_11),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_12),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_13),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_14),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_15),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_16),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_17),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_18),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_19),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_1A),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_1B),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_1C),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_1D),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_1E),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_1F),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_20),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_21),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_22),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_23),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_24),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_25),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_26),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_27),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_28),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_29),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_2A),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_2B),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_2C),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_2D),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_2E),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_2F),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_30),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_31),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_32),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_33),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_34),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_35),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_36),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_37),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_38),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_39),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_3A),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_3B),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_3C),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_3D),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_3E),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_3F),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_40),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_41),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_42),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_43),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_44),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_45),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_46),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_47),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_48),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_49),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_4A),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_4B),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_4C),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_4D),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_4E),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_4F),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_50),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_51),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_52),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_53),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_54),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_55),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_56),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_57),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_58),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_59),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_5A),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_5B),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_5C),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_5D),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_5E),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_5F),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_60),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_61),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_62),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_63),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_64),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_65),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_66),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_67),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_68),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_69),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_6A),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_6B),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_6C),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_6D),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_6E),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_6F),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_70),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_71),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_72),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_73),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_74),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_75),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_76),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_77),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_78),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_79),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_7A),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_7B),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_7C),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_7D),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_7E),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_7F),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_80),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_81),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_82),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_83),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_84),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_85),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_86),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_87),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_88),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_89),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_8A),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_8B),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_8C),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_8D),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_8E),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_8F),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_90),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_91),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_92),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_93),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_94),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_95),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_96),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_97),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_98),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_99),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_9A),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_9B),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_9C),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_9D),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_9E),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_9F),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_A0),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_A1),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_A2),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_A3),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_A4),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_A5),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_A6),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_A7),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_A8),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_A9),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_AA),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_AB),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_AC),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_AD),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_AE),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_AF),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_B0),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_B1),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_B2),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_B3),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_B4),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_B5),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_B6),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_B7),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_B8),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_B9),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_BA),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_BB),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_BC),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_BD),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_BE),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_BF),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_C0),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_C1),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_C2),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_C3),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_C4),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_C5),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_C6),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_C7),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_C8),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_C9),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_CA),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_CB),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_CC),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_CD),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_CE),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_CF),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_D0),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_D1),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_D2),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_D3),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_D4),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_D5),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_D6),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_D7),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_D8),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_D9),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_DA),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_DB),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_DC),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_DD),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_DE),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_DF),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_E0),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_E1),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_E2),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_E3),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_E4),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_E5),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_E6),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_E7),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_E8),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_E9),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_EA),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_EB),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_EC),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_ED),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_EE),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_EF),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_F0),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_F1),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_F2),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_F3),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_F4),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_F5),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_F6),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_F7),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_F8),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_F9),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_FA),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_FB),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_FC),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_FD),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_FE),
MMC_REFSTRINGLIT(OMC_STRINGLIT_1_FF),
};

static inline void real_set_(real_array_t *a, size_t i, modelica_real r) {
  (reinterpret_cast<modelica_real *> (a->data))[i] = r;
}

static inline modelica_string *string_ptrget(const string_array_t *a, size_t i) {
  return (reinterpret_cast<modelica_string *> (a->data)) + i;
}

static inline void string_set(string_array_t *a, size_t i, modelica_string r) {
  (reinterpret_cast<modelica_string *> (a->data))[i] = r;
}

static modelica_string string_get(const string_array_t a, size_t i) {
  return (reinterpret_cast<modelica_string *> (a.data))[i];
}

static inline size_t base_array_nr_of_elements(const base_array_t a) {
  size_t nr_of_elements = 1;
  for (int i = 0; i < a.ndims; ++i) {
    nr_of_elements *= a.dim_size[i];
  }
  return nr_of_elements;
}

const char** data_of_string_c89_array(const string_array_t *a) {
  size_t sz = base_array_nr_of_elements(*a);
  const char **res = new const char*[sz]();
  for (unsigned int i=0; i< sz; ++i) {
    res[i] = (reinterpret_cast<modelica_string *> (a->data))[i];
  }
  return res;
}

void* mmc_mk_scon(const char *s) {
    size_t nbytes = strlen(s);
    size_t header = MMC_STRINGHDR(nbytes);
    size_t nwords = MMC_HDRSLOTS(header) + 1;
    struct mmc_string *p;
    void *res;
    if (nbytes == 0) return mmc_emptystring;
    if (nbytes == 1) {
      unsigned char c = *s;
      return mmc_strings_len1[(unsigned int)c];
    }
    p = (struct mmc_string *) malloc(nwords*sizeof(void*));
    p->header = header;
    memcpy(p->data, s, nbytes+1);  /* including terminating '\0' */
    res = MMC_TAGPTR(p->data);
    return res;
}

void put_real_element(modelica_real value, int i1, real_array_t *dest) {
  /* Assert that dest has correct dimension */
  /* Assert that i1 is a valid index */
  real_set_(dest, i1, value);
}

void simple_alloc_1d_real_array(real_array_t* dest, int n) {
  simple_alloc_1d_base_array(dest, n, new modelica_real[n]());
}

void array_alloc_scalar_string_array(string_array_t* dest, int n, modelica_string first, ...) {
  va_list ap;
  simple_alloc_1d_string_array(dest, n);
  va_start(ap, first);
  put_string_element(first, 0, dest);
  for (int i = 1; i < n; ++i) {
    put_string_element(va_arg(ap, modelica_string), i, dest);
  }
  va_end(ap);
}

void simple_alloc_1d_string_array(string_array_t* dest, int n) {
  simple_alloc_1d_base_array(dest, n, new m_string[n]());
}


void put_string_element(modelica_string value, int i1, string_array_t *dest) {
  /* Assert that dest has correct dimension */
  /* Assert that i1 is a valid index */
  string_set(dest, i1, value);
}

void array_alloc_string_array(string_array_t* dest, int n, string_array_t first, ...) {
  va_list ap;

  string_array_t *elts = reinterpret_cast<string_array_t*>(malloc(sizeof(string_array_t) * n));
  assert(elts);
  /* collect all array ptrs to simplify traversal.*/
  va_start(ap, first);
  elts[0] = first;
  for (int i = 1; i < n; ++i) {
    elts[i] = va_arg(ap, string_array_t);
  }
  va_end(ap);

  check_base_array_dim_sizes(elts, n);

  if (first.ndims == 1) {
    alloc_string_array(dest, 2, n, first.dim_size[0]);
  } else if (first.ndims == 2) {
    alloc_string_array(dest, 3, n, first.dim_size[0], first.dim_size[1]);
  } else if (first.ndims == 3) {
    alloc_string_array(dest, 4, n, first.dim_size[0], first.dim_size[1], first.dim_size[2]);
  } else if (first.ndims == 4) {
    alloc_string_array(dest, 5, n, first.dim_size[0], first.dim_size[1], first.dim_size[2], first.dim_size[3]);
  } else {
    assert(0 && "Dimension size > 4 not impl. yet");
  }

  int c = 0;
  for (int i = 0; i < n; ++i) {
    int m = base_array_nr_of_elements(elts[i]);
    for (int j = 0; j < m; ++j) {
      string_set(dest, c, string_get(elts[i], j));
      ++c;
    }
  }
  free(elts);
}

void alloc_string_array(string_array_t *dest, int ndims, ...) {
  size_t elements = 0;
  va_list ap;
  va_start(ap, ndims);
  elements = alloc_base_array(dest, ndims, ap);
  va_end(ap);
  dest->data = new m_string[elements]();
}

void check_base_array_dim_sizes(const base_array_t *elts, int n) {
  int ndims = elts[0].ndims;
  for (int i = 1; i < n; ++i) {
    assert(elts[i].ndims == ndims && "Not same number of dimensions");
  }
  for (int curdim = 0; curdim < ndims; ++curdim) {
    int dimsize = elts[0].dim_size[curdim];
    for (int i = 1; i < n; ++i) {
      assert(dimsize == elts[i].dim_size[curdim]
                                         && "Dimensions size not same");
    }
  }
}

void simple_alloc_1d_base_array(base_array_t *dest, int n, void *data) {
  dest->ndims = 1;
  dest->dim_size = new _index_t[1]();
  dest->dim_size[0] = n;
  dest->data = data;
}


void alloc_real_array(real_array_t *dest, int ndims, ...) {
  va_list ap;
  va_start(ap, ndims);
  size_t elements = alloc_base_array(dest, ndims, ap);
  va_end(ap);
  dest->data = new modelica_real[elements]();
}

size_t alloc_base_array(base_array_t *dest, int ndims, va_list ap) {
  size_t nr_of_elements = 1;

  dest->ndims = ndims;
  dest->dim_size = new _index_t[ndims]();

  for (int i = 0; i < ndims; ++i) {
    dest->dim_size[i] = va_arg(ap, _index_t);
    nr_of_elements *= dest->dim_size[i];
  }

  return nr_of_elements;
}

void copy_real_array_data_mem(const real_array_t source, modelica_real *dest) {
  size_t nr_of_elements = base_array_nr_of_elements(source);

  for (size_t i = 0; i < nr_of_elements; ++i) {
    dest[i] = real_get(source, i);
  }
}

void array_alloc_scalar_real_array(real_array_t* dest, int n, modelica_real first, ...) {
  va_list ap;
  simple_alloc_1d_real_array(dest, n);
  va_start(ap, first);
  put_real_element(first, 0, dest);
  for (int i = 1; i < n; ++i) {
    put_real_element(va_arg(ap, modelica_real), i, dest);
  }
  va_end(ap);
}

static inline void* generic_ptrget(const base_array_t *a, size_t sze, size_t i) {
  return (reinterpret_cast<char*>(a->data)) + (i*sze);
}

size_t calc_base_index_va(const base_array_t *source, int ndims, va_list ap) {
  int i;
  size_t index;

  index = 0;
  for (i = 0; i < ndims; ++i) {
    int sub_i = va_arg(ap, _index_t) - 1;
    if (sub_i < 0 || sub_i >= source->dim_size[i]) {
      assert(0 && "Dimension overflow");
    }
    index = (index * source->dim_size[i]) + sub_i;
  }

  return index;
}

void* generic_array_element_addr(const base_array_t* source, size_t sze, int ndims, ...) {
  va_list ap;
  void* tmp;
  va_start(ap, ndims);
  tmp = generic_ptrget(source, calc_base_index_va(source, ndims, ap), sze);
  va_end(ap);
  return tmp;
}

void pack_integer_array(integer_array_t *a) {
  if (sizeof(int) != sizeof(modelica_integer)) {
    int * int_data = reinterpret_cast<int*>(a->data);
    size_t n = base_array_nr_of_elements(*a);

    for (size_t i = 0; i < n; ++i) {
      int_data[i] = static_cast<int>(integer_get(*a, i));
    }
  }
}

void put_real_matrix_element(modelica_real value, int r, int c, real_array_t* dest) {
    /* Assert that dest hast correct dimension */
    /* Assert that r and c are valid indices */
    real_set(dest, (r * dest->dim_size[1]) + c, value);
    /* printf("Index %d\n",r*dest->dim_size[1]+c); */
}

void array_alloc_scalar_integer_array(integer_array_t* dest, int n,
                                      modelica_integer first, ...) {
    int i;
    va_list ap;
    simple_alloc_1d_integer_array(dest, n);
    va_start(ap, first);
    put_integer_element(first, 0, dest);
    for (i = 1; i < n; ++i) {
        put_integer_element(va_arg(ap, m_integer), i, dest);
    }
    va_end(ap);
}

void simple_alloc_1d_integer_array(integer_array_t* dest, int n) {
    simple_alloc_1d_base_array(dest, n, integer_alloc(n));
}

void put_integer_element(modelica_integer value, int i1, integer_array_t* dest) {
    /* Assert that dest has correct dimension */
    /* Assert that i1 is a valid index */
    integer_set(dest, i1, value);
}

#ifdef __clang__
#pragma clang diagnostic pop
# endif  // __clang__
