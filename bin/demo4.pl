#!/usr/bin/perl -w

use strict;
use warnings;

use Chart::Gnuplot;

# Time series name and date range
my $mkt = "XOM";

# Read and save data into arrays
# my (@dt, @pr, @pd, @vr, @vd) = ();
my @closes = ();

my $tsFile = "data/finance.dat";

open my $ts, '<', $tsFile or die "Can't read $tsFile: $!";
LINE:
while(<$ts>) {
    next LINE if (!/^\d/);

    chomp;
    my ($dt, $op, $hi, $lo, $cl, $vo) = split(/\t/);
    unshift(@closes, [$dt, $op, $hi, $lo, $cl]);
}
close $ts;

# Price sub-chart object
my $closeChart = Chart::Gnuplot->new(
    output   => "graphs/demo4.jpg",
    title    => 'Finance Bars',
    xtics    => {labelfmt => '%b%y'},
    y2tics   => 'on',
    ytics    => {labels => [105, 100, 95, 90, 85, 80]},
    xrange   => ['2/27/2003', '2/27/2004'],
    yrange   => [75, 105],
    timeaxis => 'x',
    grid     => 'off',
    lmargin  => 9,
    rmargin  => 9,
);

# Volume data of droppping dates
my $dataSet = Chart::Gnuplot::DataSet->new(
    points   => \@closes,
    func     => {y => "log10(t)"},
    timefmt  => '%m/%d/%Y',
    style    => 'financebars',
    color    => 'red',
    linetype => 'solid',
);

# Plot the data
$closeChart->plot2d($dataSet);
