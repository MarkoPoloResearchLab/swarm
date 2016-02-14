module CoreExtensions
  module DotMethods
    module InstanceMethods
      def method_missing(method_name, *arguments)
        self[method_name] || super
      end

      def respond_to_missing?(method_name, include_private = false)
        self.key?(method_name) || super
      end
    end

    class ::Hash
      include InstanceMethods
    end
  end
end
