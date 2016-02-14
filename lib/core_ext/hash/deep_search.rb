module CoreExtensions
  module DeepSearch
    refine Hash do
      def all(search_key, result = [])
        each do |key, value|
          case
          when key == search_key
            result << value
            next
          when value.respond_to?(:all)
            value.all(search_key, result)
          end
        end

        result
      end

      def where(k_v, result = [])
        result << self if k_v.all? { |k, v| fetch(k, nil) == v }

        searchable_values = values.select { |value| value.respond_to?(:where) }
        searchable_values.map { |value| value.where(k_v, result) }

        result
      end

      def respond_to?(method_name, include_private = false)
        added_methods = %i(where all)
        added_methods.include?(method_name) || super
      end
    end
  end
end
