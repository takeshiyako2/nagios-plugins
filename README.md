# Nagios Plugins for nrpe

## check_tcp_count.pl

Check TCP connection count from netstat.


### Usage

check_tcp_num.pl -w [warning_value] -c [critical_value]

### Exsample

check_tcp_num.pl -w 10000 -c 30000
