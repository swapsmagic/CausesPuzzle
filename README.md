Problem Statement:
==================
Two words are friends if they have a [Levenshtein distance](http://en.wikipedia.org/wiki/Levenshtein_distance) of 1. That is, you can add, remove, or substitute exactly one letter in word X to create word Y. A word’s social network consists of all of its friends, plus all of their friends, and all of their friends’ friends, and so on. Write a program to tell us how big the social network for the word “causes” is, using [this word list](https://github.com/causes/puzzles/raw/master/word_friends/word.list).
My Solution:
------------
* Pick one word at time and insert into the social graph data strucutre
* For every word, check if any previous words has length similar or of one difference than the existing word
* If found such words, compare Levenshtein distance threshold K (here 1) using technique provide in improvement section in wikipedia article
	If we are only interested in the distance if it is smaller than a threshold k, then it suffices to compute a diagonal stripe of width 2k+1 in the matrix. In this way, the algorithm can be run in O(kl) time, where l is the length of the shortest string.
* If distance is 1, then add those words as neighbour of the current word using neighbourHash
* Add current word in bucket which has similar word length.
* Also keep a hash of word and it's index link in the list of words that we have added in the graph
* Keep doing it for all words to generate the graph
* Ask for user input for the work to be searched
* Look for that word in hash, if it's present pick it's index and fetch the word object from list array
* Once word found, fetch it's all neighbour from the neighbourHash
* Add all the neighbour in a queue and use BFS algo to iterate to all of their friends and their friends and so on untill the whole network is explored.
HOW TO RUN:
-------------
perl SocialNetwork.pl