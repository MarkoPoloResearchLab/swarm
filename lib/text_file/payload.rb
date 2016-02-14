class Payload
  def initialize(payload)
    @payload = payload
    fail PayloadError, <<-ERROR_MESSAGE unless payload_valid?
      Payload must have the following keys: #{missing_keys}
      Received payload: #{payload}
    ERROR_MESSAGE
  end

  def unique_key_value
    payload[unique_key]
  end

  def to_hash
    {
      unique_key => unique_key_value,
      parts: { payload[:part] => payload }
    }
  end
  alias_method :to_h, :to_hash

  private

    attr_reader :payload

    def unique_key
      payload[:unique_key].to_sym
    end

    def expected_payload_keys
      %i(unique_key part last?)
    end

    def missing_keys
      expected_payload_keys - payload.keys
    end

    def payload_valid?
      expected_payload_keys.all? { |m| payload.key?(m) }
    end

    def uuid
      @uuid ||= SecureRandom.uuid
    end
end

class PayloadError < StandardError
end
