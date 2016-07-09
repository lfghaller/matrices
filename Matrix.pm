package Matrix;


sub read_matrices_from_file{
  my ($filename) =  @_;
  my (@r,@c);
  my (@matrices);
  open(FILE, $filename) || die "Could not open $filename: $!";
  while (my $line = <FILE>){
    chomp($line);
    #skip blank lines and comments.
    next if $line =~ /^\s*$|#/;
      if ($line =~ /^<m>/){
        $line = <FILE>;
	if ( $line =~ /rows = /){
	  @r = split /rows = /, $line;
	  #print $r[1];
	}
	$line = <FILE>;
	if ( $line =~ /cols = /){
	  @c = split /cols = /, $line;
	 # print $c[1];
	}
	for (my $i = 0; $i < $r[1]; $i++){
	    $line = <FILE>;
	    if ($line !~ /^<\/m>|^\s+/){
	       #print $line;
	       #push @row, $line;
	       @row = split /\s+/, $line;
	       #print "@row";
	       push @m, [ @row ];
	       #@row = ();
	    }
	}
      }
      #print_matrix(@m);
      if (@m){
         push @matrices, [ @m ];
      }
      @m = ();
  }
  close(FILE);
  #print_matrix(@matrices);
  (@matrices);
}



sub print_matrix{
  my (@matrix) = @_;
  for my $row ( @matrix ){
       print "@$row\n";
  }
}

sub print_matrices{
  my (@matrices) = @_;
  foreach my $row ( @matrices ){
    print "<matrix>\n";
    print_matrix(@$row);
    print "</matrix>\n";
  }
}

sub print_ref_matrix {
  my ($matrix) = @_;
  foreach my $row (@$matrix){
    print "@$row\n";
  }
}

sub matrix_multiply{
  my ($r_mat1,$r_mat2) = @_;
  my ($r_product);
  my($r1,$c1) = matrix_count_rows_cols($r_mat1);
  my($r2,$c2) = matrix_count_rows_cols($r_mat2);
  die "Matrix 1 is $r1 x $c1 and matrix 2 is $r2 x $c2."
    ." Cannot multiply\n" unless ($c1 == $r2);
  for ($i = 0; $i < $r1; $i++) {
    for ($j = 0; $j < $c2; $j++) {
      $sum = 0;
      for ($k = 0; $k < $c1; $k++){
        $sum += $r_mat1->[$i][$k] * $r_mat2->[$k][$j];
      }
      $r_product->[$i][$j] = $sum
    }
  }
  $r_product;
}

#return the number of rows and columns
sub matrix_count_rows_cols{
  my ($r_mat) = @_;
  my $num_rows =  @$r_mat;
  my $num_cols = @{$r_mat->[0]};
  ($num_rows, $num_cols);
}
1;
