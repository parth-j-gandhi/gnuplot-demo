use strict;
use warnings;

use Chart::Gnuplot;

my $chart = Chart::Gnuplot->new(
    output => "graphs/demo10.gif",
);

my $T = 30; # number of frames
my @c;
for (my $i = 0; $i < $T; $i++)
{
    $c[$i] = Chart::Gnuplot->new(xlabel => 'x');
    my $ds = Chart::Gnuplot::DataSet->new(
        func => "sin($i*2*pi/$T + x)",
    );
    $c[$i]->add2d($ds);
}

$chart->animate(
    charts => \@c,
    delay  => 10,   # delay 0.1 sec between successive images
);
