#!/bin/bash

clear

echo ":: W E L C O M E  TO  I N S I G H T S ::"
echo
echo

echo "What is the Company Name?"
read COMPANY

if [ ! -d /Users/dad7/Desktop/InSights/"$COMPANY"/ ]; then
mkdir -p /Users/dad7/Desktop/InSights/"$COMPANY"
fi

echo

echo "What is the Case number?"
read CASE

echo

echo "What is the UUID?"
read UUID

echo

echo "What is the WRITE ONLY Token for telegraf?"
read TOKEN

mkdir -p /Users/dad7/Desktop/InSights/"$COMPANY"/data/

cat <<EOF > /Users/dad7/Desktop/InSights/"$COMPANY"/data/telegraf-data.conf
#NOTE -- These files are provided with specific settings, tag key value pairs, and configuration that should not be changed.
# Changing these configuration files from how they were provided may cause additional deliverables such as metrics, analysis or alerting, to fail
# even though data may be written to the Influx DB API.
# Please contact InfluxData to coordinate any changes that may be needed for your use case as part of our Influx Insight offering.

[global_tags]
  cluster_id = "$UUID"
  environment = "Prod"
  node = "data"

[agent]
  interval = "10s"
  round_interval = true
  metric_buffer_limit = 20000
  metric_batch_size = 5000
  collection_jitter = "0s"
  flush_interval = "30s"
  flush_jitter = "30s"
  debug = false
  hostname = ""

#Agent settings are based on our own Cloud 1.x monitoring and metrics.


[[outputs.influxdb_v2]]
  ## The URLs of the InfluxDB cluster nodes.
  ##
  ## Multiple URLs can be specified for a single cluster, only ONE of the
  ## urls will be written to each interval.
  ## urls exp: http://127.0.0.1:9999
  urls = ["https://us-east-1-1.aws.cloud2.influxdata.com"]

  ## Token for authentication.
  token = "$TOKEN"

  ## Organization is the name of the organization you wish to write to; must exist.
  organization = "andrew+insight@influxdata.com"

  ## Destination bucket to write into.
  bucket = "telegraf"

[[inputs.cpu]]
  percpu = false
  totalcpu = true
  fieldpass = ["usage_idle", "usage_user", "usage_system", "usage_steal"]

#CPU telemetry with certain metrics filtered. CPU utilization is one example.

[[inputs.disk]]

#disk telemetry for disk, percentage used for one example.

[[inputs.diskio]]

# disk io telemetry for bandwidth and latency to drive our IO metrics and alerts.

[[inputs.influxdb]]
  interval = "15s"
  urls = [
    "http://localhost:8086/debug/vars"
  ]
  timeout = "15s"
  namedrop = ["influxdb_subscriber","influxdb_tsm1_cache","influxdb_tsm1_engine","influxdb_tsm1_filestore","influxdb_tsm1_wal","influxdb_shard"]

# This config assumes that you are not running TLS on your data node. If so, you may need to change to https
# If you are using an unsigned cert you may also need to set skip_verify
#  insecure_skip_verify = true

#Influx telemetry by quering the debug/vars endpoint of the Influx data node where telegraf (for the data nodes) will be run.
#Based on our analysis we are filtering about 75% of the overall data that is being captured by this plugin to preserve the key metrics (such as HH, Shard Errors,etc)
#That we graph and monitor for to see usage changes in a Influx cluster.

[[inputs.mem]]

# telegraf memory plugin for memory utilization on the system.

[[inputs.netstat]]

#telegraf netstat plugins for network metrics, number of TCP and UDP connections for example.

[[inputs.system]]
#telegraf system plugin for system metrics, uptime, load average, etc.

[[inputs.internal]]

#metrics on this telegraf agent specifically.

#InfluxDBAware
# You can create a free cloud account as part of InfluxDBAware. Please ask Engineering Support as needed

#[[outputs.influxdb_v2]]
#  ## The URLs of the InfluxDB cluster nodes.
#  ##
#  ## Multiple URLs can be specified for a single cluster, only ONE of the
#  ## urls will be written to each interval.
#  ## urls exp: http://127.0.0.1:9999
#  urls = ["https://<REGION>.cloud2.influxdata.com"]
#
#  ## Token for authentication.
#  token = "<YourWriteToken"
#
#  ## Organization is the name of the organization you wish to write to; must exist.
#  organization = "<YourFreeCloudOrg>"
#
#  ## Destination bucket to write into.
#  bucket = "telegraf"
EOF

mkdir -p /Users/dad7/Desktop/InSights/"$COMPANY"/meta/
cat <<EOF > /Users/dad7/Desktop/InSights/"$COMPANY"/meta/telegraf-meta.conf
#NOTE -- These files are provided with specific settings, tag key value pairs, and configuration that should not be changed.
# Changing these configuration files from how they were provided may cause additional deliverables such as metrics, analysis or alerting, to fail
# even though data may be written to the Influx DB API.
# Please contact InfluxData to coordinate any changes that may be needed for your use case as part of our Influx Insight offering.

[global_tags]
  cluster_id = "$UUID"
  environment = "Prod"
  node = "meta"

[agent]
  interval = "10s"
  round_interval = true
  metric_buffer_limit = 20000
  metric_batch_size = 5000
  collection_jitter = "0s"
  flush_interval = "30s"
  flush_jitter = "28s"
  debug = false
  hostname = ""

#systemd

[[outputs.influxdb_v2]]
  ## The URLs of the InfluxDB cluster nodes.
  ##
  ## Multiple URLs can be specified for a single cluster, only ONE of the
  ## urls will be written to each interval.
  ## urls exp: http://127.0.0.1:9999
  urls = ["https://us-east-1-1.aws.cloud2.influxdata.com"]

  ## Token for authentication.
  token = "$TOKEN"

  ## Organization is the name of the organization you wish to write to; must exist.
  organization = "andrew+insight@influxdata.com"

  ## Destination bucket to write into.
  bucket = "telegraf"


[[inputs.cpu]]
  percpu = false
  totalcpu = true
  fieldpass = ["usage_idle", "usage_user", "usage_system", "usage_steal"]

[[inputs.disk]]

[[inputs.diskio]]

#InfluxDBAware
# You can create a free cloud account as part of InfluxDBAware. Please ask Engineering Support as needed

#[[outputs.influxdb_v2]]
#  ## The URLs of the InfluxDB cluster nodes.
#  ##
#  ## Multiple URLs can be specified for a single cluster, only ONE of the
#  ## urls will be written to each interval.
#  ## urls exp: http://127.0.0.1:9999
#  urls = ["https://<REGION>.cloud2.influxdata.com"]
#
#  ## Token for authentication.
#  token = "<YourWriteToken"
#
#  ## Organization is the name of the organization you wish to write to; must exist.
#  organization = "<YourFreeCloudOrg>"
#
#  ## Destination bucket to write into.
#  bucket = "telegraf"

[[inputs.mem]]

[[inputs.netstat]]

[[inputs.system]]

[[inputs.internal]]
EOF

mkdir -p /Users/dad7/Desktop/InSights/"$COMPANY"/kapa/
cat <<EOF > /Users/dad7/Desktop/InSights/"$COMPANY"/kapa/telegraf-kapa.conf
#NOTE -- These files are provided with specific settings, tag key value pairs, and configuration that should not be changed.
# Changing these configuration files from how they were provided may cause additional deliverables such as metrics, analysis or alerting, to fail
# even though data may be written to the Influx DB API.
# Please contact InfluxData to coordinate any changes that may be needed for your use case as part of our Influx Insight offering.

[global_tags]
  cluster_id = "$UUID"
  environment = "Prod"
  node = "kapa"
# Deprecated monitored key/value pair
#  monitored = "false"
# environment should be dev or prod
# set monitored to true if meant for active monitor
# config file for meta node

[agent]
  interval = "10s"
  round_interval = true
  metric_buffer_limit = 20000
  metric_batch_size = 5000
  collection_jitter = "0s"
  flush_interval = "30s"
  flush_jitter = "28s"
  debug = false
  hostname = ""

#Agent settings are based on our own Cloud 1.x monitoring and metrics.

 [[outputs.influxdb_v2]]
  ## The URLs of the InfluxDB cluster nodes.
  ##
  ## Multiple URLs can be specified for a single cluster, only ONE of the
  ## urls will be written to each interval.
  ## urls exp: http://127.0.0.1:9999
  urls = ["https://us-east-1-1.aws.cloud2.influxdata.com"]

  ## Token for authentication.
  token = "$TOKEN"

  ## Organization is the name of the organization you wish to write to; must exist.
  organization = "andrew+insight@influxdata.com"

  ## Destination bucket to write into.
  bucket = "telegraf"

[[inputs.cpu]]
  percpu = false
  totalcpu = true
  fieldpass = ["usage_idle", "usage_user", "usage_system", "usage_steal"]

[[inputs.disk]]

[[inputs.diskio]]

[[inputs.mem]]

[[inputs.netstat]]

[[inputs.system]]

[[inputs.kapacitor]]
  urls = [
    "http://localhost:9092/kapacitor/v1/debug/vars"
  ]
# This config assumes that you are not running TLS on your Kapacitor. If so, you may need to change to https
# If you are using an unsigned cert you may also need to set skip_verify
#  insecure_skip_verify = true
[[inputs.internal]]

#InfluxDBAware
# You can create a free cloud account as part of InfluxDBAware. Please ask Engineering Support as needed

#[[outputs.influxdb_v2]]
#  ## The URLs of the InfluxDB cluster nodes.
#  ##
#  ## Multiple URLs can be specified for a single cluster, only ONE of the
#  ## urls will be written to each interval.
#  ## urls exp: http://127.0.0.1:9999
#  urls = ["https://<REGION>.cloud2.influxdata.com"]
#
#  ## Token for authentication.
#  token = "<YourWriteToken"
#
#  ## Organization is the name of the organization you wish to write to; must exist.
#  organization = "<YourFreeCloudOrg>"
#
#  ## Destination bucket to write into.
#  bucket = "telegraf"
EOF


cat <<EOF > /Users/dad7/Desktop/InSights/"$COMPANY"/INSTRUCTIONS_FOR_CUSTOMERS.txt
Hello "$COMPANY",

Attached are the telegraf files for your data, meta, & kapa nodes. See $COMPANY_Insights.zip, password for the zip file is $CASE.

Note the data node(s) will use the telegraf-data.conf file, the meta node(s) will use the telegraf-meta.conf file, and kapacitor node will use the telegraf-kapa.conf file.

The zip file should have 3 directories, data, meta, and kapa, each directory contains a README.txt file for steps to place the files. And the *.conf & service files for each node.

Once the files are in place, let me know, and I can activate the InSights service from my side, and I will check if we are getting telemetry.

If you have any questions let me know. If needed, I can setup a Zoom call as well.
EOF

#README for DATA NODE

cat <<EOF > /Users/dad7/Desktop/InSights/"$COMPANY"/data/README.txt
1. Place the telegraf-insights.service file into the /etc/systemd/system directory, and enable

systemctl enable telegraf-insights.service

2. Place the telegraf-data.conf file into the /etc/telegraf/ directory, and start the service

systemctl start telegraf-insights.service

3. Once the files are in place, notify InfluxData Support, and let them verify they are receiving telemetry.
EOF

#README for META NODE

cat <<EOF > /Users/dad7/Desktop/InSights/"$COMPANY"/meta/README.txt
1. Place the telegraf-insights.service file into the /etc/systemd/system directory, and enable

systemctl enable telegraf-insights.service

2. Place the telegraf-meta.conf file into the /etc/telegraf/ directory, and start the service

systemctl start telegraf-insights.service

3. Once the files are in place, notify InfluxData Support, and let them verify they are receiving telemetry.
EOF

#README for KAPA NODE

cat <<EOF > /Users/dad7/Desktop/InSights/"$COMPANY"/kapa/README.txt
1. Place the telegraf-insights.service file into the /etc/systemd/system directory, and enable

systemctl enable telegraf-insights.service

2. Place the telegraf-kapa.conf file into the /etc/telegraf/ directory, and start the service

systemctl start telegraf-insights.service
EOF

#SYSTEMD FILE for DATA

cat <<EOF > /Users/dad7/Desktop/InSights/"$COMPANY"/data/telegraf-insights.service
[Unit]
Description=Insight Telegraf standalone for monitoring of clusters by InfluxData
Documentation=https://github.com/influxdata/telegraf
After=network.target

[Service]
User=root
ExecStart=/usr/bin/telegraf -config /etc/telegraf/telegraf-data.conf
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure
RestartForceExitStatus=SIGPIPE
KillMode=control-group

[Install]
WantedBy=multi-user.target
EOF

#SYSTEMD FILE for META

cat <<EOF > /Users/dad7/Desktop/InSights/"$COMPANY"/meta/telegraf-insights.service
[Unit]
Description=Insight Telegraf standalone for monitoring of clusters by InfluxData
Documentation=https://github.com/influxdata/telegraf
After=network.target

[Service]
User=root
ExecStart=/usr/bin/telegraf -config /etc/telegraf/telegraf-meta.conf
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure
RestartForceExitStatus=SIGPIPE
KillMode=control-group

[Install]
WantedBy=multi-user.target
EOF

#SYSTEMD FILE for KAPA

cat <<EOF > /Users/dad7/Desktop/InSights/"$COMPANY"/kapa/telegraf-insights.service
[Unit]
Description=Insight Telegraf standalone for monitoring of clusters by InfluxData
Documentation=https://github.com/influxdata/telegraf
After=network.target

[Service]
User=root
ExecStart=/usr/bin/telegraf -config /etc/telegraf/telegraf-kapa.conf
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure
RestartForceExitStatus=SIGPIPE
KillMode=control-group

[Install]
WantedBy=multi-user.target
EOF

echo

echo "Add the following to the bottom of the clusters file! https://github.com/influxdata/influxdb_insights/blob/master/c2_admin/clusters.csv"
echo
echo "\"${COMPANY}\",\"${UUID}\",inactive,\"${CASE}\""


echo
echo
