#!/bin/bash

# Define color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if the ~/.customCommands directory exists
if [ ! -d ~/.customCommands ]; then
    mkdir -p ~/.customCommands
    echo -e "${GREEN}Directory ~/.customCommands created.${NC}"
else
    echo -e "${YELLOW}Directory ~/.customCommands already exists. Skipping...${NC}"
fi

# Check if the gitp.sh script exists
if [ ! -f ~/.customCommands/gitp.sh ]; then
    cat << 'EOF' > ~/.customCommands/gitp.sh
#!/bin/bash

FILE=~/.count

git_push () {
      variableCount=$(cat ~/.count)
      git add .
      echo $(($(cat ~/.count) + 1)) > ~/.count
      git commit -m "automated commit #$variableCount"
      git push
}

if [ -f $FILE ]; then
  git_push
else
  echo "0" > ~/.count
  git_push
fi
EOF
    chmod +x ~/.customCommands/gitp.sh
    echo -e "${GREEN}Script ~/.customCommands/gitp.sh created and made executable.${NC}"
else
    echo -e "${YELLOW}Script ~/.customCommands/gitp.sh already exists. Skipping...${NC}"
fi

# Function to add alias to a shell config file
add_alias_to_shell() {
    local shell_rc=$1

    # Check if the shell config file exists, create it if not
    if [ ! -f $shell_rc ]; then
        touch $shell_rc
        echo -e "${YELLOW}${shell_rc} not found. Created new ${shell_rc} file.${NC}"
    fi

    # Add the gitp alias if it doesn't already exist
    if ! grep -q "alias gitp='source ~/.customCommands/gitp.sh'" $shell_rc; then
        echo "alias gitp='source ~/.customCommands/gitp.sh'" >> $shell_rc
        echo -e "${GREEN}Alias gitp added to ${shell_rc}.${NC}"
    else
        echo -e "${YELLOW}Alias gitp already exists in ${shell_rc}. Skipping...${NC}"
    fi

    # Reload the shell configuration
    source $shell_rc
    echo -e "${GREEN}Reloaded ${shell_rc}.${NC}"
}

# Add alias to both .bashrc and .zshrc
add_alias_to_shell ~/.bashrc
add_alias_to_shell ~/.zshrc

echo -e "${GREEN}Setup complete! You can now use the 'gitp' command.${NC}"
