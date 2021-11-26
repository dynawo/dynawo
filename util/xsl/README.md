## XSL files

Starting from commit c600353edaa664e306293978751239454823d86b we will now provide a way to update XML files.

This directory contains XSL files to be able to follow naming changes in various Dyna&omega;o XML files (.dyd, .par ...).

They will apply on some of Dyna&omega;o files and the naming will be the following: `issueNumber.subNumber.type.xsl`, where:
- **issueNumber** refers to the associated issue on Github,
- **.subNumber** is optional and designates a step in update,
- **type** will be either _jobs_, _dyd_, _par_ or _crv_.

On Linux to apply it you can do:
``` bash
$> xsltproc -o myFile_new.par 267.par.xsl myFile.par
```

`xsltproc` is available in the package `libxslt` on Fedora.

A utility script is provided to automatically apply those XSL on existing projects.
To apply all XSL on all non-regression tests:
``` bash
$> dynawo nrt-xsl
```

By default, environment variable `DYNAWO_NRT_DIR` with subdir `data` is used as main directory where to apply update.
The **-d** or **--directory** option is provided to specify another directory:
``` bash
$> dynawo nrt-xsl --directory <DIRECTORY>
```

The **-t** or **--type** option is provided to specify which types should be updated:
``` bash
$> dynawo nrt-xsl --type <jobs/dyd/par/crv>
```

The **-i** or **--id** option is provided to specify which xsl should be used to update.
The xsl id is the issue number mentioned above.
If you don't specify the subNumber (if exists), all subNumber will be applied in sequence:
``` bash
$> dynawo nrt-xsl --id 958
```

With **-n** or **--name** option, it's also possible to filter by *directory* names the subdirectories on which to apply update:
``` bash
$> dynawo nrt-xsl --name IEEE14
```

The **-p** or **--pattern** option has the same goal as **--name** but with a regular expression filter:
``` bash
$> dynawo nrt-xsl --pattern IEEE..Basic
```

The **-j** or **--jobs** option use a regular expression filter on *filename* to specified simulation project on which to apply update.
Files are scanned from **-d** option and only jobs files are concerned:
``` bash
$> dynawo nrt-xsl -d <DIRECTORY> --jobs <JOBS_PATTERN>
```

The **-f** or **--file** option use a regular expression filter on *filename* to specified XML file on which to apply update.
Files are scanned from **-d** option and type is taken from file extension:
``` bash
$> dynawo nrt-xsl -d <DIRECTORY> --file <FILE_PATTERN>
```
