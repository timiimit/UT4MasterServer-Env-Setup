#!/bin/sh

echo "Installing ut4ms command..."

# install UT4MasterServer-Env into $ROOT_DIR_ENV
mkdir -p "$ROOT_DIR_ENV"
git -C "$ROOT_DIR_ENV" clone "$REPO_URL_ENV" .

# install a command for executing ut4ms
cat >/usr/local/bin/ut4ms << "EOF"
#!/bin/bash
"$ROOT_DIR_ENV/ut4ms.sh" "$@"
EOF
chmod +x /usr/local/bin/ut4ms
