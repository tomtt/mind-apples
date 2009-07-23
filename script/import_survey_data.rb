#!/usr/bin/env ruby

require 'rubygems'
require 'fastercsv'

csv_filename = File.join(ENV['HOME'],
                         'created',
                         'projects',
                         'mindapples',
                         'survey',
                         'CSV',
                         'Sheet_1.csv')

labels = nil
data_types = nil
data = []

FasterCSV.foreach(csv_filename) do |row|
  if labels.nil?
    labels = row
    next
  end
  if data_types.nil?
    data_types = row
    next
  end
  data << row
end

puts data[40]
puts data.size
