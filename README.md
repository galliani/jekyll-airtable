# Jekyll::Airtable

This gem enables you to easily integrate Airtable with Jekyll site and use it as a database. Everytime the Jekyll build is triggered, the gem would automatically send API request to the Airtable base and tables you specify from the environment variable and then store the records as collections, grouped according to the table names.

## Installation

Add this line to your Jekyll site Gemfile:

```ruby
gem 'jekyll-airtable'
```

And then execute:

    $ bundle install

## Usage

1. Because you will have to mention/use your API key, it is VERY RECOMMENDED to use dotenv so you do not have your API key lying around in plain sight.
```ruby
gem 'dotenv'
```
run bundle install again

2. Add this to your repo .gitignore (create one if does not exist):
```
.env
```

3. Copy the .env.example in this repo to the root of your project, rename it to .env then fill it for your needs.
4. Set the SYNC_WITH_AIRTABLE key in the .env to 'true'

```
SYNC_WITH_AIRTABLE='true'
```

5. You need to add a custom plugin to get the dotenv to work, you do this by creating a folder ```_plugins``` (if does not exist already) inside your Jekyll repo
6. Inside the ```/_plugins ```, create a file called "environment_variables_generator.rb", with this as the content:

```ruby
# Plugin to add environment variables to the `site` object in Liquid templates
require 'dotenv'

module Jekyll
  class EnvironmentVariablesGenerator < Generator
    priority :highest
    
    def generate(site)
      Dotenv.overload
      site.config['env'] = Dotenv.overload

      site.config['SYNC_WITH_AIRTABLE'] = ENV['SYNC_WITH_AIRTABLE']
      site.config['AIRTABLE_API_KEY']   = ENV['AIRTABLE_API_KEY']
      site.config['AIRTABLE_BASE_UID']  = ENV['AIRTABLE_BASE_UID']
      site.config['AIRTABLE_TABLE_NAMES'] = ENV['AIRTABLE_TABLE_NAMES'].split(',').map(&:strip)
    end
  end
end
```

Now the secret keys can be accessed by Jekyll without being visible to the public.

7. Now, you need to declare the plugins in the config.yml
```yml
plugins:
  - jekyll-airtable
  - environment_variables_generator
```

8. Finally, you can execute the plugin using ```sh bundle exec jekyll serve ``` or ```sh bundle exec jekyll build ```

For production, you also have to set those keys and values.


## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/galliani/jekyll-airtable. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Jekyll::Airtable project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/galliani/jekyll-airtable/blob/master/CODE_OF_CONDUCT.md).
