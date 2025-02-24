#!/usr/bin/perl

undef $/;
$text = <>;

$text =~ s/\/\/[^\n\r]*(\n\r)?//g;
$text =~ s/\/\*+([^*]|\*(?!\/))*\*+\///g;

print $text;
