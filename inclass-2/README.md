Author: Alec Krsek
Date: 04/27/26

## Description
The `dice.erl` 
- `roll_frequencies(Rolls)`: Takes a list of dice rolls and returns a map of each face to how many times it was rolled.
- `pair_frequencies(Rolls)`: Takes a list of rolls and returns a nested map tracking how often each face is followed by each other face.
- `most_common(Freqs)`: Takes a frequency map and returns the key with the highest count as `{Key, Count}`.

## Terminal output
```
1 was rolled 164 times
2 was rolled 175 times
3 was rolled 167 times
4 was rolled 168 times
5 was rolled 163 times
6 was rolled 163 times
1, most common next roll is 1 (31 times)
2, most common next roll is 1 (36 times)
3, most common next roll is 6 (31 times)
4, most common next roll is 2 (35 times)
5, most common next roll is 5 (36 times)
6, most common next roll is 1 (30 times)
```

## Citations
Claude helped explain how some functions should work and guided me with how some library functions work such as `foldl`.