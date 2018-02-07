#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say state );

use Pithub ();

my ( $token, $user, $repo ) = @ARGV;

my $p = Pithub->new(
    {
        search_api => 'v3',
        token      => $token,
        user       => $user,
        repo       => $repo,
    }
);

my $iter = $p->pull_requests->list(
    params => {
        direction => 'desc',
        sort      => 'updated',
        state     => 'closed',
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
