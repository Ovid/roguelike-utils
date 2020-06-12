package Games::Roguelike::Area::Rooms;

use base 'Games::Roguelike::Area';

use strict;
use Carp;
use Games::Roguelike::Utils qw(:all);

# ABSTRACT: Roguelike room areas

=item generate ('rooms', [with=>[sym1[,sym2...]])

Makes a random nethack-style map with a bunch of rectangle rooms connected by corridors

If you specify a "with" list, it puts those symbols on the map in random rooms, and calls "addfeature" on them.

=cut

sub generate {
    my $self = shift;
    my %opts = @_;

    my ( $m, $fx, $fy );

    my $rooms = 0;

    for my $feature ( @{ $opts{with} } ) {
        ( $fx, $fy ) = $self->rpoint_empty();
        $self->{map}->[$fx][$fy] = $feature;
        push @{ $self->{f} }, [ $fx, $fy, 'FEATURE' ];
        ++$rooms if $self->genroom( $fx, $fy );    # put rooms around features
    }

    # some extra rooms
    while ( $rooms < ( $self->{w} * $self->{h} / 600 ) ) {
        ++$rooms
          if $self->genroom( ( $fx, $fy ) = $self->rpoint_empty(),
            nooverlap => 1 );
    }

    # dig out paths
    my ( $px, $py );
    for ( randsort( @{ $self->{f} } ) ) {
        my ( $x, $y, $reason ) = @{$_};
        if ($px) {
            if ( !$self->findpath( $x, $y, $px, $py ) ) {
                $self->makepath( $x, $y, $px, $py );
                if ( !$self->findpath( $x, $y, $px, $py ) ) {
                    $self->{map}->[$px][$py] = '1';
                    $self->{map}->[$x][$y]   = '2';
                    $self->dump();
                    die "makepath failed!!!\n";
                    $self->makepath( $x, $y, $px, $py );
                }

                #$self->drawmap();
            }
        }
        ( $px, $py ) = ( $x, $y );
    }
}



=head1 SEE ALSO

L<Games::Roguelike::Area>

=cut


1;
