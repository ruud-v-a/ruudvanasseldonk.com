---
title: An algorithm for shuffling playlists
date: 2023-05-27
minutes: ?
synopsis: TODO
run-in: It is a common observation
---
define(`_abbr', `<abbr>$1</abbr>')
define(`_var', `<var>$1</var>')
define(`aA', `_abbr(A)')
define(`aB', `_abbr(B)')
define(`aC', `_abbr(C)')
define(`v_b', `_var(b)')
define(`v_k', `_var(k)')
define(`v_n', `_var(n)')
define(`v_m', `_var(m)')
define(`v_s', `_var(s)')
define(`v_x', `_var(x)')
define(`v_xp', `_var(x''`)')
define(`v_y', `_var(y)')
define(`v_yp', `_var(y''`)')

It is a common observation
that for shuffling playlists,
humans don’t want an _actual_ shuffle,
because that might play the same artist twice in a row,
which doesn’t feel random.
This topic has been discussed by others,
including famously [by Spotify][spotify],
which in turn references [Martin Fiedler’s algorithm][martin].
However, neither algorithm is optimal,
in the sense that they might play an artist consecutively
in cases where this was possible to avoid.
I’ve been thinking about this for [Musium][musium],
the music player that I am building.
In this post I want to outline an algorithm that is optimal in the above sense.

[martin]: https://keyj.emphy.de/balanced-shuffle/
[spotify]: https://engineering.atspotify.com/2014/02/how-to-shuffle-songs/
[musium]: https://github.com/ruuda/musium

Notation
--------
In this post a playlist is an ordered list of tracks.
For example,
AAABBC is a playlist with six tracks:
three by artist aA,
then two by artist aB,
and then one by artist aC.
The shuffling algorithm returns a permutation of this list;
it specifies the order of the artists.
At this point we treat tracks by the same artist as indistinguishable.
We’ll address that later.

Interleaving two artists
------------------------
Suppose we have tracks from just two artists, aA and aB,
where aA has more tracks than aB.
Then we can divide aA’s tracks into equally sized groups,
and insert aB’s tracks in between them.
This way we never play aB consecutively,
we break up as many of aA’s consecutive plays as we can,
and we minimize the longest span of aA’s in a row.

Let state that formally.
We are going to optimally shuffle a playlist with two artists,
aA with v_n tracks,
and aB with v_m tracks:

1. Partition on artist,
   so we have list v_x of length v_n
   and list v_y of length v_m,
   with v_n ≥ v_m.
2. Split v_x into v_m + 1 equal parts.
   If v_m + 1 does not divide v_n,
   the parts that get one more element can be selected randomly.
4. Interleave the v_m + 1 parts of v_x with v_y’s elements.
   If v_m = v_n,
   we just interleave the two lists
   (we can split v_x into at most v_m parts),
   but we can flip a coin about which list goes first.

The resulting permutation is optimal in the following sense:

 * Artist aB will have no consecutive tracks,
   and if possible aA will not either.
 * More generally, for any positive integer v_k,
   the number of occurrences of v_k consecutive tracks
   by the same artist is minimal.

We can apply this interleaving more generally,
we don’t need to limit ourselves to inputs v_x and v_y
that consist of only one artist each.
The procedure can interleave any two lists v_x and v_y.
We will need this later,
so let’s call the procedure <code>interleave</code>.
It interleaves the smaller list into the larger one.

Multiple artists
----------------
Now that we can shuffle two artists,
we can extend the idea to more artists.
Let’s look at an example first.
Say we have four tracks by artist aA,
two by aB, and one by aC.
Then the three optimal shuffles are ABABACA, ABACABA, and ACABABA.
Between aB and aC we have some freedom,
but we need all the aB’s and aC’s
together to go in between the aA’s.
What we did here
is to first interleave aB and aC,
and then we interleaved the result with aA.

A promising approach then,
is to incrementally build up the result from an empty list.
At every step,
we interleave an artist with the least number of tracks with the result,
until we incorporated all artists.
This works well in most cases,
and I originally thought that this algorithm would produce optimal shuffles.
However,
when I set out to prove that,
I discovered a counterexample.

Take 4 tracks of artist aA,
8 tracks of aB,
and 10 tracks of aC.
If we interleave aA and aB first,
then aA partitions the aB’s into five groups,
three of size two, and two of size one.
For example,
BB-aA-BB-aA-BB-aA-aB-aA-aB.
This list has length 12,
so next we interleave the aC’s into it,
but the 10 aC’s are not quite enough to only create groups of size 1,
there will be one group of size 2,
and it might contain a BB.
We _do_ have enough aC’s to break up all the occurences of BB,
but we need to be more careful about where we use them.
It turns out that this example has this property
no matter which two artists we interleave first.
Incremental use of <code>interleave</code> does not guarantee optimal shuffles.

If we have an already shuffled list of v_n tracks
and we want to merge in v_m more tracks by a new artist not in the list,
then if v_n ≥ v_m,
we can do this without creating consecutive tracks by the same artist.
In other words,
when we consider a new artist with v_m tracks,
we should try to have an already-shuffled list of at least v_m - 1 tracks.

Putting things together,
we get the following incremental algorithm:

1. Partition on artist, shuffle the partitions internally.
2. Initialize the intermediate result to an empty list.
3. While there are partitions left,
   interleave the smallest partition into the intermediate result as follows:
   When the intermediate list is smaller than the new partition,
   to do as in previous section.
   Otherwise,
   let the length of the longer list be v_n,
   and the length of the shorter list v_m.
   Break the longer list into spans
   such that no span contains the same symbol twice in a row.
   (It is not obvious that this is always possible,
   but as we will see in the proof,
   it is.)
   Then break the remaining spans up further
   (select them randomly)
   until we have v_m + 1 spans,
   and interleave those spans with the v_m elements of the shorter list.

The intuition behind this is that
by interleaving the smallest partitions first,
we ensure that by the time we get to a larger partition,
we have enough tracks to interleave it with.
If at some point we produced consecutive tracks in the intermediate list,
then interleaving it into a larger partition
will break up the consecutive tracks.

Could it happen that we end up with consecutive tracks in the intermediate list,
— let’s say BBCB —
but the next partition is smaller than the intermediate list
— let’s say AA —
so it gets interleaved into the intermediate list
instead of the other way around,
and not all consecutive tracks get broken up?
It turns out this cannot happen,
but this is not so obvious,
we will prove it in the next section.
In the example,
we should have interleaved AA and aC first because those are the smaller partitions,
and then interleaving with BBB works out fine.

Appendix: Optimality proof
--------------------------
Let’s first formalize what we are trying to prove.

**Definition**:
For a positive integer v_k,
the <em>v_k-badness</em> of a playlist
is the number of times that
the same artist occurs v_k times in a row.
For example, the 2-badness of AAABBC is 3:
AA occurs at index 0 and 1,
and BB occurs at index 3.

**Definition**:
Let v_x and v_y be permutations of the same playlist.
We say that a v_x is _better_ than v_y,
if for every positive integer v_k,
v_x has a lower v_k-badness than v_y.
This defines a partial order on playlists.
Note that this is not a total order!
For example,
AAACAACAACAAC has a lower 3-badness than
AAACAAACACACA, but a higher 2-badness.

**Definition**:
A permutation of a playlist is called an _optimal shuffle_,
if there exists no better permutation.
For example,
AAABB is not an optimal shuffle,
because its permutation ABBAA has a 2-badness of 2,
lower than AAABB’s 2-badness of 3,
and it also has a lower 3-badness.
An example of a shuffle that _is_ optimal is AABA.
It has a 2-badness of 1,
and of its four permutations (BAAA, ABAA, AABA, and AAAB),
none achieve a lower 2-badness.

**Theorem**:
The algorithm described in the previous section returns optimal shuffles.<br>
_Proof_:
The proof will be by induction on the number of artists v_s.

**Base case**:
For v_s = 2,
say we have v_n times artist aA,
and v_m ≤ v_n times artist aB.
When v_m = v_n we interleave the two
and the result has a v_k-badness of zero for every v_k ≥ 2,
which is optimal.
Assume therefore that v_m < v_n.
Then we break up the list of aA’s into spans of size
v_k = ⌈v_n / (v_m + 1)⌉ and possibly of size v_k - 1.
It is not possible to build a permutation with lower v_k-badness
without breaking the list into more than v_m spans,
so the permutation is optimal.

**Induction step**:
Let the number of artists v_s be given.
Assume that for fewer than v_s artists,
our algorithm produces optimal shuffles.
Say we have v_n times the artist aA,
and v_m times a different artist (not necessarily all distinct).
Assume that no other artist occurs more than v_n times.
Let v_x be
an optimal shuffle of the v_m artists other than aA.
We can distinguish three cases,
of which the first two are easy to treat:

1. When v_n > v_m,
   we can interleave the other symbols between the aA’s
   in the same manner as in the base case.
   Badness due to symbols from v_x
   is zero for all v_k ≥ 2,
   so the resulting permutation is optimal for the same reason as in the base case.
2. When v_n = v_m
   we can interleave aA’s with other symbols.
   The result has a v_k-badness of zero for all v_k ≥ 2,
   which is optimal.

The interesting case is v_n < v_m.
This time there is no badness due to aA,
so the badness of the result is at most the badness of v_x.
Let v_xp be the output of our algorithm,
starting with v_x as its intermediate result.
We have to show that v_xp is optimal.
Suppose that v_yp is a better permutation than v_xp.
Note that in v_yp,
there are no consecutive occurences of aA.
If there were,
we could build a better permutation by taking a symbol
from a span of non-aA symbols
and using it to break up two aA’s.
A span of non-aA symbols of length at least two exists,
because with at most v_n - 1 spans of aA’s,
the aA’s break the remaining v_m symbols into at most v_n spans.

Define v_y to be v_yp with the aA symbols removed.
Note that v_y is a permutation of v_x,
and that the v_n aA’s in v_yp break v_y into v_n + 1 parts.
Let v_b be the 2-badness of v_yp.
The 2-badness of v_y can be at most v_b + v_n,
because removing an aA can create at most one new occurrence of two consecutive symbols.

We also saw already that for every v_k,
the v_k-badness of v_yp is at most that of v_y,
and the v_k badness of v_xp is at most that of v_x.

Todo
----
I found a counterexample.
Take A = 4, B = 8, C = 10.
After step 1 we will have e.g.
BBA BBA BBA BAB

We need to divide those 12 symbols into 11 groups,
so we get 10 groups of size 1,
and one group of size 2.
But that group _could_ be chosen to include a BB. Bad!
Note, it _is_ possible to pick optimally.
But my algorithm is not guaranteed to do this.

Note
----
Note, for two artists, Spotify’s algorithm works well.
But they merge in one go instead of merging pairwise,
which creates the problem.
