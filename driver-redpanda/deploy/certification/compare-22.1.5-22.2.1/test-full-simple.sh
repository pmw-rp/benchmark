#!/usr/bin/env bash
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -e

if [ "$1" = "" ]; then
    echo "Must provide owner ./test-load user-name"
    exit 1
fi

pushd $(dirname $0)
setup=$(pwd)
cd ..

for i in 1; do
    deployment=$(date +%s)
    echo "$(date) terraforming" >> log
    terraform apply -auto-approve -var="username=$1"
    sleep 1m
    
    echo "$(date) deploying" >> log
    ansible-playbook deploy.yaml
    
    for v in "22.1.5" "22.2.1"; do
        echo "$(date) installing $v" >> log
        ansible-playbook redpanda.install.yaml --extra-vars "redpanda_version=$v~rc1-1"
        ansible-playbook redpanda.pre.configure.base.yaml
        echo "$(date) testing suite-full-simple" >> log
        ansible-playbook test.yaml --extra-vars "suite=suite-full-simple"
        echo "$(date) tested suite-full-simple" >> log
        results="$setup/results/full/$deployment/$v"
        ./fetch-n-report.sh $results $v
        if [ ! -d "$results" ]; then
            echo "$(date) fetch-n-report.sh failed to build $results" >> log
            exit 1
        fi
        echo "$(date) stopping redpanda" >> log
        ansible-playbook redpanda.stop.yaml
        echo "$(date) uninstalling redpanda" >> log
        ansible-playbook redpanda.uninstall.yaml
    done
    echo "$(date) destroying" >> log
    terraform destroy -auto-approve -var="username=$1"
done

popd