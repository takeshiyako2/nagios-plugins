new version is here => https://github.com/takeshiyako2/nagios-check_rds_free_storage_space

--------------------

Amazon RDS free DISK space checker

# How to setup

git clone & sudo bundle

Use IAM policies of AmazonRDSReadOnlyAccess and CloudWatchLogsFullAccess.

# How to use

Check help

```
$ ./check_rds_free_storage_space.rb -h
Usage: ./check_rds_free_storage_space.rb command <options>

Nagios options:
    -a, --access_key access_key      CloudWatch access_key
    -s, --secret_key secret_key      CloudWatch secret_key
    -r, --cw_region cw_region        CloudWatch region
    -e, --rds_region rds_region      RDS region
    -i db_instance_identifier,       DBInstanceIdentifier
        --db_instance_identifier
    -w, --warn WARN                  Nagios warning level. warn percent >= current free space percent
    -c, --crit CRIT                  Nagios critical level. crit percent >= current free space percent
    -h, --help                       Show this message
```

Usage

```
$ ./check_rds_free_storage_space.rb -a <CloudWatch access_key> -s <CloudWatch secret_key> -r <CloudWatch region> -e <RDS region> -i <DBInstanceIdentifier> -w <Nagios warning level> -c <Nagios critical level>
```

Example

```
$ ./check_rds_free_storage_space.rb -a AAAAAA -s SSSSSS -r monitoring.ap-northeast-1.amazonaws.com -e rds.ap-northeast-1.amazonaws.com -i mysql1 -w 30 -c 20
```

# Origin

http://okochang.hatenablog.jp/entry/2013/07/31/100122



