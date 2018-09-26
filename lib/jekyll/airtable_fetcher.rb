require "json"
require 'fileutils'
require 'yaml'

module Jekyll
  class AirtableFetcher < Jekyll::Generator
    safe true
    priority :lowest      

    def generate(site)
      return false if should_generate_be_prevented?
      # For storing hashes of attachments that will be saved to the data file
      @attachments_hash = {}
      setup_directories

      client = setting_up_airtable_client

      @table_names.each do |table_name|
        records = client.list_records(table_name: table_name)
        next if records.size == 0

        directory_name = "collections/_" + to_snake(table_name)
        Dir.mkdir(directory_name) unless File.exists?(directory_name)

        records.each do |record|
          fields    = record['fields']
          uid       = record['id']
          out_file  = create_page_for_the_record(directory_name, uid, fields)

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

      write_attachments_data_file
    end

    private

    def should_generate_be_prevented?
      is_enabled    = site.airtable.enable_sync == 'true' || site.config['SYNC_WITH_AIRTABLE'] == 'true'
      return true if !is_enabled
      
      @api_key      = site.config['AIRTABLE_API_KEY']
      @base_uid     = site.airtable.base_uid || site.config['AIRTABLE_BASE_UID']
      @table_names  = site.airtable.tables || site.config['AIRTABLE_TABLE_NAMES']

      return true if @api_key.nil? || @api_key == '' || @base_uid.nil? || @base_uid == ''
      false
    end

    def setting_up_airtable_client
      Airtable.configure { |config| config.api_key = @api_key }

      Airtable.client(base_uid: @base_uid)
    end

    def front_matter_mark
      '---'
    end

    def to_snake(string)
      string.split(' ').map(&:downcase).join('_')
    end

    def write_array_values(file, array)
      array.each do |element|
        if is_this_is_an_attachment?(element)
          # Store only the uid of the attachment in the front matter
          value = element['id'] 

          # Store the hash into the hash of hashes
          @attachments_hash[value] = element
        else        
          #   - { name: 'Low', color: '#306d8c' }
          value = stringify_value_if_necessary(element)
        end
        
        file.puts("  - #{value}")
      end
    end

    def stringify_value_if_necessary(value)
      begin
        return "'#{value}'" if value.include?(':')

        value
      rescue NoMethodError
        value
      end
    end

    def is_this_is_an_attachment?(value)
      is_hash = value.class.name == 'Hash'
      return false unless is_hash

      value.keys.map(&:to_s).include?('filename')
    end

    def setup_directories
      Dir.mkdir('_data') unless File.exists?('_data')
      Dir.mkdir('_data/airtable') unless File.exists?('_data/airtable')      

      Dir.mkdir('collections') unless File.exists?('collections')
    end

    def write_attachments_data_file
      File.open("_data/airtable/attachments.yml", "w") do |f| 
        f.write(@attachments_hash.to_yaml)
      end
    end

    def create_page_for_the_record(directory_name, uid, fields)
      # We use the first field as the primary key
      # Then find the value of the primary key to be stored as the slug, which
      # will be used as file name and the path to the record in the url.
      # However, if the record has field called 'slug', it will be used instead
      pkey      = fields.keys.first
      slug      = fields['slug'].nil? ? fields[pkey] : fields['slug']
      filename  = to_snake(slug) + '.md'

      out_file  = File.new("#{directory_name}/#{filename}", "w")
      out_file.puts(front_matter_mark)
      out_file.puts("uid: #{uid}")

      out_file
    end
  end
end
