require_relative "./configuration"

module Jekyll
  module Airtable
    class API
      attr_accessor *Configuration::VALID_OPTIONS_KEYS

      # Creates a new API
      def initialize(options={})
        options = Airtable.options.merge(options)

        Configuration::VALID_OPTIONS_KEYS.each do |key|
          send("#{key}=", options[key])
        end
      end

      def config
        conf = {}

        Configuration::VALID_OPTIONS_KEYS.each do |key|
          conf[key] = send key
        end

        conf
      end

      def versioned_base_endpoint_url
        config[:endpoint] + config[:api_version] + '/' + config[:base_uid] + '/'
      end

      def processing_query_params(request_obj, params, params_key)
        keys = [
          :fields,
          :filter_by_formula,
          :max_records,
          :page_size,
          :sort,
          :view,
          :cell_format,
          :time_zone,
          :user_locale,
          :offset
        ]

        return nil unless keys.include?(params_key) || 
                          params[params_key].nil? || 
                          params[params_key] == ''

        key_string = params_key.to_s.split('_').each_with_index.map do |a, i| 
          if i == 0 then a else a.capitalize end 
        end.join

        request_obj.params[key_string] = params[params_key]
      end
    end
  end
end