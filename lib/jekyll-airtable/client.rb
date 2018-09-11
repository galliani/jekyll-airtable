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

        response = @connection.get do |req|
          req.url URI.escape(table_name)

          default_params = params.merge(max_records: 100) unless params[:max_records]
          default_params.keys.each do |key|
            processing_query_params(req, default_params, key)
          end
        end

        response.body
      end

      def retrieve_record(table_name:, record_uid:)
        @connection = Faraday.new(url:  versioned_base_endpoint_url) do |faraday|
          faraday.response  :logger                  # log requests to STDOUT
          faraday.request   :url_encoded
          faraday.adapter   Faraday.default_adapter  # make requests with Net::HTTP
        end

        @connection.authorization(:Bearer, Airtable.api_key)

        response = @connection.get(URI.escape(table_name) + '/' + record_uid)

        response.body
      end

    end
  end
end