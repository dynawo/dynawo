## XSL files

Starting from commit c600353edaa664e306293978751239454823d86b we will now provide a way to update XML files.

This directory contains XSL files to be able to follow naming changes in various Dyna&omega;o XML files (.dyd, .par ...).

They will apply on some of Dyna&omega;o files and the naming will be the following: `issueNumber.type.xsl`, where **issueNumber** refers to the associated issue on Github and **type** will be either be dyd or par.

On Linux to apply it you can do:
``` bash
$> xsltproc -o myFile_new.par 267.par.xsl myFile.par
```

`xsltproc` is available in the package `libxslt` on Fedora.

an utility script is provided to automatically apply those XSL on existing projects.
To apply all XSL on all non-regression tests:
``` bash
$> dynawo nrt-xsl
```

It is also possible to filter by names on which non-regression tests the XSL are applied:
``` bash
$> dynawo nrt-xsl -n IEEE14
```

To apply the XSL on a specific simulation project the option --jobs can be used:
``` bash
$> dynawo nrt-xsl --jobs <JOBS_FILE>
```

The --types option is provided to specify which types should be updated. It could be added to any of the possibilities described above:
``` bash
$> --types <jobs/dyd/par/crv>
```

## Use XSL script from a distribution

XSL files can be used to update old test cases with a new dynawo distribution. Follow [this](https://github.com/dynawo/dynawo#using-a-distribution) on how to download a distribution.

Then you can use the following commands to update a test case:

``` bash
$> unzip Dynawo_Linux_latest.zip
$> cd dynawo/sbin/xsl
$> export DYNAWO_NRT_SCRIPT_DIR=$(pwd)/../nrt
$> export DYNAWO_BRANCH_NAME=master
$> export DYNAWO_NRT_DIR=$DYNAWO_NRT_SCRIPT_DIR
$> export DYNAWO_NRT_DIFF_DIR=$DYNAWO_NRT_SCRIPT_DIR/nrt_diff
$> export DYNAWO_CURVES_TO_HTML_DIR=$(pwd)/../curvesToHtml
$> export DYNAWO_ENV_DYNAWO=nothing
$> python applyXsltToXml.py -j <PATH_TO_JOB>
```

Note: an issue is currently open to ease the use of this script and avoid unnecessary environment variables definition.
