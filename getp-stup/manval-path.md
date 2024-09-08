Great, since Homebrew is located at `/usr/local/bin/brew`, you should update your `.zshrc` file to reflect this path.

### Update `.zshrc`:

1. **Open `.zshrc`**:
    - Open your `.zshrc` file in your preferred text editor:

      ```bash
      vim ~/.zshrc
      ```

2. **Update the Brew Path**:
    - Locate the line that references `/opt/homebrew/bin/brew` and update it to `/usr/local/bin/brew`. It should look like this:

      ```bash
      eval "$(/usr/local/bin/brew shellenv)"
      ```

    - If you don’t see this line but find something similar that references the old path, update that line accordingly.

3. **Save and Exit**:
    - Save the changes and exit the editor (`:wq` in Vim).

4. **Reload `.zshrc`**:
    - Apply the changes by reloading `.zshrc`:

      ```bash
      source ~/.zshrc
      ```

This should resolve the error related to the missing Homebrew path. After updating `.zshrc`, you should be able to use the `gitp` command without issues.