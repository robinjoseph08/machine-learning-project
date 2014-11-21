# setup load path
$:.unshift File.dirname(__FILE__)
require 'nb_classifier'
require 'nn_classifier'

# get rid of empty lines and determine type of each row
def cleanse_attrs data
  # get rid of empty lines by filtering
  data = data.select do |line|
    line != ''
  end

  # determine the type of each attr
  data = data.map do |line|
    ret = {}
    val = line.strip.gsub(/^.*: /, "").gsub(/\.$/, "").split(/\s+/)
    unless val.index("cont").nil?
      ret[:type]   = :cont # continuous
      ret[:method] = :to_f
    else
      ret[:type]   = :disc # discrete
      ret[:method] = :to_i
      ret[:values] = val.first.split(",").map do |v|
        v.to_i
      end
    end
    ret
  end

  data
end

# get rid of empty lines and split each row
def cleanse_data data, attr_types
  # get rid of empty lines by filtering
  data = data.select do |line|
    line != ''
  end

  # split each row into arrays with map
  data = data.map do |line|
    line.strip.split(/\s+/).each_with_index.map do |el, i|
      el.send attr_types[i][:method]
    end
  end

  data
end

# get the passed in arguments
training_file = ARGV.shift
attr_file     = ARGV.shift

# read the training and attribute data
training_data = File.read(training_file).split("\n")
attr_data     = File.read(attr_file).split("\n")

# make the data more usable
attr_types    = cleanse_attrs attr_data
training_data = cleanse_data  training_data, attr_types

# create classifiers
cs = []
cs << NaiveBayesClassifier.new(attr_types[0...-1])
cs << NearestNeighborClassifier.new(attr_types[0...-1], 1)
cs << NearestNeighborClassifier.new(attr_types[0...-1], 3)
cs << NearestNeighborClassifier.new(attr_types[0...-1], 5)

cs.each_with_index do |c, i|
  puts "[#{i}] NUMBER CORRECT FOR CV:   #{c.cv_train training_data}"
  # c.train training_data
  # puts "[#{i}] NUMBER CORRECT FOR TEST: #{c.test training_data}"
end
