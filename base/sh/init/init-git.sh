git config --global user.name "${GIT_USER_NAME}"
git config --global user.email "${GIT_USER_EMAIL}"

gh auth login --with-token <<< "${GITHUB_TOKEN}"
gh auth setup-git
