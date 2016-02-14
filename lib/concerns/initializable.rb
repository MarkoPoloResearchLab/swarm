module Concerns
  module Initializable
    def self.included(base)
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      def initialize(*args)
        opts = args.last.is_a?(Hash) ? args.pop : {}
        super(*args)
        opts.each_pair do |k, v|
          send "#{k}=", v
        end
      end
    end
  end
end
