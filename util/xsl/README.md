## XSL files

Starting from commit c600353edaa664e306293978751239454823d86b we will now provide a way to update XML files.

This directory contains XSL files to be able to follow naming changes in various Dyna&omega;o XML files (.dyd, .par ...).

They will apply on some of Dyna&omega;o files and the naming will be the following: `issueNumber.type.xsl`, where **issueNumber** refers to the associated issue on Github and **type** will be either be dyd or par.

On Linux to apply it you can do:
``` bash
$> xsltproc -o myFile_new.par 267.par.xsl myFile.par
```

`xsltproc` is available in the package `libxslt` on Fedora.
