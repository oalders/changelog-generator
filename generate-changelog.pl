#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say state );

use Getopt::Long::Descriptive qw( describe_options );
use Git::Helpers qw( remote_url );
use Pithub ();
use URI    ();

my ( $opt, $usage ) = describe_options(
    'generate-changelog.pl %o <some-arg>',
    [ 'state|s=s', "pull request state", { default => 'closed' } ],
    [],
    [ 'verbose|v', "print extra stuff" ],
    [ 'help', "print usage message and exit", { shortcircuit => 1 } ],
);

print( $usage->text ), exit if $opt->help;

## no critic: InputOutput::RequireEncodingWithUTF8Layer
binmode( STDOUT, ":utf8" );

my ( $gh, $token ) = @ARGV;

die "$0 user|org/repo [token]" if @ARGV > 2;

my ( $user, $repo ) = URI->new( $gh || remote_url() )->path_segments;
$repo =~ s{\.git\z}{};

my $p = Pithub->new(
    {
        search_api => 'v3',
        $token ? ( token => $token ) : (),
        user => $user,
        repo => $repo,
    }
);

my $iter = $p->pull_requests->list(
    params => {
        direction => 'desc',
        sort      => 'updated',
        state     => $opt->state,
    }
);

while ( my $pull_request = $iter->next ) {
    state $count = 0;

    my $user
        = $p->users->get( user => $pull_request->{user}->{login} )->first;
    my $name = $user->{name} || $pull_request->{user}->{login};
    say sprintf(
        '    - %s (GH#%s) (%s)', $pull_request->{title},
        $pull_request->{number}, $name
    );

    ++$count;
    last if $count >= 25;
}
