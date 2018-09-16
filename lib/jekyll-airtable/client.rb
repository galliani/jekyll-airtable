require 'faraday'
require 'uri'
require 'json'

module Jekyll
  module Airtable
    class Client < API

      def list_records(table_name:, params: {})
        @connection = Faraday.new(url:  versioned_base_endpoint_url) do |faraday|
          faraday.response  :logger                  # log requests to STDOUT
          faraday.request   :url_encoded
          faraday.adapter   Faraday.default_adapter  # make requests with Net::HTTP
        end

        @connection.authorization(:Bearer, Airtable.api_key)

        records = []
        offset  = nil
        counter = 1

        begin
          looper = "request no. #{counter}"
          puts 'Sending ' + looper

          params[:offset] = offset if !offset.nil?

          data = send_get_request(table_name, params)
          puts "Response received for the " + looper

          records   << data['records']
          offset    = data['offset']

          # Pause for 1 second, just to be safe
          sleep 1
          counter += 1
        end while !offset.nil?

        records.flatten
      end

      private

      def send_get_request(table_name, params)
        response = @connection.get do |req|
          req.url URI.escape(table_name)

          default_params = params
          default_params.keys.each do |key|
            processing_query_params(req, default_params, key)
          end
        end

        JSON.parse(response.body)
      end

    end
  end
end