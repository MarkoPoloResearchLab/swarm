module CoreExtensions
  module Responsive
    refine Symbol do
      def ~@
        -> (o) { o.respond_to?(self) }
      end
    end
  end
end
