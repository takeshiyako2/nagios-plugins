# Nagios Plugins for nrpe

## check_tcp_count.pl

Check TCP connection count from netstat.


### Usage

```
check_tcp_num.pl -w [warning_value] -c [critical_value]
```

### Exsample

```
check_tcp_num.pl -w 10000 -c 30000
```

### Tips

Almost allways this script need long time taken.
Set long timeout to your Nagios commands.

nagios.cfg
```
service_check_timeout=120
```


commands.cfg
```
define command {
        command_name    check_nrpe_timeout_120
        command_line    $USER1$/check_nrpe -H $HOSTADDRESS$ -c $ARG1$ -t 120
}
```

your_servers.cfg
```
define service{
  use  aws-service
  host_name  your.hostname.jp
  service_description  TCP Port count
  check_command  check_nrpe_timeout_120!check_tcp_num
}
```
