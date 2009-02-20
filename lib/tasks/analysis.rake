def only_keep_word_characters(word)
  word.downcase.tr('\/\'-', ' ').tr('^a-z- ', '')
end

def word_analyze(string)
  return unless string
  @@words ||= {}
  words = string.split.map { |word| only_keep_word_characters(word) }
  words.each do |word|
    if word.include?(' ')
      word_analyze(word)
    elsif !word.empty?
      @@words[word] ||= 0
      @@words[word] += 1
    end
  end
end

def show_results
  @@words.to_a.sort_by { |word_freq|
    [word_freq[1], word_freq[0]]
  }.each do |word_freq|
    puts "#{word_freq[0]},#{word_freq[1]}"
  end
end

namespace :mind_apples do
  namespace :analysis do
    desc "Generate list of words in survey"
    task :words do
      require 'environment'

      Survey.all.each do |survey|
        (1..5).each do |i|
          apple = survey.send("apple_#{i}")
          word_analyze(apple)
        end
      end

      show_results
    end
  end
end
