-module(songgen) .
-export([extract_title/1, remove_superfluous/1, remove_punctuation/1, remove_non_english/1, preprocess/1]).
-export([build_bigrams/1, next_word/2, generate_title/3]).

