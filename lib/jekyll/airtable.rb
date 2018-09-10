require "json"
require 'fileutils'
require 'yaml'
require 'airtable'

module Jekyll
    class Airtable < Jekyll::Generator
      safe true
      priority :lowest      

      def generate(site)
        return false if site.config['AIRTABLE_API_KEY'].nil? || site.config['AIRTABLE_API_KEY'] == ''
        return false if site.config['SYNC_WITH_AIRTABLE'] == 'false'

        Airtable.configure do |config|
          config.api_key = site.config['AIRTABLE_API_KEY']
        end

        client = Airtable.client(base_uid: site.config['AIRTABLE_BASE_UID'])

        site.config['AIRTABLE_TABLE_NAMES'].each do |table_name|
          records = JSON.parse(client.list_records(table_name: table_name, params: {}))
          next if records.size == 0

          records_as_json      = records['records']
          converted_table_name = to_snake(table_name)
          directory_name       = "collections/_" + converted_table_name

          Dir.mkdir(directory_name) unless File.exists?(directory_name)

          records_as_json.each do |record_hash|
            slug     = record_hash['id']
            out_file = File.new("#{directory_name}/#{slug}.md", "w")
            out_file.puts(front_matter_mark)

            # Store the uid
            out_file.puts("uid: #{slug}")

            fields = record_hash['fields']

            fields.each do |key, value|
              snake_key = to_snake(key)

              if value.class.name == 'Array'
                out_file.puts("#{snake_key}:")
                write_array_values(out_file, value)
              else
                value = stringify_value_if_necessary(value)
                out_file.puts("#{snake_key}: #{value}")
              end
            end

            out_file.puts(front_matter_mark)
            
            out_file.close               
          end
        end
      end

      private

      def front_matter_mark
        '---'
      end

      def to_snake(string)
        string.split(' ').map(&:downcase).join('_')
      end

      def write_array_values(file, array)
        array.each do |element|
          #   - { name: 'Low', color: '#306d8c' }
          value = stringify_value_if_necessary(element)
          file.puts("   - #{value}")
        end
      end

      def stringify_value_if_necessary(value)
        return "'#{value}'" if value.include?(':')
        value
      end
    end
  end
end