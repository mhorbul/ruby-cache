=begin

= Ruby/Cache Reference Manual

This is the reference manual for
((<"Ruby/Cache"|URL:http://www.nongnu.org/pupa/ruby-cache.html>)) version 0.2.

Ruby/Cache provides a class for caching arbitrary objects based on LRU
algorithm. The class (({Cache})) looks like a variant of (({Hash})), and,
in fact, (({Cache})) supports most of the methods of (({Hash})).

To control how to invalidate excessive objects, Ruby/Cache allows you to
adjust the limit by four factors: the size of an object, the total size
of objects, the number of objects, and a last access time.

== Class:

Cache

== Superclass:

Object

== Included module:

Enumerable

== Class methods:

--- Cache.version
    Return the version number.

--- Cache.new([max_obj_size, max_size, max_num, expiration, &hook])
    Create a new Cache object.
    
    ((|max_obj_size|)) is the maximum size per object allowed to be cached.
    The size is currently determined by (({obj.to_s.size})).
    
    ((|max_size|)) is the maximum size of all objects allowed to be cached.
    The size is currently determined by the sum of the sizes of all objects.
    
    ((|max_num|)) is the maximum number of cached objects.
    
    ((|expiration|)) is the maximum life time of each object after the last
    access time, and is specified by seconds.
    
    ((|hook|)) is called whenever an object is invalidated, in the form
    (({hook(key, value)})). So you can use ((|hook|)) for cleanups.

== Methods:

--- max_obj_size
    Return the maximum size per object.

--- max_size
    Return the maximum size of all objects.

--- max_num
    Return the maximum number of objects.

--- expiration
    Return the maximum life time.

--- cached?(key)
--- include?(key)
--- member?(key)
--- key?(key)
--- has_key?(key)
    Return (({true})), if the key ((|key|)) is cached.

--- cached_value?(val)
--- has_value?(val)
--- value?(val)
    Return (({true})), if the value ((|val|)) is cached.

--- index(val)
    Return the key corresponding to the value ((|val|)), if any. Otherwise
    return (({nil})).

--- keys
    Return an array of keys.

--- values
    Return an array of cached objects.

--- length
--- size
    Return the number of cached objects.

--- to_hash
    Return keys and cached objects as a Hash object.

--- invalidate(key)
--- invalidate(key) {|key| ... }
--- delete(key)
--- delete(key) {|key| ... }
    Invalidate a cached object indexed by the key ((|key|)), and return
    the object. If the key isn't present, return (({nil})). If a block
    is given and the key is invalid, evaluate the block and return the
    result.

--- invalidate_all
--- clear
    Invalidate all cached objects.

--- expire
    Invalidate expired objects. This method is often called from other methods
    automatically, so you wouldn't have to call it explicitly.

--- self[key]
    Return a cached object corresponding to the key ((|key|)). If the key
    isn't found, return (({nil})).

--- self[key]=value
--- store(key, value)
    Cache the object ((|value|)) with the key ((|key|)), if possible.
    Return ((|value|)).

--- each_pair {|key, obj| ... }
--- each {|key, obj| ... }
    Evaluate the block with each key and a cached object corresponding to
    the key.

--- each_key {|key| ... }
    Evaluate the block with each key.

--- each_value {|obj| ... }
    Evaluate the block with each cached object.

--- empty?
    Return (({true})), if no object is cached.

--- fetch(key[, default])
--- fetch(key) {|key| ... }
    Return a cached object corresponding to the key ((|key|)).
    If the key isn't found and ((|default|)) is given, cache ((|default|))
    as a object corresponding to ((|key|)) and return ((|default|)).
    Or, if the key isn't found and a block is given, evaluate the block
    with ((|key|)), cache the result, and return it.
    
    Normally, you should use this method rather than (({self[key]})) plus
    (({self[key]=value})), because this is safer.

--- statistics
    Return an array of the total size of cached objects, the number of
    cached objects, the number of cache hits, and the number of cache
    misses.

=end
