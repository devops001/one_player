#!/usr/bin/env ruby

require 'pp'
require 'mongo'
include Mongo

class Dict
  @@dict = File.read("/usr/share/dict/american-english").split("\n")
  def self.word
    @@dict[rand(@@dict.count)].strip
  end
end

db    = MongoClient.new("localhost").db("wiki")
pages = db.collection("pages")
pages.remove

punctuation = [',', '.', '?', '!'] 

100.times do |page_num|
	words     = []
  last_punc = 0
	100.times do |word_num|
	  word = Dict.word
    diff = word_num - last_punc
    if diff>3 and rand(5)==0
      last_punc = word_num
      punc = punctuation[rand(punctuation.count)]
      words[words.count-1] = "#{words[words.count-1]}#{punc}"
      word.capitalize! if punc != ','
    end
    words << word
	end
  words[0].capitalize!
  name = "#{Dict.word.capitalize} #{Dict.word} #{Dict.word}"
	page = { :type=>'text/html', :name=>name, :body=>"<h3>Page #{page_num}</h3><p>#{words.join(" ")}</p>" }
	id   = pages.insert(page)
  if id.nil?
    pp page
    puts
  else
    puts "created page \"#{name}\" id: #{id}"
  end
end


