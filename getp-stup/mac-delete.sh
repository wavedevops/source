#!/bin/bash

# Define color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to remove the gitp alias from a shell config file
remove_alias_from_shell() {
    local shell_rc=$1

    # Check if the shell config file exists
    if [ -f $shell_rc ]; then
        # Remove the gitp alias if it exists
        if grep -q "alias gitp='source ~/.customCommands/gitp.sh'" $shell_rc; then
            sed -i '' '/alias gitp=.source ~\/.customCommands\/gitp.sh./d' $shell_rc
            echo -e "${GREEN}Alias gitp removed from ${shell_rc}.${NC}"
        else
            echo -e "${YELLOW}Alias gitp not found in ${shell_rc}. Skipping...${NC}"
        fi

        # Reload the shell configuration
        source $shell_rc
        echo -e "${GREEN}Reloaded ${shell_rc}.${NC}"
    else
        echo -e "${YELLOW}${shell_rc} not found. Skipping...${NC}"
    fi
}

# Remove alias from both .bashrc and .zshrc
remove_alias_from_shell ~/.bashrc
remove_alias_from_shell ~/.zshrc

# Remove the gitp.sh script and the ~/.customCommands directory
if [ -f ~/.customCommands/gitp.sh ]; then
    rm ~/.customCommands/gitp.sh
    echo -e "${GREEN}Script ~/.customCommands/gitp.sh removed.${NC}"
else
    echo -e "${YELLOW}Script ~/.customCommands/gitp.sh not found. Skipping...${NC}"
fi

if [ -d ~/.customCommands ]; then
    rm -rf ~/.customCommands
    echo -e "${GREEN}Directory ~/.customCommands removed.${NC}"
else
    echo -e "${YELLOW}Directory ~/.customCommands not found. Skipping...${NC}"
fi

echo -e "${GREEN}Removal complete! The 'gitp' setup has been fully removed.${NC}"
