#!/bin/bash
#
# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source time domain
# simulation tool for power systems.
#

usage() {
  echo -e "Usage: `basename $0` ARGUMENT [OPTIONS]\tprogram to deal with Dynawo autocompletion deployment

  where ARGUMENT can be one of the following:
    --deploy                    deploy autocompletion script and add source in your .bashrc (or .zshrc)
    --update-tests              update tests list of Dynawo to complete for an old version of completion script
    --add-command mycommand     add another name of command to autocomplete (ex: dynawo_release)
    --help                      print this message
  where OPTIONS can be:
    --script scriptname.sh      name of the script calling envDynawo.sh (default: myEnvDynawo.sh)
    --shell-type bash           user's shell type (default: bash)
    --permanent-path mypath     allow to deploy Dynawo completion script outside of Dynawo folder (default: DYNAWO_HOME/util/autocompletion/_dynawo).
"
}

if [ -z "$DYNAWO_HOME" ]; then
  echo "You need to export DYNAWO_HOME variable."
  exit 1
fi

deploy() {
  if [ "$USER_SHELL_TYPE" = "bash" ]; then
    cp $DYNAWO_HOME/util/autocompletion/_dynawo_template_$USER_SHELL_TYPE $USER_PERMANENT_PATH/_dynawo
  elif [ "$USER_SHELL_TYPE" = "zsh" ]; then
    (echo "#compdef _dynawo dynawo TO_COMPLETE_DYNAWO_USER_SCRIPT_NAME";cat $DYNAWO_HOME/util/autocompletion/_dynawo_template_$USER_SHELL_TYPE) > $USER_PERMANENT_PATH/_dynawo
  else
    echo "Only available shell type for completion are bash and zsh."
    exit 1
  fi

  sed -i "s#TO_COMPLETE_DYNAWO_USER_SCRIPT_PATH#$DYNAWO_USER_SCRIPT_PATH#" $USER_PERMANENT_PATH/_dynawo
  sed -i "s#TO_COMPLETE_DYNAWO_USER_SCRIPT_NAME#$DYNAWO_USER_SCRIPT_NAME#" $USER_PERMANENT_PATH/_dynawo
  sed -i "s#TO_COMPLETE_DYNAWO_HOME#$DYNAWO_HOME#g" $USER_PERMANENT_PATH/_dynawo

  if [ "$USER_SHELL_TYPE" = "bash" ]; then
    if [ -f "/etc/profile.d/bash_completion.sh" ]; then
      if [ -z "$(grep "\[ -f /etc/profile.d/bash_completion.sh \] && source /etc/profile.d/bash_completion.sh" ~/.bashrc)" ]; then
        echo -e "\n#Added by Dynawo\n[ -f /etc/profile.d/bash_completion.sh ] && source /etc/profile.d/bash_completion.sh" >> ~/.bashrc
      fi
    else
      echo "Warning: Dynawo autocompletion rely on the bash-completion package. Please install it with your package manager (dnf install bash-completion or apt install bash-completion for example) and relaunch your command."
    fi
    if [ -z "$(grep "\[ -f $USER_PERMANENT_PATH/_dynawo \] && source $USER_PERMANENT_PATH/_dynawo" ~/.bashrc)" ]; then
      echo -e "\n#Added by Dynawo\n[ -f $USER_PERMANENT_PATH/_dynawo ] && source $USER_PERMANENT_PATH/_dynawo" >> ~/.bashrc
    fi
    if [ -z "$(grep "alias dynawo=$DYNAWO_USER_SCRIPT_PATH" ~/.bashrc)" ]; then
      echo -e "\n#Added by Dynawo\nalias dynawo=$DYNAWO_USER_SCRIPT_PATH" >> ~/.bashrc
    fi
    echo "Now execute the following command: . ~/.bashrc"
  elif [ "$USER_SHELL_TYPE" = "zsh" ]; then
    if [ -z "$(grep "alias dynawo=$DYNAWO_USER_SCRIPT_PATH" ~/.zshrc)" ]; then
      echo -e "\n#Added by Dynawo\nalias dynawo=$DYNAWO_USER_SCRIPT_PATH" >> ~/.zshrc
    fi
    if [ -z "$(grep "fpath=($USER_PERMANENT_PATH \$fpath)" ~/.zshrc)" ]; then
      echo -e "\n#Added by Dynawo\nfpath=($USER_PERMANENT_PATH \$fpath)" >> ~/.zshrc
    fi
    echo "Now execute the following command: . ~/.zshrc. You may also need to launch: unfunction _dynawo;autoload -U _dynawo;rm -f ~/.zcompdump*;compinit;"
  else
    echo "Only available shell type for completion are bash and zsh."
    exit 1
  fi
}

update_tests() {
  tests_list=($($DYNAWO_USER_SCRIPT_PATH list-tests | grep '\.' | tr -d '.' | tr -d ' '))
  if [ -f "$USER_PERMANENT_PATH/_dynawo" ]; then
    sed -i "s/local build_tests=.*/local build_tests=\"${tests_list[*]}\"/" $USER_PERMANENT_PATH/_dynawo
  else
    echo "$USER_PERMANENT_PATH/_dynawo file is not present to update-tests."
    exit 1
  fi
}

add_command() {
  if [ -f "$USER_PERMANENT_PATH/_dynawo" ]; then
    if [ "$USER_SHELL_TYPE" = "bash" ]; then
      sed -i "s/\(complete -F _dynawo.*\)/\1 $NEW_COMMAND/" $USER_PERMANENT_PATH/_dynawo
    elif [ "$USER_SHELL_TYPE" = "zsh" ]; then
      sed -i "s/\(#compdef _dynawo.*\)/\1 $NEW_COMMAND/" $USER_PERMANENT_PATH/_dynawo
    else
      echo "Only available shell type for completion are bash and zsh."
      exit 1
    fi
  else
    echo "$USER_PERMANENT_PATH/_dynawo file is not present to add-command."
    exit 1
  fi
}

MODE=""
export USER_SHELL_TYPE="bash"
export DYNAWO_USER_SCRIPT_NAME=myEnvDynawo.sh
export USER_PERMANENT_PATH=$DYNAWO_HOME/util/autocompletion

if [ $# -eq 0 ]; then
  echo "$1: invalid option."
  usage
  exit 1
fi

while (($#)); do
  case "$1" in
    --deploy)
      MODE=deploy
      shift
      ;;
    --update-tests)
      MODE=update-tests
      shift
      ;;
    --script)
      export DYNAWO_USER_SCRIPT_NAME=$2
      shift 2
      ;;
    --shell-type)
      if [[ "$2" != "bash" && "$2" != "zsh" ]]; then
        echo "Only available shell type for completion are bash and zsh."
        exit 1
      fi
      export USER_SHELL_TYPE=$2
      shift 2
      ;;
    --permanent-path)
      export USER_PERMANENT_PATH=${2%/}
      if [ ! -d "$USER_PERMANENT_PATH" ]; then
        mkdir -p $USER_PERMANENT_PATH
      fi
      shift 2
      ;;
    --help)
      usage
      exit 0
      ;;
    --add-command)
      MODE=add-command
      export NEW_COMMAND=$2
      shift 2
      ;;
    *)
      echo "$1: invalid option."
      usage
      exit 1
      ;;
  esac
done

if [ ! -x "$(command -v find)" ]; then
  echo "You need to install find command line utility."
  exit 1
fi

if [ ! -f "$(find "$DYNAWO_HOME" -name "$DYNAWO_USER_SCRIPT_NAME")" ]; then
  echo "The specified script $DYNAWO_USER_SCRIPT_NAME was not found in your DYNAWO_HOME ($DYNAWO_HOME)."
  exit 1
else
  export DYNAWO_USER_SCRIPT_PATH=$(find "$DYNAWO_HOME" -name "$DYNAWO_USER_SCRIPT_NAME")
  if [ -z "$(fgrep envDynawo.sh "$DYNAWO_USER_SCRIPT_PATH")" ]; then
    echo "Your script $DYNAWO_USER_SCRIPT_NAME needs to call envDynawo.sh, see Build Dynawo instructions in README for example."
    exit 1
  fi
fi

case $MODE in
  deploy)
    deploy
    ;;
  update-tests)
    update_tests
    ;;
  add-command)
    add_command
    ;;
  *)
    echo
    usage
    ;;
esac
