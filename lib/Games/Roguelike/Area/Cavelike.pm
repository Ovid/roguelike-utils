package Games::Roguelike::Area::Cavelike;

use base 'Games::Roguelike::Area';

use strict;
use Carp;
use Games::Roguelike::Utils qw(:all);

# ABSTRACT: Roguelike cave areas

sub generate {
    my $self = shift;
    my %opts = @_;

    my ( $m, $fx, $fy );

    my $digc = 0;

    do {
        my ( $cx, $cy ) = $self->rpoint();
        $self->digone( $cx, $cy );
        if ( my $feature = shift @{ $opts{with} } ) {
            $self->{map}->[$cx][$cy] = $feature;
            push @{ $self->{f} }, [ $cx, $cy, 'FEATURE' ];
        }
        else {
            push @{ $self->{f} }, [ $cx, $cy, 'ROOM' ];
        }
        my @v;
        $v[$cx][$cy] = 1;
        my $dug = 0;
        do {
            my $o = randi(4);
            $dug = 0;
            for ( my $i = 0; $i < 4; ++$i ) {
                my ( $tx, $ty )
                  = ( $cx + $DD[ ( $i + $o ) % 4 ]->[0],
                    $cy + $DD[ ( $i + $o ) % 4 ]->[1] );
                if ( ( !$v[$tx][$ty] ) && $self->diginbound( $tx, $ty ) ) {
                    ( $cx, $cy ) = ( $tx, $ty );
                    ++$digc if $self->digone( $cx, $cy );

                    #print "dig at $cx, $cy $v[$cx][$cy]\n";
                    $v[$cx][$cy] = 1;
                    $dug = 1;
                    last;
                }
            }
        } while ($dug);

    } while ( $digc < ( ( $self->{w} * $self->{h} ) / 8 ) );

    # dig out paths
    my ( $px, $py );
    for ( randsort( @{ $self->{f} } ) ) {
        my ( $x, $y, $reason ) = @{$_};
        if ($px) {
            if ( !$self->findpath( $x, $y, $px, $py ) ) {
                $self->makepath( $x, $y, $px, $py );

                #$self->drawmap();
                #$self->getch();
            }
        }
        ( $px, $py ) = ( $x, $y );
    }
}


=head1 SEE ALSO

L<Games::Roguelike::Area>

=cut


1;
