---
title: The yaml document from hell
date: 2023-01-02
minutes: ?
synopsis: As a data format, YAML is an extremely complicated and has many footguns. In this post I explain some of those pitfalls by means of an example.
run-in: For a data format, YAML is extremely complicated.
---

For a data format, YAML is extremely complicated.
It aims to be a more human-friendly alternative to json,
but in striving for that it introduces so much complexity,
that I would argue it achieves the opposite result.
Yaml is full of footguns and its friendliness is deceptive.
In this post I want to explain this through an example.

Yaml is really, really complex
------------------------------

Json is simple.
[The entire json spec][json-spec] consists of six railroad diagrams.
It’s a simple data format with a simple syntax and that’s all there is to it.
Yaml on the other hand, is complex.
So complex,
that [its specification][yaml-spec] consists of _10 chapters_
with sections numbered four levels deeps,
and a dedicated [errata page][yaml-errata].

The json spec is not versioned.
There were [two changes][json-change] to it in 2005
(the removal of comments, and the addition of scientific notation for numbers),
but it has been frozen since
— almost two decades now.
The yaml spec on the other hand is versioned.
The latest revision, 1.2.2 from October 2021,
merely provides clarification over 1.2.1.
But yaml 1.2 differs substantially from 1.1:
the same document can parse differently under different yaml versions.
We will see an example of this later.

Json is so obvious that
Douglas Crockford claims [to have discovered it][json-saga] — not invented.
I couldn’t find any reference for how long it took him to write up the spec,
but it was probably hours rather than weeks.
The change from yaml 1.2.1 to 1.2.2 on the other hand,
was [a multi-year effort by a team of experts][yaml-122-blog]:

> This revision is the result of years of work
> by the new YAML language development team.
> Each person on this team has a deep knowledge of the language
> and has written and maintains important open source YAML frameworks and tools.

Furthermore this team plans to actively evolve yaml, rather than to freeze it.

Now, when you work with format this complex,
it is extremely difficult to know how it will behave.

[json-spec]:     https://www.json.org/json-en.html
[yaml-spec]:     https://yaml.org/spec/1.2.2/
[yaml-errata]:   https://yaml.org/spec/1.2/errata.html
[json-saga]:     https://www.youtube.com/watch?v=-C-JoyNuQJs
[json-change]:   https://youtu.be/-C-JoyNuQJs?t=965
[yaml-122-blog]: https://yaml.com/blog/2021-10/new-yaml-spec/

<!--
This is the last version without scientific notation, 2005-07-21:
https://web.archive.org/web/20050721035358/http://www.crockford.com:80/JSON/index.html

This is the first version to feature scientific notation, 2005-07-24:
https://web.archive.org/web/20050724003319/http://www.crockford.com:80/JSON/index.html

This is the last version to feature comments, 2005-08-11:
https://web.archive.org/web/20050811233342/http://www.crockford.com:80/JSON/index.html

This is the first version to no longer feature comments, 2005-08-23:
https://web.archive.org/web/20050823002712/http://www.crockford.com:80/JSON/index.html
-->

The YAML document from hell
---------------------------

Consider the following document.

```yaml
loadbalancer_config:
  port_mapping:
    # Expose only ssh and http to the public internet.
    - 22:22
    - 80:80
    - 443:443

  serve:
    - /robots.txt
    - /favicon.ico
    - *.html
    - *.png
    - !.git  # Do not expose our Git repository to the entire world.

  geoblock_regions:
    # The legal team has not approved distribution in the Nordics yet.
    - dk
    - fi
    - is
    - no
    - se
```

The YAML spec
-------------
From [section 1.1 of the YAML spec][spec1.1],
its goals are, in order of decreasing priority:

 1. To be easily readable by humans.
 7. To be easy to implement and use.

In other words, YAML is explicitly not designed to be easy to use.

[spec1.1]: https://yaml.org/spec/1.2.2/#11-goals

Templating YAML
---------------
Don’t. It’s impossible. Generate JSON instead.

Alternatives
------------

 * Json.
 * TOML.
 * Hujson.
 * Nix.
 * Honorable mention: Cue, Dhall, maybe HCL.

Conclusion
----------

TODO.