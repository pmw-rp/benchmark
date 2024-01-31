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

[redpanda]
%{ for i, ip in redpanda_public_ips ~}
${ ip } ansible_user=${ ssh_user } ansible_become=True private_ip=${redpanda_private_ips[i]} id=${i}
%{ endfor ~}

[client]
%{ for i, ip in clients_public_ips ~}
${ ip } ansible_user=${ ssh_user } ansible_become=True private_ip=${clients_private_ips[i]} id=${i}
%{ endfor ~}

[control]
${control_public_ips[0]} ansible_user=${ ssh_user } ansible_become=True private_ip=${control_private_ips[0]} id=0

[prometheus]
%{ for i, ip in prometheus_host_public_ips ~}
${ ip } ansible_user=${ ssh_user } ansible_become=True private_ip=${prometheus_host_private_ips[i]} id=${i}
%{ endfor ~}

[all:vars]
instance_type=${instance_type}
