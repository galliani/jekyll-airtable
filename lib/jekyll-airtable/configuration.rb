module Jekyll
  module Airtable
    module Configuration
      API_URL = 'https://api.airtable.com/'
      API_VERSION = 'v0'

      # An array of valid keys in the options hash
      VALID_OPTIONS_KEYS = [
        :endpoint,
        :api_version,
        :api_key,
        :base_uid
      ].freeze

      attr_accessor *VALID_OPTIONS_KEYS

      # When this module is extended, set all configuration options to their default values
      def self.extended(base)
        base.reset
      end

      # Create a hash of options and their values
      def options
        VALID_OPTIONS_KEYS.inject({}) do |option, key|
          option.merge!(key => send(key))
        end
      end

      # Convenience method to allow configuration options to be set in a block
      # To be called from the base class
      def configure
        yield self
      end

      # Reset all configuration options to defaults
      def reset
        self.endpoint           = API_URL
        self.api_version        = API_VERSION
        self.api_key            = nil
        self.base_uid           = ''
      end    
    end
  end
end