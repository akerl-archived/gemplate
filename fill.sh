#!/usr/bin/env bash

echo -n "Please enter your username: (${USER}) "
read author_name
[[ -z "${author_name}" ]] && author_name="${USER}"

echo -n "Please enter your full name: ($(git config user.name)) "
read license_name
[[ -z "${license_name}" ]] && license_name="$(git config user.name)"

echo -n "Please enter the repo name: (${PWD##*/}) "
read repo_name
[[ -z "${repo_name}" ]] && repo_name="${PWD##*/}"

echo -n "Please enter your email address: ($(git config user.email)) "
read email_address
[[ -z "${email_address}" ]] && email_address="$(git config user.email)"

sed -i '' "s/AUTHOR_NAME/${author_name}/g" README.md REPO_NAME.gemspec
sed -i '' "s/LICENSE_NAME/${license_name}/g" LICENSE REPO_NAME.gemspec
sed -i '' "s/REPO_NAME/${repo_name}/g" README.md spec/spec_helper.rb REPO_NAME.gemspec
sed -i '' "s/EMAIL_ADDRESS/${email_address}/g" REPO_NAME.gemspec

mv REPO_NAME.gemspec ${repo_name}.gemspec
mv lib/REPO_NAME.rb lib/${repo_name}.rb
mv spec/REPO_NAME_spec.rb spec/${repo_name}_spec.rb

rm -rf .git

git init
git remote add origin "git@github.com:${author_name}/${repo_name}"

rm fill.sh

