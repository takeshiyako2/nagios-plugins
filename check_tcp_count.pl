#!/usr/bin/perl
use strict;
use warnings;
use Pod::Usage;
use Getopt::Long;

# get options
my $opt_w = 0;
my $opt_c = 0;
GetOptions('w=i' => \$opt_w, 'c=i' => \$opt_c);

# if option has
if ($opt_w > 0 && $opt_c > 0){
    my $count= `/usr/bin/ionice -c2 -n7 /bin/nice -n19 netstat | grep tcp | wc -l`;
    chomp($count);
    my $result_text = "TCP Port count: $count|tcpportcount=$count";
    if ($opt_c <= $count) {
        printf "Critical - $result_text\n";
        exit 2;
    } elsif ($opt_w <= $count) {
	printf "Warning - $result_text\n";
        exit 1
    } else {
	printf "OK - $result_text\n";
        exit 0
    }
} else {
    # print usage
    pod2usage(verbose => 0);
}

=head1 NAME

get count of TCP port from netstat

=head1 SYNOPSIS

check_tcp_num.pl -w warning_value -c critical_value

=cut

