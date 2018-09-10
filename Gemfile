source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Specify your gem's dependencies in jekyll-airtable.gemspec
gemspec

gem 'airtable', github: 'galliani/airtable_client'