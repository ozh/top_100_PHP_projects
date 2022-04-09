#!/usr/bin/env ruby

# We will parse json and make HTTP requests to the API
require 'json'
require 'net/http'

# Remote URL to parse
url = 'https://api.github.com/search/repositories?q=language:php&stars:%3E0&sort=stars&per_page=100'
uri = URI(url)
response = Net::HTTP.get(uri)

# Parse the JSON data into a Ruby hash
parsed = JSON.parse(response)

# Open the template file
template = File.read('./template.md')

# Store the parsed data in a variable
result =  "| # | Repository | Description | Stars | Forks |\n"
result += "|---|------------|-------------|-------|-------|\n"
counter = 0
parsed['items'].each do |item|
  counter = counter + 1
  counter_formatted = sprintf('%03d', counter)
  result += "| #{counter_formatted} | [#{item['full_name']}](#{item['html_url']}) | #{item['description']} | #{item['stargazers_count']} | #{item['forks']} |\n"
end
# Add date of last update with day/month/year hour:minute
result += "\n\nLast update : #{Time.now.strftime("%d/%m/%Y %H:%M")}\n\n"

# Replace the placeholder in the template with the actual data
template.gsub!('{{data}}', result)

# Write the template to a file
File.open('./README.md', 'w') do |file|
  file.write(template)
end

# Thank you GitHub Copilot !!
