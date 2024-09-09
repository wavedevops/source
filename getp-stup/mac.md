Now, you can use the `gitp` command to automatically add, commit, and push changes to your repository with an incremented commit message on macOS.

Here's the updated step-by-step guide that includes both `.bashrc` and `.zshrc` instructions for setting up the `gitp` command:

---

### Setting Up the `gitp` Command

1. **Create the directory for your custom commands:**
   ```bash
   mkdir -p ~/.customCommands
   ```

2. **Create the `gitp.sh` script using Vim:**
   ```bash
   vim ~/.customCommands/gitp.sh
   ```

3. **In Vim, add the following script:***

   ```bash
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
   ```

4. **Save and exit Vim by typing `:wq`.**

5. **Make the script executable:**
   ```bash
   chmod +x ~/.customCommands/gitp.sh
   ```

6. **Add the alias to your `.bashrc` file:**
   ```bash
   vim ~/.bashrc
   ```

   - Scroll to the end of the file and add:
     ```bash
     alias gitp='source ~/.customCommands/gitp.sh'
     ```

7. **Save and exit Vim by typing `:wq`.**

8. **Reload your `.bashrc` to apply the changes:**
   ```bash
   source ~/.bashrc
   ```

### Additional Steps for Zsh Users

If you're using Zsh instead of Bash, you'll need to add the alias to your `.zshrc` file as well:

1. **Open your `.zshrc` file in Vim:**
   ```bash
   vim ~/.zshrc
   ```

2. **Add the alias to the end of the file:**
   ```bash
   alias gitp='source ~/.customCommands/gitp.sh'
   ```

3. **Save and exit Vim by typing `:wq`.**

4. **Reload your `.zshrc` to apply the changes:**
   ```bash
   source ~/.zshrc
   ```

---

After completing these steps, the `gitp` command should work in both Bash and Zsh. If you're using Zsh, make sure to perform the additional steps for the `.zshrc` file.
