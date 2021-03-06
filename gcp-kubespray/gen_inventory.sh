#!/bin/bash
set -euxo pipefail

nodes_master=k8s-master02
nodes_node="k8s-node03 k8s-node04"
# 以下のホストは kube_network_plugin: calico で構築されている
# nodes_master=k8s-master01
# nodes_node="k8s-node01 k8s-node02"
# Assign three nodes
nodes_etcd="$nodes_master $nodes_node"

gcloud="gcloud --project praxis-practice-289116 --zone asia-northeast1-b "

{
    echo "[all]"
    login_user=`whoami`
    for node in $nodes_master $nodes_node
    do
        #external_ip=`gcloud compute instances describe $node --format='get(networkInterfaces[0].accessConfigs.natIP)' --project praxis-practice-289116 --zone asia-northeast1-b `
        external_name=$node.asia-northeast1-b.praxis-practice-289116
        internal_ip=`gcloud compute instances describe $node --format='get(networkInterfaces[0].networkIP)' --project praxis-practice-289116 --zone asia-northeast1-b `
        echo $node ansible_host=$external_name ansible_user=$login_user ip=$internal_ip
    done

    echo "[kube-master]"
    for node in $nodes_master
    do
        echo $node
    done

    echo "[etcd]"
    for node in $nodes_etcd
    do
        echo $node
    done

    echo "[kube-node]"
    for node in $nodes_node
    do
        echo $node
    done

    echo "[calico-rr]"

    cat <<__EOC__
[k8s-cluster:children]
kube-master
kube-node
calico-rr
__EOC__
} >inventory/hosts.ini

