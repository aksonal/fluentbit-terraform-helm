locals {

  fluentbit_service = <<EOF
[SERVICE]
    Flush         5
    Log_Level     debug
    Daemon        Off
    Parsers_File  /fluent-bit/etc/parsers.conf
    HTTP_Server   On
    HTTP_Listen   0.0.0.0
    HTTP_Port     2020
EOF


  fluentbit_inputs = <<EOF
[INPUT]
    Name tail
    Tag container-logs.*
    Path /var/log/containers/*.log
    Exclude_Path /var/log/containers/kube-proxy*,/var/log/containers/aws-node*
    DB /var/log/flb_app.db
    Skip_Long_Lines On
    Multiline.Parser cri, docker

[INPUT]
    Name systemd
    Tag systemd.*
    Systemd_Filter _SYSTEMD_UNIT=kubelet.service
    Systemd_Filter _SYSTEMD_UNIT=containerd.service
    Path /var/log/journal
    DB /var/log/flb_systemd.db

[INPUT]
    Name tail
    Tag tail.*
    Path /var/log/containers/kube-proxy*,/var/log/containers/aws-node*
    DB /var/log/flb_dp_tail.db
    Multiline.Parser cri, docker
EOF


  fluentbit_filters = <<EOF
[FILTER]
    Name kubernetes
    Match container-logs.*
    Merge_Log On
    K8S-Logging.Parser On
EOF


  fluentbit_outputs = <<EOF
[OUTPUT]
    Name cloudwatch_logs
    Match container-logs.*
    region ${var.region}
    log_group_name /aws/containerinsights/${var.cluster_name}/application
    log_stream_prefix application-
    auto_create_group false

[OUTPUT]
    Name cloudwatch_logs
    Match systemd.*
    region ${var.region}
    log_group_name /aws/containerinsights/${var.cluster_name}/dataplane
    log_stream_prefix dataplane-systemd-
    auto_create_group false

[OUTPUT]
    Name cloudwatch_logs
    Match tail.*
    region ${var.region}
    log_group_name /aws/containerinsights/${var.cluster_name}/dataplane
    log_stream_prefix dataplane-log-
    auto_create_group false
EOF
}
