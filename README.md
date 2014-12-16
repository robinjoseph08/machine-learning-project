# Machine Learning Project

## Team Members

* Robin Joseph
* Oscar Paramo

## Developed On

* Mac OS X 10.10
* `ruby 2.1.2p95`

## Purpose

* **Without a test file** &mdash; This will apply leave-one-out cross-validation against the training data.

* **With a test file without labels** &mdash; This will train the classifier with the training data and then attempt to correctly classify the test instances. For each test instance, it will output to `STDOUT` either a `0` or a `1` on its own line.

* **With a test file with labels** &mdash; This will train the classifier with the training data and then test the accuracy of the classifier with the given test data.

## How To Run

In general:

`$ ruby main.rb <TRAINING_FILE> <ATTRIBUTE_FILE> [<TEST_FILE> [--with-labels]]`

Examples:

`$ ruby main.rb input/train.txt input/attr.txt`
`$ ruby main.rb input/train.txt input/attr.txt prelim/without_labels.txt`
`$ ruby main.rb input/train.txt input/attr.txt prelim/with_labels.txt --with-labels`
