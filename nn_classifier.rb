require "classifier"

class NearestNeighborClassifier < Classifier

  # classifier constructor
  def initialize attrs, k
    @attrs = attrs
    @k     = k
    @data  = nil
  end

  # method used to train the classifier
  def train data
    @data = data
  end

  # PRIVATE METHODS

  private

  # reset the classifier
  def reset
    @data = nil
  end

  # Euclidean distance function
  def dist set1, set2
    Math.sqrt(set1.zip(set2).map { |x| (x[1] - x[0])**2 }.reduce(:+))
  end

  # given an array of attribute values, use the k-NN Algorithm to classify the data
  def classify line
    dists = @data.map do |l|
      {
        :dist  => dist(l[0...-1], line),
        :class => l.last
      }
    end

    dists = dists.sort_by do |l|
      l[:dist]
    end

    neighbors = dists[0...@k]

    neg = neighbors.select do |n|
      n[:class] == 0
    end.count
    pos = @k - neg

    pos > neg ? 1 : 0
  end

end
