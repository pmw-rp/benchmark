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

if [ "$1" == "" ]; then
  echo "Must pass a destination and a title e.g. ./fetch-n-report.sh results/22.2.1 22.2.1"
  exit 1
fi

if [ "$2" == "" ]; then
  echo "Must pass a destination and a title e.g. ./fetch-n-report.sh results/22.2.1 22.2.1"
  exit 1
fi

mkdir -p $1
ansible-playbook fetch.yaml
if [ ! -d fetched ]; then
  echo "$(date) failed to fetch fetched" >> log
  exit 1
fi
find fetched | grep foot | xargs -I{} mv {} $1/footprint.tar.bz2
rm -rf fetched
pushd $1
tar xjf footprint.tar.bz2
rm footprint.tar.bz2
popd
python3 ../../../bin/gnuplot_charts.py $1 $2