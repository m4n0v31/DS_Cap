Word Prediction Algorithm
========================================================
author: m4n0v31
date: 2016-01-12

***Presentation of my Shiny App***

Background and Data Cleaning
========================================================

The task was to build an application capable of predicting the next word given an input sentence. To achive this, a model had to be built based on some source data provided (twitter, news and blogs).

The first operations on the data were:
- perform basic cleaning of the data;
- divide the data into sentences;
- randomly sample the sentences to create train, test and validation sets.

n-grams and size reduction
========================================================

Next, the training set obtained through sampling was used to:
- collect uni-grams, bi-grams, tri-grams and quad-grams;
- compute a term frequency table for each n-gram collection;

To improve speed the n-gram collections were processed as follows:
- Uni-grams reducted to the words necessary to have a coverage of 95% of the sampled text.
- Bi-grams were stripped of those using words not appearing in the reduced uni-grams.
- Tri-grams and quad-grams were stripped of those having frequency equal to 1.

The Model
========================================================

The model used for the prediction is based on *"A Generalized Language Model as the Combination of Skipped n-grams and Modified Kneser-Ney Smoothing" [[1]](https://aclweb.org/anthology/P/P14/P14-1108.pdf)*. 

This model allows for:
- Interpolation with lower order models in which the first word in the local context is omitted;
- Interpolation with lower order models in which other words (not the first) are skipped;
- Combination of this idea with modified Kneser-Ney smoothing.

Refer to the publication for details.

The App
========================================================

The Shiny app can be found [here](http://TBD.com). 

The app:
- allows the user to input a sentence,
- provides a "predict" button to start the computation,
- after the computation provides an auto-completed sentence and the prediction of the three "most likely" words to follow the text.

The goal of the application was: reduced size with fast performance in prediction with relatively good accuracy.


