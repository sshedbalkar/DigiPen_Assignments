#!/usr/bin/perl -w

BEGIN { push(@INC, '/home/dvolper/bin2'); };
require("timer.pl");

sub test () {
  my ($exe,$test)=@_;
#print "test($exe,$test)\n";
  if ($test==-1)    { return (0,1,2,3,4,5,6,7,8,9,105,106,107  ); } # which tests to run
  elsif ($test==-9) { return (0,0,0,0,0,0,0,0,0,0,  0,  0,  0  ); } #executable
  elsif ($test==-6) { return (3,3,3,3,3,3,3,3,3,3, 10,  6,  15 ); } #weights
  elsif ($test==-8) { return (0,0,0,0,0,0,0,0,0,0,  0,  0,  0  ); } #extra weights
  elsif ($test==-4) { return ("splitter.h","splitter.c"); } #quality
  elsif ($test==-5) { return ("splitter.h","splitter.c"); } #required
  elsif ($test==-3) { return ("gcc_c","gcc_cpp","gcc_c_cpp",
                "msc_c","msc_cpp","msc_c_cpp",
                "bcc_c","bcc_cpp","bcc_c_cpp","bcc_cg"); } #from Makefile

  elsif ($test==-7) { return (  
		  8,0,0,
          0,8,0,
          0,0,8,0 );} #compiler weights
  elsif ($test==-10) { return
        "leak tests:" .
        "105: this is a test of normal splitter operation - all files exist\n" .
        "     just checking you close/free all the stuff you've allocted\n" .
        "106: an attempt to open a non-existing file in joiner,\n" .
        "     possible failure previosuly opened files and allocated memory \n" .
        "     is not closed/freed when exitig in the \"middle\"\n" .
        "107: an attempt to allocate about 4Gb buffer -- \n" .
        "     if you failed this test, then you are trying to allocate a\n" .
        "     buffer of size 4000000000 - while it should have been \n" .
        "     a min(4000000000,4096)\n"
        ;}
  elsif ($test==-2) { # files
    return ("Makefile","driver.c","driver.cpp","bcc_cg.cgi",
        "120","200","20000","21000","joiner",
        "6_0001","6_0002",
        "7_0001","7_0002","7_0003","7_0004",
        "8_0001","8_0002","8_0003","8_0004","8_0005",
        "9_0001", "9_0002", "9_0003", "9_0004", "9_0005", "9_0006", "9_0007", "9_0008", "9_0009", "9_0010", "9_0011", "9_0012", "9_0013", "9_0014", "9_0015", "9_0016", "9_0017", "9_0018", "9_0019", "9_0020", "9_0021", "9_0022", "9_0023", "9_0024", "9_0025", "9_0026", "9_0027", "9_0028", "9_0029", "9_0030", "9_0031", "9_0032", "9_0033", "9_0034", "9_0035", "9_0036", "9_0037", "9_0038", "9_0039", "9_0040", "9_0041", "9_0042", "9_0043", "9_0044", "9_0045", "9_0046", "9_0047", "9_0048", "9_0049", "9_0050", "9_0051", "9_0052", "9_0053", "9_0054", "9_0055", "9_0056", "9_0057", "9_0058", "9_0059", "9_0060", "9_0061", "9_0062", "9_0063", "9_0064", "9_0065", "9_0066", "9_0067", "9_0068", "9_0069", "9_0070", "9_0071", "9_0072", "9_0073", "9_0074", "9_0075", "9_0076", "9_0077", "9_0078", "9_0079", "9_0080", "9_0081", "9_0082", "9_0083", "9_0084", "9_0085", "9_0086", "9_0087", "9_0088", "9_0089", "9_0090", "9_0091", "9_0092", "9_0093", "9_0094", "9_0095", "9_0096", "9_0097", "9_0098", "9_0099", "9_0100"
        );
  }
  if ($test==0) {
    return &split(@_,2,100,"$test"."_","120");
  } elsif ($test==1) {
    return &split(@_,2,100,"$test"."_","200");
  } elsif ($test==2) {
    return &split(@_,2,300,"$test"."_","200");
  } elsif ($test==3) {
    return &split(@_,2,10000,"$test"."_","20000");
  } elsif ($test==4) {
    return &split(@_,2,10000,"$test"."_","21000");
  } elsif ($test==5) {
    return &split(@_,2,5000,"$test"."_","joiner");
  }
#splitting
  elsif ($test==6) {
    return &join(@_,2,"$test"."_joined_student","200","6_0001","6_0002");
  } elsif ($test==7) {
    return &join(@_,2,"$test"."_joined_student","120","7_0001","7_0002","7_0003","7_0004");
  } elsif ($test==8) {
    return &join(@_,2,"$test"."_joined_student","21000","8_000*");
  } elsif ($test==9) {
    return &join(@_,2,"$test"."_joined_student","200","9_0*");
  } elsif ($test==105) {
    return &leak_test1(); #memory leak test (non-existing input in splitter)
  } elsif ($test==106) {
    return &leak_test2(); #memory leak test  (non-existing input in join)
  } elsif ($test==107) {
    return &leak_test3(); #memory leak test (huge chunk size)
  }

}
sub leak_test1() {
  my $stat=&timer("./bcc_cg.exe"," -s 10000 -o leaktest1_ -i 21000","",">/dev/null",2);
}
sub leak_test2() {
  my $stat=&timer("./bcc_cg.exe"," -j -o leak_test2 -i no_such_file","",">/dev/null",2); #input file doesn't exist
}
sub leak_test3() {
  my $stat=&timer("./bcc_cg.exe"," -s 4000000000 -o leaktest3_ -i 21000","",">/dev/null",2);
}

sub split{
  my ($exe,$testname,$timeout,$chunk_size,$chunk_name_base,$input_file)=@_;
#print " running \"./$exe -s $chunk_size -o $chunk_name_base -i $input_file\"\n";
  my $stat=&timer("./$exe"," -s $chunk_size -o $chunk_name_base -i $input_file","",">/dev/null",$timeout);

  my $nf0 = `ls $chunk_name_base* | wc -l`; chop ($nf0); #number of files
  my $fs0 = `du -cb $input_file | awk '/total/{print \$1}'`; chop ($fs0); #filesize
  my $nf0_my = ceil( $fs0 / $chunk_size ); #correct number of chunks
  my $sz0 = `du -cb $chunk_name_base* | awk '/total/{print \$1}'`;
  chop ($sz0); #total size of all chunks
  print "number of chunks $nf0 (correct $nf0_my), total size of chunks $sz0 (correct $fs0)\n";
#join chunks using my executable and check difference
  `rm -f joined ; ../../joiner -j -o joined -i $chunk_name_base*`;
  my $diff = `diff joined $input_file | wc -l`; chop($diff);
  if ( $diff>0 ) {
    print "some chunks contain errors\n";
  } else {
    print "chunks look OK\n";
  }
  return  ($stat, ($nf0!=$nf0_my) , ($sz0!=$fs0) , ($diff!=0) );
}
sub join{
  my ($exe,$testname,$timeout,$output_file_name,$output_file_name_master,@chunks)=@_;
  my $args = " -j -o $output_file_name -i " . join(' ',@chunks);
  my $stat=&timer("./$exe"," $args","",">/dev/null",$timeout);
  $diff = `diff $output_file_name $output_file_name_master | wc -l`; chop($diff);
  print "joining " . join(' ',@chunks) . " into $output_file_name should be the same as \"$output_file_name_master\"\n";
  print "number of different lines is $diff\n";
  return ( $stat,$diff);
}
1
