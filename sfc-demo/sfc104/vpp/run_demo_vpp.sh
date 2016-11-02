#!/bin/bash

HTTPPROXY=$1
HTTPSPROXY=$2

source ./env.sh

vagrant up

./common/install_ovs_to_all.sh ${HTTPPROXY} ${HTTPSPROXY}
if [ $? -ne 0 ] ; then
    exit -1
fi

vagrant ssh ${CLASSIFIER1_NAME} -c "sudo /vagrant/vpp/setup_classifier_vpp.sh"

vagrant ssh ${SFF1_NAME} -c "sudo /vagrant/vpp/setup_sff_vpp.sh"

vagrant ssh ${SF1_NAME} -c "sudo nohup /vagrant/common/setup_sf.sh vpp & sleep 1"

vagrant ssh ${SF2_NAME} -c "sudo nohup /vagrant/common/setup_sf.sh vpp & sleep 1"

vagrant ssh ${SFF2_NAME} -c "sudo /vagrant/vpp/setup_sff_vpp.sh"

vagrant ssh ${CLASSIFIER2_NAME} -c "sudo /vagrant/vpp/setup_classifier_vpp.sh"
