#!/bin/env ruby
# -*- coding: utf-8 -*-
require 'rubygems'
require 'optparse'
require 'aws-sdk'
require 'time'

access_key = "#{ARGV[0]}"
secret_key = "#{ARGV[1]}"
cw_region = "#{ARGV[2]}"
rds_region = "#{ARGV[3]}"
db_instance_identifier = "#{ARGV[4]}"
warning = "#{ARGV[5]}".to_i
critical = "#{ARGV[6]}".to_i

options = {}

OptionParser.new do |opt|
  opt.banner = "Usage: #{$0} command <options>"
  opt.separator ""
  opt.separator "Nagios options:"

  opt.on("-a", "--access_key access_key", "CloudWatch access_key") { |access_key| options[:access_key] = access_key }
  opt.on("-s", "--secret_key secret_key", "CloudWatch secret_key") { |secret_key| options[:secret_key] = secret_key }
  opt.on("-r", "--cw_region cw_region", "CloudWatch region") { |cw_region| options[:cw_region] = cw_region}
  opt.on("-e", "--rds_region rds_region", "RDS region") { |rds_region| options[:rds_region] = rds_region}
  opt.on("-i", "--db_instance_identifier db_instance_identifier", "DBInstanceIdentifier") { |db_instance_identifier| options[:db_instance_identifier] = db_instance_identifier}
  opt.on("-w", "--warn WARN", "Nagios warning level") { |warn| options[:warn] = warn.to_i }
  opt.on("-c", "--crit CRIT", "Nagios critical level") { |crit| options[:crit] = crit.to_i }

  opt.on_tail("-h", "--help", "Show this message") do
    puts opt
    exit 0
  end

  begin
    opt.parse!
  rescue
    puts "Invalid option. \nsee #{opt}"
    exit
  end 

end.parse!

class CheckRDSFreeStorageSpace

  def initialize(options)
    start_time = Time.now - 300
    end_time = Time.now

    ## Certification CloudWatch
    cw = AWS::CloudWatch.new(
      :access_key_id => options[:access_key],
      :secret_access_key => options[:secret_key],
      :cloud_watch_endpoint => options[:cw_region]
    ).client

    ## Certification RDS
    rds = AWS::RDS.new(  
      :access_key_id => options[:access_key],
      :secret_access_key => options[:secret_key],
      :rds_endpoint => options[:rds_region]
    ).client

    ## Get FreeStorageSpace
    free_storage_space = cw.get_metric_statistics(
      :namespace   => 'AWS/RDS',
      :metric_name => 'FreeStorageSpace',
      :statistics  => ['Minimum'],
      :dimensions  => [
        { :name => "DBInstanceIdentifier", :value => options[:db_instance_identifier] }
      ],
      :period      => 60,
      :start_time  => start_time.iso8601,
      :end_time    => end_time.iso8601,
    )[:datapoints][0][:minimum]

    ## Get RDS DISK size
    storage_space = rds.describe_db_instances(
      :db_instance_identifier => options[:db_instance_identifier]
    )[:db_instances][0][:allocated_storage] * 1024 * 1024 * 1024

    ## Calculate
    value = free_storage_space.to_f / storage_space.to_f * 100
    free_space_mb = free_storage_space.to_i / 1024 / 1024
    usage_percent = (100 - value.truncate).to_i
    usage_mb =  ((storage_space.to_f - free_storage_space.to_f) / 1024 / 1024 ).to_i

    ## puts result
    information = " - free space: #{free_space_mb} MB (#{value.truncate}%)|usage=#{usage_mb}MB"
    if options[:crit] >= value.truncate 
      puts "DISK CRITICAL" + information
      exit 2
    elsif options[:warn] >= value.truncate
      puts "DISK WARNING" + information
      exit 1
    else
    puts "DISK OK" + information
    end

  end
end

CheckRDSFreeStorageSpace.new(options)
