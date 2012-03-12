use PDL::Graphics::Gnuplot qw(plot plot3d);

 my $x = sequence(101) - 50;
 plot($x**2);

 plot( title => 'Parabola with error bars',
       with => 'xyerrorbars', tuplesize => 4, legend => 'Parabola',
       $x**2 * 10, abs($x)/10, abs($x)*5 );

 my $xy = zeros(21,21)->ndcoords - pdl(10,10);
 my $z = inner($xy, $xy);
 plot(title  => 'Heat map', '3d' => 1,
      extracmds => 'set view 0,0',
      with => 'image', tuplesize => 3, $z*2);

 my $pi    = 3.14159;
 my $theta = zeros(200)->xlinvals(0, 6*$pi);
 my $z     = zeros(200)->xlinvals(0, 5);
 plot3d(cos($theta), sin($theta), $z);
