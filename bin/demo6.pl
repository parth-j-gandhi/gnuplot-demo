#!/usr/bin/perl -w

use strict;
use warnings;

use Chart::Gnuplot;
use feature 'say';
use Data::Dump qw/dump/;

my $mkt = "XOM";

my (@closes, @bollinger_low, @bollinger_avg, @bollinger_high, @intraday_intensity) = ();

my $tsFile = "data/finance.dat";

open my $ts, '<', $tsFile or die "Can't read $tsFile: $!";
LINE:
while(<$ts>) {
    next LINE if (!/^\d/);

    chomp;
    my ($dt, $op, $hi, $lo, $cl, $vo, undef, $intensity, $b_avg, $b_high, $b_lo) = split(/\t/);
    unshift(@closes, [$dt, $op, $hi, $lo, $cl]);
    unshift(@bollinger_low, [$dt, $b_lo]);
    unshift(@bollinger_avg, [$dt, $b_avg]);
    unshift(@bollinger_high, [$dt, $b_high]);
    unshift(@intraday_intensity, [$dt, $intensity]);
}
close $ts;

my $chart = Chart::Gnuplot->new(
    output   => "graphs/demo6.jpg",
    title    => 'Finance Bars with Bollinger Bands',
);

my $bar_chart = Chart::Gnuplot->new(
    xtics    => {labelfmt => '%b%y'},
    y2tics   => 'on',
    ytics    => {labels => [105, 100, 95, 90, 85, 80]},
    xrange   => ['2/27/2003', '2/27/2004'],
    yrange   => [75, 105],
    timeaxis => 'x',
    grid     => 'on',
    lmargin  => 9,
    rmargin  => 9,
);

my $barData = Chart::Gnuplot::DataSet->new(
    points   => \@closes,
    func     => {y => "log10(t)"},
    timefmt  => '%m/%d/%Y',
    style    => 'financebars',
    color    => 'red',
    linetype => 'solid',
);

# Plot the data
$bar_chart->add2d($barData);

my $bollinger_low_chart  = $bar_chart->copy();
my $bollLowData = Chart::Gnuplot::DataSet->new(
    points   => \@bollinger_low,
    timefmt  => '%m/%d/%Y',
    style    => 'lines',
    color    => 'purple',
    linetype => 'solid',
);
$bollinger_low_chart->add2d($bollLowData);

my $bollinger_avg_chart  = $bar_chart->copy();
my $bollAvgData = Chart::Gnuplot::DataSet->new(
    points   => \@bollinger_avg,
    timefmt  => '%m/%d/%Y',
    style    => 'lines',
    color    => 'yellow',
    linetype => 'solid',
);
$bollinger_avg_chart->add2d($bollAvgData);

my $bollinger_high_chart = $bar_chart->copy();
my $bollHighData = Chart::Gnuplot::DataSet->new(
    points   => \@bollinger_high,
    timefmt  => '%m/%d/%Y',
    style    => 'lines',
    color    => 'green',
    linetype => 'solid',
);
$bollinger_high_chart->add2d($bollHighData);

my $intensity_chart = $bar_chart->copy();
my $intensityData = Chart::Gnuplot::DataSet->new(
    points   => \@intraday_intensity,
    timefmt  => '%m/%d/%Y',
    style    => 'lines',
    color    => 'black',
    linetype => 'solid',
    axes     => 'x1y2',
);
$intensity_chart->add2d($intensityData);

## Final Graph
$chart->multiplot($bar_chart, $bollinger_low_chart, $bollinger_avg_chart, $bollinger_high_chart, $intensity_chart);
