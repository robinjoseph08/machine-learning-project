class NaiveBayesClassifier

  # classifier constructor
  def initialize attrs
    @attrs   = {}
    @classes = [{},{}]
    # puts the attributes in a format that's easier to work with
    attrs.each_with_index do |a,i|
      @attrs[a.to_sym] = i
    end
  end

  # method used to train the classifier
  def train data
    split_data = []

    [0,1].each do |i|
      # separate the true data from false data
      split_data[i] = data.select do |line|
        line.last == "#{i}"
      end

      # get the probability of the class
      @classes[i][:prob] = split_data[i].length.to_f/data.length

      # get the probability of each attribute given a certain class
      @classes[i][:attrs] = {}
      @attrs.each do |attr|
        @classes[i][:attrs][attr[0]] = []
        [0,1].each do |j|
          @classes[i][:attrs][attr[0]][j] = counter(attr[1], j, split_data[i]).to_f/split_data[i].length
        end
      end
    end

    # output the parameters
    print_params
    puts ""
  end

  # method used to test the classifier
  def test name, data
    total = data.length
    # used to count the number of correctly classified sets
    correct = 0

    data.each do |line|
      correct += line.last == classify(line[0...-1]).to_s ? 1 : 0
    end

    # compute the accuracy of the classifier
    accuracy = (correct * 100.0)/total

    # print testing results
    puts "Accuracy on #{name} set (#{total} instances):  #{'%.1f' % accuracy}%"
    puts ""
  end

  # PRIVATE METHODS

  private

  # count the number of rows of a given data set where a certain index is a certain value
  def counter index, value, data
    data.inject(0) do |total, line|
      line[index] == "#{value}" ? total + 1 : total
    end
  end

  # given an array of attribute values, use the Naive Bayes Algorithm to classify the data
  def classify line
    probs = [@classes[0][:prob], @classes[1][:prob]]

    @classes.each_with_index do |klass, i|
      @attrs.each do |attr|
        probs[i] *= klass[:attrs][attr[0]][line[attr[1]].to_i]
      end
    end

    probs[0] > probs[1] ? 0 : 1
  end

  # print the parameters of the classifier that were estimated
  def print_params
    @classes.each_with_index do |klass, i|
      str = "P(C=#{i})=#{'%.3f' % klass[:prob]}"
      @attrs.each do |attr|
        [0,1].each do |j|
          str += " P(#{attr[0]}=#{j}|C=#{i})=#{'%.3f' % klass[:attrs][attr[0]][j]}"
        end
      end
      puts str
    end
  end

end
