---
title: Git music
date: 2013-07-20
lang: en-GB
synopsis: I cross-referenced my Git commit history with my Last.fm scrobbles.
run-in: A while ago
---

A while ago I wondered: would there be a correlation between the music I
listen to, and the code I write? Do my listening habbits while
programming differ from my regular listening habbits? Am I more
productive while listening to a certain artist?

This should be easy enough to find out: Git knows when I have been
programming, and [Last.fm](http://last.fm) knows which tracks I have
been listening to. All that was left to do, was cross-reference the
data.

GitScrobbler
------------

The next day, I hacked together
[GitScrobbler](https://github.com/ruuda/gitscrobbler). It is a
simple command-line program to which you pipe formatted `git log`
output. It then retrieves the track that you listened to at the moment
of the commit, using the Last.fm API. (An API-key is required to use the
program.) When a commit is matched with a track, it prints the commit
message along with the track title and artist. At the end, it prints
some statistics like your top ten artists and the tracks most often
committed to.

For me, the results were not as exciting as I had hoped. My top artists
looked very much like my regular top artists (to within statistical
fluctuations), but there definitely are a few tracks that I commit to
more often than other tracks. The rest of the list again matched my
regular listening habbits pretty well.

