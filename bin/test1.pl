use PDL;
use PDL::Graphics::Gnuplot qw(plot plot3d);

 my $x = sequence(101) - 50;
 plot($x**2);

