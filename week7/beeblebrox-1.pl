% beeblebrox.pl
% In-Class Activity 3 starter file.
%
% The (entirely fictional) ancestry of Zaphod Beeblebrox,
% two-headed President of the Galaxy.
%
% parent(Parent, Child) -- Parent is a parent of Child.

% --- Generation 1 (great-great-grandparents) ---
parent(zarniwoop_sr,   zarniwoop).
parent(beeblebrox_i,   beeblebrox_ii).
parent(beeblebrox_i,   yooden).
parent(jeltz_sr,       prostetnic).

% --- Generation 2 (great-grandparents) ---
parent(zarniwoop,      hotblack).
parent(beeblebrox_ii,  beeblebrox_iii).
parent(beeblebrox_ii,  gag).
parent(yooden,         halfrunt).
parent(prostetnic,     kwaltz).

% --- Generation 3 (grandparents) ---
parent(hotblack,       zaphod_sr).
parent(beeblebrox_iii, eccentrica).
parent(gag,            ford_sr).
parent(halfrunt,       trillian_sr).
parent(kwaltz,         marvin_sr).

% --- Generation 4 (parents) ---
parent(zaphod_sr,      zaphod).
parent(zaphod_sr,      ford).
parent(eccentrica,     zaphod).
parent(eccentrica,     ford).
parent(ford_sr,        trillian).
parent(trillian_sr,    trillian).
parent(marvin_sr,      marvin).

% --- Generation 5 (children) ---
parent(zaphod,         random).
parent(trillian,       random).
parent(ford,           lintilla).

% =====================================================
% Define your rules below this line.
% =====================================================

% child(Child, Parent).
child(C, P) :- parent(P, C).

% grandparent(GP, GC).
grandparent(GP, GC) :- parent(GP, GPC), parent(GPC, GC).

% sibling(A, B)
sibling(A, B) :- parent(P, A), parent(P, B).

% ancestor(Anc, Desc)
ancestor(A, D) :- parent(A, D).
ancestor(A, D) :- parent(A, X), ancestor(X, D).

% descendants(Person, List)
descendants(P, L) :- findall(D, ancestor(P, D), L).
