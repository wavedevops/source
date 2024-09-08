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

# Check if the alias is already in ~/.bashrc
if ! grep -q "alias gitp='source ~/.customCommands/gitp.sh'" ~/.bashrc; then
    echo "alias gitp='source ~/.customCommands/gitp.sh'" >> ~/.bashrc
    echo -e "${GREEN}Alias gitp added to ~/.bashrc.${NC}"
else
    echo -e "${YELLOW}Alias gitp already exists in ~/.bashrc. Skipping...${NC}"
fi

# Reload ~/.bashrc
source ~/.bashrc
echo -e "${GREEN}Reloaded ~/.bashrc.${NC}"

