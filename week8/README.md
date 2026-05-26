Author: Alec Krsek
Date: 5/25/2026

## Description
This Prolog program implements a network of bidirectional hyperspace routes between planets. A `route(A, B)` fact means that there 
- `connected(A, B)`: Returns true if planets A and B are connected (bidirectional).
- `path(Start, End, Path)`: Instantiates Path variable with a path from Start to End.
- `reachable(Start, End)`: Returns true if the start planet can travel to the end planet.
- `shortest_path(Start, End, Path)`: Instantiates Path variable with the shortest path from start to end.

## Example
```
?- connected(earth, magrathea).
true.

?- connected(magrathea, earth).
true.

?- reachable(earth, damogran).
true.

?- path(earth, krikkit, Path).
Path = [earth, magrathea, sqornshellous_zeta, frogstar_b, damogran, krikkit] ;
...

?- shortest_path(earth, krikkit, Path).
Path = [earth, viltvodle_vi, vogsphere, krikkit] .

?- shortest_path(earth, santraginus_v, Path).
Path = [earth, ursa_minor_beta, frogstar_b, damogran, santraginus_v] .

```

## Citations
No other sources were used and no AI was used.