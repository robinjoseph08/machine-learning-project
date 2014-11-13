# setup load path
$:.unshift File.dirname(__FILE__)

# get rid of empty lines and split each row
def cleanse_data data
  # get rid of empty lines by filtering
  data = data.select do |line|
    line != ''
  end

  # split each row into arrays with map
  data = data.map do |line|
    line.strip.split(/\s+/)
  end

  data
end

def cleanse_attrs data
  # get rid of empty lines by filtering
  data = data.select do |line|
    line != ''
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
training_data = cleanse_data  training_data
attr_data     = cleanse_attrs attr_data
