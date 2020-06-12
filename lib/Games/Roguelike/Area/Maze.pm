package Games::Roguelike::Area::Maze;

use base 'Games::Roguelike::Area';

use strict;
use Carp;
use Games::Roguelike::Utils qw(:all);

# ABSTRACT: Roguelike maze areas

=item generate('maze', rand=>number, with=>feature-list) 

Generate a tight, difficult maze.  Rand defaults to 5 (higher numbers are less random).

=cut

sub generate {
    my $self = shift;
    my %opts = @_;

    $opts{w} = $self->{w} if !$opts{w};
    $opts{h} = $self->{h} if !$opts{h};

    my ( $cNx, $cNy, $cSx, $cSy );
    my $intDir;
    my $intDone = 0;

    my $blnBlocked;

    use constant X => 0;
    use constant Y => 1;

    $opts{rand} = 5 if !$opts{rand};

    $opts{w} -= 1 if !( $opts{w} % 2 );
    $opts{h} -= 1 if !( $opts{h} % 2 );

    # stores the directions that corridors go in
    my @cDir;
    my @blnMaze;

    do {
        # this code is used to make sure the numbers are odd
        $cSx = 1 + ( int( ( ( $opts{w} - 1 ) * rand() ) / 2 ) * 2 );
        $cSy = 1 + ( int( ( ( $opts{h} - 1 ) * rand() ) / 2 ) * 2 );

        # first opening is free!
        $blnMaze[$cSx][$cSy] = 1 if !$intDone;

        if ( $blnMaze[$cSx][$cSy] ) {

            # randomize directions to start
            @cDir = &getRandomDirections();
            do {
                # only randomisation directions, based on the constant
                @cDir = &getRandomDirections()
                  if !int( $opts{rand} * rand() );
                $blnBlocked = 1;

                # loop through order of directions
                for ( $intDir = 0; $intDir < 4; ++$intDir ) {

                    # work out where this direction is
                    $cNx = $cSx + ( $cDir[$intDir][X] * 2 );
                    $cNy = $cSy + ( $cDir[$intDir][Y] * 2 );

                    # check if the tile can be used
                    my $isFree;
                    if (   $cNx < ( $opts{w} - 1 )
                        && $cNx >= 1
                        && $cNy < ( $opts{h} - 1 )
                        && $cNy >= 1 )
                    {
                        # true if it hasn't been used yet
                        $isFree = !$blnMaze[$cNx][$cNy];
                    }
                    if ($isFree) {

                        # create a path
                        $blnMaze[$cNx][$cNy] = 1;

                        # and the square inbetween
                        $blnMaze[ $cSx + $cDir[$intDir][X] ]
                          [ $cSy + $cDir[$intDir][Y] ] = 1;

                        # this is now the current square
                        $cSx        = $cNx;
                        $cSy        = $cNy;
                        $blnBlocked = 0;

                        # increment paths created
                        $intDone = $intDone + 1;
                        last;
                    }
                }

                # loop until a path was created
            } while ( !$blnBlocked );
        }
    } while (
        $intDone + 1 < ( ( ( $opts{w} - 1 ) * ( $opts{h} - 1 ) ) / 4 ) );

    # create enough paths to fill the whole grid

# this changes the direction to go from the current square, to the next available
    sub getRandomDirections {

        # clear the array
        my @a = ( [ -1, 0 ], [ 1, 0 ], [ 0, -1 ], [ 0, 1 ] );
        my @b;
        while (@a) {
            push @b, splice( @a, rand() * scalar(@a), 1 );
        }
        return @b;
    }

    $self->{map} = [];

    for ( my $y = 0; $y < $opts{h}; ++$y ) {
        for ( my $x = 0; $x < $opts{w}; ++$x ) {
            $self->{map}->[$x][$y]
              = ( $blnMaze[$x][$y] ? $self->{fsym} : $self->{wsym} );
        }
    }

    for my $feature ( @{ $opts{with} } ) {
        my ( $fx, $fy ) = $self->findrandmap('.');
        $self->{map}->[$fx][$fy] = $feature;
        push @{ $self->{f} }, [ $fx, $fy, 'FEATURE' ];
    }
}


=head1 SEE ALSO

L<Games::Roguelike::Area>

=cut


1;
