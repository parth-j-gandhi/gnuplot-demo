use PDL;
use PDL::Graphics::Gnuplot qw(plot plot3d);

 my $pi    = 3.14159;
 my $theta = zeros(200)->xlinvals(0, 6*$pi);
 my $z     = zeros(200)->xlinvals(0, 5);
 plot3d(cos($theta), sin($theta), $z);

