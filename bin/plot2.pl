    use strict;
    use warnings;

    use Chart::Gnuplot;

    # Data
    my @xy = (
        [1.1, -3],
        [1.2, -2],
        [3.5,  0]
    );

    my $chart = Chart::Gnuplot->new(
        output => "/tmp/points.png",
	bg     => {color => 'white'}
    );

    my $dataSet = Chart::Gnuplot::DataSet->new(
        points => \@xy
    );

    $chart->plot2d($dataSet);
