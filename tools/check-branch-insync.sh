#!/bin/bash
#set -e


pending_changes=`git status -s`
pending_commits= `git --no-pager log  --not --remotes --decorate=short --pretty=oneline -n1`


echo  $pending_changes
echo  $pending_commits



if [ "$pending_changes-$pending_commits" = "-" ]; then
  echo -e "\xE2\x9C\x94" "- Your local branch is in sync with the remote repository"
else 
  echo -e "\xE2\x9D\x8C" "- Your local branch is not in sync with the remote repository"
fi
