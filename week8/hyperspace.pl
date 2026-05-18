% hyperspace.pl
% In-Class Activity 4 starter file.
%
% A network of bidirectional hyperspace routes between planets.
% A route(A, B) fact means there is a direct route between A and B
% (and, by your connected/2 rule, also between B and A).

route(earth,              magrathea).
route(earth,              ursa_minor_beta).
route(earth,              viltvodle_vi).
route(magrathea,          sqornshellous_zeta).
route(magrathea,          betelgeuse).
route(betelgeuse,         ursa_minor_beta).
route(betelgeuse,         vogsphere).
route(ursa_minor_beta,    frogstar_b).
route(sqornshellous_zeta, frogstar_b).
route(frogstar_b,         damogran).
route(damogran,           krikkit).
route(krikkit,            vogsphere).
route(vogsphere,          viltvodle_vi).
route(krikkit,            santraginus_v).
route(santraginus_v,      damogran).

% =====================================================
% Define your rules below this line.
% =====================================================

% connected(A, B)
connected(A, B) :- route(A, B).
connected(A, B) :- route(B, A).

% path_helper(Start, End, Path, Visited)
path_helper(End, End, [End], _).
path_helper(Start, End, [Start | Path], Visited) :- connected(Start, Next), \+ member(Next, Visited), path_helper(Next, End, Path, [Start | Visited]).

% path(Start, End, Path)
% (use a helper predicate with a visited-list accumulator)
path(Start, End, Path) :- path_helper(Start, End, Path, []).

% reachable(Start, End)
reachable(Start, End) :- path(Start, End, _).

% shortest_path(Start, End, Path)
shortest_path(Start, End, Path) :- findall(L-P, (path(Start, End, P), length(P, L)), Pairs), keysort(Pairs, [_-Path|_]).