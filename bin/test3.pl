use PDL;
use PDL::Graphics::Gnuplot qw(plot plot3d);

 my $x  = sequence(101) - 50;
 my $xy = zeros(21,21)->ndcoords - pdl(10,10);
 my $z  = inner($xy, $xy);
 plot(title  => 'Heat map', '3d' => 1,
      extracmds => 'set view 0,0',
      with => 'image', tuplesize => 3, $z*2);
