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
    if val.index("cont").nil?
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
      if attr_types[i][:type] == :disc
        el.to_i
      end
    end
  end

  data
end

# get the passed in arguments
training_file = ARGV.shift
attr_file     = ARGV.shift
test_file     = ARGV.shift
with_labels   = ARGV.shift == "--with-labels"

# read the training and attribute data
training_data = File.read(training_file).split("\n")
attr_data     = File.read(attr_file).split("\n")
test_data     = File.read(test_file).split("\n") if test_file

# make the data more usable
attr_types    = cleanse_attrs attr_data
training_data = cleanse_data  training_data, attr_types
test_data     = cleanse_data  test_data, attr_types if test_file

# create classifier
c = NaiveBayesClassifier.new(attr_types[0...-1])

unless test_file
  # just doing cross-validation
  puts "ACCURACY FOR CV: #{'%.2f' % (((c.cv_train training_data) * 100.0)/training_data.count)}%"
else
  # we have a test file
  c.train training_data

  if with_labels
    # finding the accuracy of the classifier against the test data
    puts ""
    c.test "training", training_data
    c.test "test",     test_data
  else
    # finding labels of the test data
    test_data.each do |line|
      puts c.classify line
    end
  end
end
