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

public_key_path = "~/.ssh/redpanda_aws.pub"
region          = "us-west-2"
az		        = "us-west-2a"
ami             = "ami-0d31d7c9fc9503726"
redpanda_ami    = "ami-0d31d7c9fc9503726"
profile         = "default"

instance_types = {
  "redpanda"      = "i3en.6xlarge"
  "client"        = "c5n.9xlarge"
  "prometheus"    = "c5.2xlarge"
}

num_instances = {
  "client"     = 4
  "redpanda"   = 3
  "prometheus" = 1
}
