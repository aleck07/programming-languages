Author: Alec Krsek

Date: 05/12/2026

## Description
The `songgen.erl` program takes in lines from tracks.txt, clean/trim the title, and run it through a bigram algorith to genereate new song title names.
- `extract_title` Takes a line and returns just the song title without any other data.
- `remove_superfluous` Returns title without superfluous elements.
- `remove_punctuation` Returns the title without punctuation.
- `remove_non_engligh` Removes any non-English characters.
- `preprocess` Extracts title, removes superfluous, punctuation, and non-english.
- `build_bigrams` Builds the bigram map and returns it.
- `add_bigramns` Recursive helper, to create bigram.
- `next_word` Returns the next word based from a given bigram.
- `generate_title` Returns the title from the given bigram map and seed.
- `gen_words` Recursive helper, generates the words by the most used bigram in the map for generate title.


## Citations
`remove_superfluous` and `remove_punctuation`: 
- https://stackoverflow.com/questions/6208367/regex-to-match-stuff-between-parentheses
- https://learnxbyexample.com/erlang/regular-expressions/ 
- regex101 helped a lot for creating regex patterns.
    - I had had trouble with the getting the feat. working propery, I asked Claude for a table of patterns to matches. (The three leading back-slashes to escape a black-slash is weird).
- I had a problem on removing punctuation properly and ended up getting garbage out. This video pointed me in the right direction by adding the global flag. https://www.youtube.com/watch?v=sXQxhojSdZM

`generate_title` was hard. A reply in this thread helped me with getting the binary elements into one. https://stackoverflow.com/questions/33645336/whats-the-difference-between-list-to-binary-and-iolist-to-binary

`build_bigrams`. Sicne we were working with maps I knew I had to go with maps. Used the erlang documentation: https://www.erlang.org/docs/23/man/maps. I started writing down a helper function `add_bigrams` and Claude helped with proper recursion because I would again get garabage out when testing. Usually most things would work but sometimes would get empty elements.

With `next_word`, I asked Claude to explain how I properly sort the the list and it gave me that that `Sorted = ...` line with the that sorting anonymous function.