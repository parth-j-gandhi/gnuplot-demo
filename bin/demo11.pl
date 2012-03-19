#!/usr/bin/perl -w

use strict;
use warnings;

use Chart::Gnuplot;

my $tsFile = "data/data_3d.dat";

# Price sub-chart object
my $closeChart = Chart::Gnuplot->new(
    output   => "graphs/demo11.jpg",
    title    => '3D Data',
);

# Volume data of droppping dates
my $dataSet = Chart::Gnuplot::DataSet->new(
    datafile => $tsFile,
    style    => 'lines',
    color    => 'red',
    linetype => 'solid',
);

# Plot the data
$closeChart->plot3d($dataSet);
