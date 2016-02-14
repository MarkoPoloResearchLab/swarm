require 'fileutils'

module Concerns
  module Pidable
    def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
    end

    module ClassMethods
      def kill_all
        pids.each { |pid| Process.kill('USR1', pid.to_i) }
      end

      def pids_folder
        'tmp/pids'
      end

      private

        def pids
          Dir
            .entries(pids_folder)
            .reject { |f| File.directory?(f) || f.start_with?('.') }
        end
    end

    module InstanceMethods
      private

        def save_pid
          FileUtils.mkdir_p "#{self.class.pids_folder}"
          File.write pid_file, nil
        rescue
          nil
        end

        def remove_pid
          File.delete pid_file
        rescue
          nil
        end

        def pid_file
          "#{self.class.pids_folder}/#{pid}"
        end

        def pid
          Process.pid
        end
    end
  end
end
