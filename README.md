# BitSub

A extremely minimal RSS feed subscriber, written for automatic torrent adding.
BitSub does not download anything for you (except the RSS feeds), it simply
downloads feeds, filters results, and outputs the results in an extremely
configurable way.

## Installation
```
$ gem install bitsub
```

## Usage

You need a `profile.rb` that will tell bitsub how to run.  An example profile
is located at `examples/profile.rb`
