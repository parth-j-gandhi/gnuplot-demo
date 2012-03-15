use PDL;
use PDL::Graphics::Gnuplot qw(plot plot3d);

 my $x = sequence(101) - 50;
 plot( title => 'Parabola with error bars',
       with => 'xyerrorbars', tuplesize => 4, legend => 'Parabola',
       $x**2 * 10, abs($x)/10, abs($x)*5 );

