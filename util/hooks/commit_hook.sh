#!/bin/bash

BRANCH_NAME=$(git branch | grep '*' | sed 's/* //')

if [ $BRANCH_NAME != '(no branch)' -a -z "$(git status | grep "You are currently cherry-picking")" ]; then
  branch_name=$(git symbolic-ref HEAD | awk -F'/' '{print $(NF)}')
  if [ ! -z "$(echo "$branch_name" | grep -E "^[0-9]+_[^_]*")" ]; then
    ticket_num=$(echo $branch_name | cut -d '_' -f 1)
    if [[ "$(cat $1)" = \#* ]]; then
      hashtag_message=$(cat $1 | grep -Eo "^#[0-9]+ ")
      if [ ! -z "$hashtag_message" ]; then
        num_in_message=$(echo "$hashtag_message" | grep -Eo "[0-9]+")
        if [[ $num_in_message != $ticket_num ]]; then
          echo "[WARNING] The ticket number given (namely $num_in_message) is not the same as the one suggested by the branch name (namely $ticket_num))."
        fi
      else
        echo "[POLICY] Either your commit message should start with # followed by the ticket number AND a space, or by something entirely different (in which case the ticket number is added automatically). You can't start with a # followed by anything else than the ticket number."
        exit 1
      fi
    else
      (echo -n "#$ticket_num "; cat $1) >> $1.tmp
      mv $1.tmp $1
    fi
  else
    echo "[POLICY] Invalid branch name: branch should be a number followed by a '_' and then whatever you wish."
    exit 1
  fi
fi
