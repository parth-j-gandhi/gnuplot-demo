#!/usr/bin/perl -w
use strict;
use warnings;

use Chart::Gnuplot;

# Time series name and date range
my $mkt = "XOM";
my $dateB = '2009-07-01';
my $dateE = '2009-12-31';

# Read and save data into arrays
my (@dt, @pr, @pd, @vr, @vd) = ();
my $tsFile = "data/time_series.csv";
open(TS, $tsFile) || die "Can't read $tsFile";
while(<TS>)
{
    next if (!/^\d/);

    chomp;
    my ($dt, $op, $hi, $lo, $cl, $vo) = split(/,/);
        $vo /= 1000000;
    next if ($dt lt $dateB || $dt gt $dateE);

    if ($cl > $op)
    {
        unshift(@pr, [$dt, $op, $hi, $lo, $cl]);
        unshift(@vr, [$dt, $vo]);
    }
    else
    {
        unshift(@pd, [$dt, $op, $hi, $lo, $cl]);
        unshift(@vd, [$dt, $vo]);
    }
}
close(TS);

# Chart object
my $chart = Chart::Gnuplot->new(
    output => "/tmp/demo_image2.jpg",
    title  => $mkt,
#    bg     => {color => "gray"} 
);

# Price sub-chart object
my $priceChart = Chart::Gnuplot->new(
    xtics    => {labelfmt => '%b%y'},
    y2tics   => 'on',
    xrange   => ['2009-07-01', '2009-12-31'],
    timeaxis => 'x',
    grid     => 'on',
    lmargin  => 9,
    rmargin  => 9,
    size     => '1, 0.7',
    origin   => '0, 0.2',
);

# Volume sub-chart object
my $volumeChart = $priceChart->copy;
$volumeChart->set(
    xtics  => {
        labelfmt  => '%b%y',
        fontcolor => 'white',
    },
    yrange => [0, 100],
    size   => '1, 0.23',
    origin => '0, 0',
);
$volumeChart->label(
    text     => 'Volume (mil)',
    position => '"2009-07-05",70',
);

# Set Gnuplot path for MS Windows
$chart->gnuplot('/usr/bin/gnuplot');

# Price data of rising dates
my $priceRise = Chart::Gnuplot::DataSet->new(
    points  => \@pr,
    timefmt => '%Y-%m-%d',
    style   => 'candlesticks',
    color   => 'dark-green',
    fill    => {density => 0.3},
);

# Volume data of rising dates
my $volumeRise = Chart::Gnuplot::DataSet->new(
    points  => \@vr,
    timefmt => '%Y-%m-%d',
    style   => 'impulses',
    color   => 'dark-green',
);

# Price data of droppping dates
my $priceDrop = Chart::Gnuplot::DataSet->new(
    points   => \@pd,
    timefmt  => '%Y-%m-%d',
    style    => 'candlesticks',
    color    => 'light-red',
    fill     => {density => 0.3},
    linetype => 'solid',
);

# Volume data of droppping dates
my $volumeDrop = Chart::Gnuplot::DataSet->new(
    points   => \@vd,
    timefmt  => '%Y-%m-%d',
    style    => 'impulses',
    color    => 'red',
    linetype => 'solid',
);

# Plot the data
$priceChart->add2d($priceRise, $priceDrop);
$volumeChart->add2d($volumeRise, $volumeDrop);
$chart->multiplot([[$priceChart], [$volumeChart]]);
