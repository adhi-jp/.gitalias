#!/bin/bash
REPO_URL="https://github.com/adhi-jp/.gitalias.git"
TARGET_DIR="${HOME}/.config/git/.gitalias"

# Prompt user to start installation
read -p "Do you want to start the installation? (y/n): " choice
if [[ "$choice" != "y" && "$choice" != "Y" ]]; then
  echo "Installation cancelled."
  exit 0
fi

# Create the parent directory of the working directory
mkdir -p "$(dirname "${TARGET_DIR}")"

# Check if git is installed
if ! command -v git > /dev/null 2>&1; then
  echo "Error: git is not installed."
  exit 1
fi

# If the repository already exists, update it; otherwise, clone it
if [ -d "${TARGET_DIR}/.git" ]; then
  echo "Updating the existing repository..."
  cd "${TARGET_DIR}" && git pull
else
  echo "Cloning the repository..."
  git clone "${REPO_URL}" "${TARGET_DIR}"
fi

# Add include.path to git global config if not already set
if ! git config --global --get-all include.path | grep -q "${TARGET_DIR}/.gitconfig"; then
  echo "Adding include.path to git global config..."
  git config --global --add include.path "${TARGET_DIR}/.gitconfig"
fi

echo "Installation completed successfully."
# Wait for user input before exiting
read -p "Press Enter to exit."