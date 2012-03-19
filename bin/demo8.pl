#!/usr/bin/perl -w

use strict;
use warnings;

use Chart::Gnuplot;

my $mkt = "XOM";

my (@closes, @bollinger_low, @bollinger_avg, @bollinger_high, @intraday_intensity, @volume) = ();

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
    unshift(@volume, [$dt, $vo/10000]);
}
close $ts;

my $chart = Chart::Gnuplot->new(
    output   => "graphs/demo8.jpg",
    title    => 'Finance Bars with Bollinger Bands',
);

$chart->label(
		text     => "Parth Gandhi - copyright",
		position => '"2003-07-01",78',
	     );

my $bar_chart = Chart::Gnuplot->new(
    xtics     => {labelfmt => '%b%y'},
    ytics     => {labels => [105, 100, 95, 90, 85, 80]},
    xrange    => ['2/27/2003', '2/27/2004'],
    yrange    => [75, 105],
    timeaxis  => 'x',
    grid      => 'on',
    lmargin   => 9,
    rmargin   => 9,
);

my $barData = Chart::Gnuplot::DataSet->new(
    points   => \@closes,
    func     => {y => "log10(t)"},
    timefmt  => '%m/%d/%Y',
    style    => 'financebars',
    color    => 'red',
    linetype => 'solid',
);

my $bollLowData = Chart::Gnuplot::DataSet->new(
    points   => \@bollinger_low,
    timefmt  => '%m/%d/%Y',
    style    => 'lines',
    color    => 'purple',
    linetype => 'solid',
);

my $bollAvgData = Chart::Gnuplot::DataSet->new(
    points   => \@bollinger_avg,
    timefmt  => '%m/%d/%Y',
    style    => 'lines',
    color    => 'yellow',
    linetype => 'solid',
);

my $bollHighData = Chart::Gnuplot::DataSet->new(
    points   => \@bollinger_high,
    timefmt  => '%m/%d/%Y',
    style    => 'lines',
    color    => 'green',
    linetype => 'solid',
);

my $intensityData = Chart::Gnuplot::DataSet->new(
    points   => \@intraday_intensity,
    timefmt  => '%m/%d/%Y',
    style    => 'lines',
    color    => 'black',
    linetype => 'solid',
    axes     => 'x1y2',
);

# Plot the data
$bar_chart->add2d($barData, $bollLowData, $bollAvgData, $bollHighData, $intensityData);

my $vol_chart = Chart::Gnuplot->new(
    xtics     => {labelfmt => '%b%y'},
    ytics     => {labels   => [0, 500, 1000, 1500, 2000, 2500]},
    xrange    => ['2/27/2003', '2/27/2004'],
    timeaxis  => 'x',
    grid      => 'on',
    lmargin   => 9,
    rmargin   => 9,
    size      => "1, 0.3",
);
my $volData = Chart::Gnuplot::DataSet->new(
    points   => \@volume,
    timefmt  => '%m/%d/%Y',
    style    => 'impulses',
    color    => 'blue',
    linetype => 'solid',
);
$vol_chart->add2d($volData);

## Final Graph
$chart->multiplot([[$bar_chart], [$vol_chart]]);
