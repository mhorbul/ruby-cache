=begin
= Ruby/Cache 0.2
== What is Ruby/Cache

Ruby/Cache is a library for caching objects based on the LRU algorithm
for Ruby. The official page is
((<URL:http://www.nongnu.org/pupa/ruby-cache.html>)).

== How to install

(1) $ ruby install.rb config
(2) $ ruby install.rb setup
(3) $ ruby install.rb install

== How to use

Here is a simple usage:

 require 'cache'

 cache = Cache.new
 cache['foo'] = 'bar'
 p cache['foo']
 cache.invalidate('foo')
 p cache['foo']

 =>

 "bar"
 nil

This is a more complicated example:

 # Set the maximum number of cached objects and the expiration time to
 # 100 and 60 (secs), respectively.
 cache = Cache.new(nil, nil, 100, 60)
 puts 'I will generate a prime number greater than any given number!'
 while true
   puts 'Input an integer: '
   i = gets.to_i
   puts cache.fetch(i) { generate_prime_greater_than(i) }
 end

== License

You may redistribute it and/or modify it under the same term as Ruby's.

== Author

((<Yoshinori K. Okuji|URL:http://www.enbug.org/>))
((<<okuji@enbug.org>|URL:mailto:okuji@enbug.org>))

=end
