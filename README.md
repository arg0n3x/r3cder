## r3cder

### Description

Overwrites and deletes all files within a directory, making recovery nearly impossible, as it uses the `shred` command, \
which is designed to overwrite any type of file.

### Dependences

`shred` command

### Use mode

* Give permissions of execute to script

```bash
 chmod u+x r3cder.sh
```

* For more information about the script, use the parameter `-h`

```bash
 ./r3cder.sh -h
```

* Use example

```bash
 ./r3cder.sh -p <path directory> [-o <number of overwrites>]
```
