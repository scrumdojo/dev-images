if [ -n "${GIT_USER_NAME}" ] && [ -n "${GIT_USER_EMAIL}" ]; then
    echo "Configuring git user ${GIT_USER_NAME} <${GIT_USER_EMAIL}>"
    git config --global user.name "${GIT_USER_NAME}"
    git config --global user.email "${GIT_USER_EMAIL}"
else
    echo "Set GIT_USER_NAME and GIT_USER_EMAIL to configure git user"
fi

if [ -n "${GITHUB_TOKEN}" ]; then
    gh auth login --with-token <<< "${GITHUB_TOKEN}"
    gh auth setup-git
fi
