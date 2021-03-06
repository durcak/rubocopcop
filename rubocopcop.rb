#!/usr/bin/env ruby

require 'yaml'
require 'fileutils'

def basedir
  File.dirname(__FILE__)
end

def save_to_file(file)
  File.open('.rubocop.yml', 'w') do |f|
    f.write file.to_yaml
  end
end

def delete_old_keys(hash_to_update)
  hash_to_update.each_key do |key|
    hash_to_update[key].delete("Description") if hash_to_update[key].has_key?("Description")
    hash_to_update[key].delete("StyleGuide") if hash_to_update[key].has_key?("StyleGuide")
    hash_to_update[key].delete("SupportedStyles") if hash_to_update[key].has_key?("SupportedStyles")
  end
end

def change_rubocop
  origin = YAML.load_file('.rubocop.yml')
  delete_old_keys(origin)
  save_to_file(origin)

  allcops = origin.select { |k| k == "AllCops" }
  allcops.merge!(YAML.load(`rubocop --show-cops`))

  save_to_file(allcops)
end

def copy_file
  FileUtils.copy(File.join(basedir, '.rubocop.yml'), './')
end

if File.file?(".rubocop.yml")
  change_rubocop
else
  copy_file
end
