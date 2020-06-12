package Games::Roguelike;

use strict;

our $VERSION = '0.4.' . [qw$Revision: 236 $]->[1];

__END__

=head1 NAME

Roguelike::Utils - Roguelike Library for Perl

=head1 SYNOPSIS

    package My::World {
      use parent 'Games::Roguelike::World';
    }

    package main;
    use Games::Roguelike::Area;
    use Games::Roguelike::Mob;

    # creates a world with specified width/height & map display width/height
    my $world = My::World->new( w => 80, h => 50, dispw => 40, disph => 18 );

    # create a new area in this world called "1"
    $world->area( Games::Roguelike::Area->new( name => '1' ) );

    # make a cavelike maze
    $world->area->genmaze2();

    # add a mobile object with symbol '@'
    my $char = Games::Roguelike::Mob->new( $world->area, sym => '@', pov => 8 );

    # set viewpoint to be from $char's perspective
    $world->setvp($char);

    # draw the active area map from the current perspective
    $world->drawmap();

    # move until 'q'
    while ( ( my $c = $world->getch() ) ne 'q' ) {
        $char->kbdmove($c);
        $world->drawmap();
    }

=head1 DESCRIPTION

Library for pulling together field of view, character handling and map drawing
code.

=over 4

=item * ::World is the main "world" object

=item * uses the ::Console library to draw the map

=item * assumes the user will be using overridden ::Mob's as characters in the game

=back

Please also see the examples and test scripts located in the C<scripts>
directory included with this distribution.  Some of the examples are fully
working mini-games.

In particular, F<scripts/example> is well-documented and easy to follow.

=head1 AUTHOR

Erik Aronesty <earonesty@cpan.org>

=head1 MAINTAINER

Curtis "Ovid" Poe <ovid@cpan.org>

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html> or the included LICENSE
file.

