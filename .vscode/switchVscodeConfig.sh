#!/bin/bash

if `grep "${workspaceFolder}/dynawo/3rdParty" .vscode/settings.json | grep "//" 2>&1 > /dev/null`; then
  sed -i '/"cmake.sourceDirectory": "${workspaceFolder}\/dynawo\/3rdParty/s/\/\///' .vscode/settings.json
  sed -i '/"cmake.buildDirectory": "${workspaceFolder}\/build-code\/build\/3rdParty/s/\/\///' .vscode/settings.json
  sed -i '/"CMAKE_INSTALL_PREFIX": "${workspaceFolder}\/build-code\/install\/3rdParty/s/\/\///' .vscode/settings.json

  sed -i '/${workspaceFolder}\/dynawo"/s/^/\/\//' .vscode/settings.json
  sed -i '/build-code\/build\/dynawo/s/^/\/\//' .vscode/settings.json
  sed -i '/build-code\/install\/dynawo/s/^/\/\//' .vscode/settings.json
else
  sed -i '/"cmake.sourceDirectory": "${workspaceFolder}\/dynawo\/3rdParty/s/ "cmake.sourceDirectory"/\/\/ "cmake.sourceDirectory"/' .vscode/settings.json
  sed -i '/"cmake.buildDirectory": "${workspaceFolder}\/build-code\/build\/3rdParty/s/ "cmake.buildDirectory"/\/\/ "cmake.buildDirectory"/' .vscode/settings.json
  sed -i '/"CMAKE_INSTALL_PREFIX": "${workspaceFolder}\/build-code\/install\/3rdParty/s/ "CMAKE_INSTALL_PREFIX"/\/\/ "CMAKE_INSTALL_PREFIX"/' .vscode/settings.json

  sed -i '/${workspaceFolder}\/dynawo"/s/\/\///' .vscode/settings.json
  sed -i '/build-code\/build\/dynawo/s/\/\///' .vscode/settings.json
  sed -i '/build-code\/install\/dynawo/s/\/\///' .vscode/settings.json
fi
