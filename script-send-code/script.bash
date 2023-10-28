#!/bin/bash
rm -rf /$2
rm -rf /SRC-REPO

# Clone receiving repository
git clone https://$4@$3 /$2 

# Clone source repository
git clone https://$1@$5 /SRC-REPO

# Get list of branches in source repository
branches=$(cd /SRC-REPO && git branch --format='%(refname:short)')

# Iterate over branches
for src_branch in $branches; do
  # Sync files from source repository to local folder
  rsync -av --progress --delete /SRC-REPO/ /$2 --exclude .git --exclude "exclude files"

  # Change directory to local folder
  cd /$2

  # Create and switch to send-code branch
  git checkout -b send-code

  # Add all changes to the index
  git add --all

  git config user.email "you email"
  git config user.name "you username"

  # Commit changes with a message
  git commit -m "send-code"

  # Push changes to the receiving repository on send-code branch
  git push https://$4@$3 send-code

  # Switch back to $BRANCH branch
  git checkout $6

  # Merge send-code branch into $BRANCH branch
  git merge --no-ff -m "Merge branch 'send-code' into '$BRANCH'" send-code

  # Push changes to the receiving repository on $BRANCH branch
  git push https://$4@$3 $6

  # Delete send-code branch from the receiving repository
  git push https://$4@$3 --delete send-code

  # Switch back to the source branch
  cd /SRC-REPO
  git checkout $src_branch
done

