# r3cder

This is a Bash script designed to recursively overwrite all contents within a specified directory.
Once the overwriting process begins, recovering the files will be extremely challenging. The script utilizes
the `shred` command to ensure irreversible overwriting of the files.

## How to use it

1. Clone the repository

```bash
 $ git clone https://github.com/arg0n3x/r3cder.git
```

2. Grant execution permissions to the script

```bash
 $ chmod 700 r3cder
```

3. A basic usage of the script

```bash
 $ ./r3cder -d <directory path> -o <overwrite count>
```

4. Use the `-h` parameter for additional help

```bash
 $ ./r3cder -h
```

**NOTE**

This script recursively overwrites the directory and its subdirectories, making file recovery extremely challenging.

---
