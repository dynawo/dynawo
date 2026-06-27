#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# Phase-1 standalone reproduction of the Sinusoidal Predictor Method (IDASPM)
# on SUNDIALS 6.3.0.  No Dynawo required.
#
# It:
#   1. downloads + verifies SUNDIALS 6.3.0 (same tarball/MD5 as 3rdParty)
#   2. drops in the SPM module (ida_spm.{c,h,_impl.h}) and applies the SPM
#      patch to ida.c / ida_impl.h / CMakeLists.txt
#   3. builds a minimal SUNDIALS (IDA + dense, KLU not needed here)
#   4. builds and runs the baseline (plain IDA) and SPM harnesses
#
# Usage:  ./build_and_run.sh [workdir]
# -----------------------------------------------------------------------------
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
WORK="${1:-$HERE/build}"
VER=6.3.0
MD5=6be7057c88990021de5b08109eb2f133
URL=https://github.com/LLNL/sundials/releases/download/v${VER}/sundials-${VER}.tar.gz

mkdir -p "$WORK"; cd "$WORK"

if [ ! -f sundials-${VER}.tar.gz ]; then
  echo ">> downloading SUNDIALS ${VER}"
  curl -sSL -o sundials-${VER}.tar.gz "$URL"
fi
echo "${MD5}  sundials-${VER}.tar.gz" | md5sum -c -

rm -rf sundials-${VER} install
tar xzf sundials-${VER}.tar.gz

echo ">> applying SPM module + patch"
cp "$HERE"/ida_spm.h                       sundials-${VER}/include/ida/   # public API
cp "$HERE"/ida_spm.c "$HERE"/ida_spm_impl.h sundials-${VER}/src/ida/       # implementation
( cd sundials-${VER} && patch -p1 < "$HERE/sundials-${VER}-spm.patch" )

echo ">> configuring + building SUNDIALS (IDA + dense)"
cmake -S sundials-${VER} -B sundials-build \
  -DCMAKE_INSTALL_PREFIX="$WORK/install" -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBS=ON -DBUILD_STATIC_LIBS=OFF \
  -DEXAMPLES_INSTALL=OFF -DEXAMPLES_ENABLE_C=OFF \
  -DBUILD_CVODE=OFF -DBUILD_CVODES=OFF -DBUILD_ARKODE=OFF \
  -DBUILD_IDAS=OFF -DBUILD_KINSOL=OFF -DBUILD_IDA=ON -DENABLE_KLU=OFF >/dev/null
cmake --build sundials-build --target install -j"$(nproc)" >/dev/null
echo "   SUNDIALS installed at $WORK/install"

INC="$WORK/install/include"
SRCIDA="$WORK/sundials-${VER}/src/ida"
LIB="$WORK/install/lib"
COMMON="-O2 -I$INC -I$SRCIDA -L$LIB -Wl,-rpath,$LIB \
  -lsundials_ida -lsundials_nvecserial -lsundials_sunmatrixdense \
  -lsundials_sunmatrixsparse -lsundials_sunlinsoldense -lsundials_generic -lm"

echo ">> building harnesses"
# shellcheck disable=SC2086
gcc "$HERE/baseline.c" -o baseline $COMMON
# shellcheck disable=SC2086
gcc "$HERE/spm.c"      -o spm      $COMMON
# shellcheck disable=SC2086
gcc "$HERE/spm2d.c"    -o spm2d    $COMMON

echo; echo "===== 1x1 oscillating (steady state) ====="
./baseline 1e-4 2.0 1 0
./spm      1e-4 2.0 1 0
echo; echo "===== 2x2 NON-SYMMETRIC (validates CSR Jacobian orientation) ====="
./spm2d 1e-4 2.0 0    # plain IDA
./spm2d 1e-4 2.0 1    # IDASPM
