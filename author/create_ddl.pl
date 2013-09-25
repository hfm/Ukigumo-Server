#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use FindBin::libs;

use Ukigumo::Server::Schema;
use Path::Tiny;

my %file = (
    MySQL  => 'mysql',
    SQLite => 'sqlite3',
);

for my $dbm (qw/MySQL SQLite/) {
    my $ddl = Ukigumo::Server::Schema->translate_to($dbm);
    $ddl =~ s/\A\s+//ms;
    $ddl =~ s/\s+\z//;
    $ddl =~ s/^--.*?\n//msg;
    $ddl =~ s/^CREATE ([A-Z ]+)/CREATE ${1}IF NOT EXISTS /msg;

    $ddl = qq[-- DON'T EDIT MANNUALLY! THIS FILE IS GENERATED BY author/create_ddl.pl\n].$ddl;

    my $file = $file{$dbm};

    $file = path('share')->child('sql', "$file.sql");
    $file->spew_utf8($ddl);
}

