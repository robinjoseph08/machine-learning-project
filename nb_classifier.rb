require "classifier"

class NaiveBayesClassifier < Classifier

  # classifier constructor
  def initialize attrs
    @attrs   = attrs
    @classes = [{},{}]
  end

  # method used to train the classifier
  def train data
    split_data = []

    [0,1].each do |i|
      # separate the true data from false data
      split_data[i] = data.select do |line|
        line.last == i
      end

      # get the probability of the class
      @classes[i][:prob] = split_data[i].length.to_f/data.length

      # get the probability of each attribute given a certain class
      @classes[i][:attrs] = []
      @attrs.each_with_index do |attr, j|
        @classes[i][:attrs][j] = []
        # determine probability based on if it's continuous or discrete
        if attr[:type] == :cont
        else
          attr[:values].each do |k|
            @classes[i][:attrs][j][k] = counter(j, k, split_data[i]).to_f/split_data[i].length
          end
        end
      end
    end
  end

  # PRIVATE METHODS

  private

  # reset the classifier
  def reset
    @classes = [{},{}]
  end

  # count the number of rows of a given data set where a certain index is a certain value
  def counter index, value, data
    data.inject(0) do |total, line|
      line[index] == value ? total + 1 : total
    end
  end

  # given an array of attribute values, use the Naive Bayes Algorithm to classify the data
  def classify line
    probs = [@classes[0][:prob], @classes[1][:prob]]

    @classes.each_with_index do |klass, i|
      @attrs.each_with_index do |attr, j|
        if attr[:type] == :cont
        else
          probs[i] *= klass[:attrs][j][line[j]]
        end
      end
    end

    probs[0] > probs[1] ? 0 : 1
  end

end
