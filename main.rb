# setup load path
$:.unshift File.dirname(__FILE__)

# get rid of empty lines and determine type of each row
def cleanse_attrs data
  # get rid of empty lines by filtering
  data = data.select do |line|
    line != ''
  end

  # determine the type of each attr
  data = data.map do |line|
    val = line.strip.gsub(/^.*: /, "").gsub(/\.$/, "").split(/\s+/)
    unless val.index("cont").nil?
      :to_f
    else
      :to_i
    end
  end

  data
end

# get rid of empty lines and split each row
def cleanse_data data, attrs
  # get rid of empty lines by filtering
  data = data.select do |line|
    line != ''
  end

  # split each row into arrays with map
  data = data.map do |line|
    line.strip.split(/\s+/).each_with_index.map do |el, i|
      el.send attrs[i]
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
attr_data     = cleanse_attrs attr_data
training_data = cleanse_data  training_data, attr_data
