Author: Alec Krsek
Date: 04/23/16

## Description

The `stack.erl` is a basic implementation of a stack in erl. All functions return a new stack, not modify the existing stack. It supports the following functions:
- `new(List)`: Converts an Erlang list into a stack set up as a tuple chain.
- `push(Stack, Value)`: Appends value to top of stack.
- `pop(Stack)`: Removes top most value and returns the value.
- `get(Stack, I)`: Returns the $I^{th}$ element.
- `set(Stack, I, Value)`: Sets the $I^{th}$ element in the stack to the value.
- `remove(Stack, I)`: Removes the $I^{th}$ element and returns {RemovedValue, NewStack}.
- `print_td(Stack)`: Prints the items in the stack from top to bottom.
- `print_bu(Stack)`: Prints the items in the stack from bottom to top.

## Terminal output
```
Get value at index 2: ashley
Top down:
kameron
austin
dalton
tristan
daniel
Bottom up:
daniel
tristan
dalton
austin
kameron
```

## Citations

For the get, set, and remove helper functions I had Claude explain how to get helper stack accumulator properly set up.