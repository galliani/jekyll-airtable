require "jekyll-airtable/version"
require "jekyll-airtable/configuration"
require "jekyll-airtable/api"
require "jekyll-airtable/client"

module Jekyll
  module Airtable
    extend Configuration

    def self.client(options = {})
      Jekyll::Airtable::Client.new(options)
    end

    # Delegate to Airtable::Client
    def self.method_missing(method, *args, &block)
      return super unless client.respond_to?(method)
      client.send(method, *args, &block)
    end

    # Delegate to Airtable::Client
    def self.respond_to?(method, include_all=false)
      return client.respond_to?(method, include_all) || super
    end  
  end
end

require "jekyll/airtable_fetcher"