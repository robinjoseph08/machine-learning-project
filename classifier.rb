class Classifier

  # cross validation training/testing
  def cv_train data
    correct = 0

    data.count.times do |index_to_test|
      puts "CV PERCENT DONE: #{'%.2f' % ((index_to_test * 100.0)/data.count)}%" if index_to_test % 1000 == 0

      tester = data[index_to_test]
      rest   = data.clone
      rest.delete tester

      # reset the classifier
      reset

      # train it based on the data without the testing point
      train rest

      # accumulate the number of correct testing sets
      correct += test [tester]
    end

    correct
  end

  # method used to test the classifier
  def test data
    total = data.length
    # used to count the number of correctly classified sets
    correct = 0

    data.each do |line|
      correct += line.last == classify(line[0...-1]) ? 1 : 0
    end

    correct
  end

end
