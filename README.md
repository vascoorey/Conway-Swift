Conway-Swift
============

Conway's Game of Life in Swift

Performance
===========

Time taken for 1 tick.

Results for a 5000x5000 grid with a generator pattern.

* No optimizations: 161.2 seconds
* Fast (-O): 8.9 seconds
* Fast, unchecked (-Ofast): 2.2 seconds

1000x1000 grid with a generator pattern.

* No optimizations: 6.6 seconds
* Fast (-O): 0.4 seconds
* Fast, unchecked (-Ofast): 0.1 seconds
