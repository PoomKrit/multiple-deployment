#!/bin/bash
set -e
source config.sh
[ ! -d ~/gitlab/deploy/$branch_target ] && mkdir -p ~/gitlab/deploy/$branch_target
ssh-add -K .key/gitlab-runner-tf.pem
branch_merge=$branch_merge/$(tr -dc A-Za-z0-9 </dev/urandom | head -c 13 ; echo '')

echo "Get info from branch "$branch_source""
echo "Merging to branch "$branch_target""

for repo in $(cat repo.txt|xargs)
do
    # repo=$(echo $i | sed -e 's|https://||g' -e 's|/cloud_arv|:cloud_arv|g' -e 's/gitlab.com/git@gitlab.com/g' -e 's/$/.git/g')
    app=$(echo $repo|awk -F'/' '{print $(NF -0)}'|awk -F\. '{print $1}')

    rm -rf ~/gitlab/deploy/$branch_target/*
    cd ~/gitlab/deploy/$branch_target/
    git clone $repo
    cd $app
    git checkout -f $branch_source
    git pull
    git checkout -b $branch_merge

    echo ""
    echo "----------------------------"
    echo "Merging "$app" to "$branch_target" env....."
    git push -o merge_request.create \
    -o merge_request.target=$branch_target \
    -o merge_request.title="promote to "$branch_target" - "$(tr -dc A-Za-z0-9 </dev/urandom | head -c 13 ; echo '')" " \
    -o merge_request.merge_when_pipeline_succeeds \
    -o merge_request.remove_source_branch \
    origin $branch_merge
done
rm -rf ~/gitlab/deploy/$branch_target/*
