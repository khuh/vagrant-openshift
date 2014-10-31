#--
# Copyright 2014 Red Hat, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#++
require_relative "../action"

module Vagrant
  module Openshift
    module Commands
      class BuildOpenshift3InfrastructureImages < Vagrant.plugin(2, :command)
        include CommandHelper

        def self.synopsis
          "builds openshift v3 infrastructure images"
        end

        def execute
          options = {}
          options[:clean] = false
          options[:local_source] = false

          opts = OptionParser.new do |o|
            o.banner = "Usage: vagrant build-openshift3-infrastructure-images --images image_name [vm-name]"
            o.separator ""

            o.on("--images #{Vagrant::Openshift::Constants.openshift3_infrastructure_images.keys.join(' ')} | all", "Specify which images should be built. Default: []") do |f|
              if f.split(" ").include?("all")
                options[:openshift3_infrastructure_images] = Vagrant::Openshift::Constants.openshift3_infrastructure_images.keys
              else
                options[:openshift3_infrastructure_images] = f.split(" ")
              end
            end
          end

          # Parse the options
          argv = parse_options(opts)
          return if !argv
          raise Vagrant::Errors::CLIInvalidUsage, help: opts.help.chomp unless options[:openshift3_infrastructure_images]

          with_target_vms(argv, :reverse => true) do |machine|
            actions = Vagrant::Openshift::Action.build_openshift3_infrastructure_images(options)
            @env.action_runner.run actions, {:machine => machine}
            0
          end
        end
      end
    end
  end
end