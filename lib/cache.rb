#! /usr/bin/env ruby
#
# Copyright (C) 2002  Yoshinori K. Okuji <okuji@enbug.org>
#
# You may redistribute it and/or modify it under the same term as Ruby.

# Cache manager based on the LRU algorithm.
class Cache

  CACHE_OBJECT = Struct.new('CacheObject', :content, :size, :atime)
  CACHE_VERSION = '0.1'
  
  def self.version
    CACHE_VERSION
  end
  
  def initialize(max_obj_size = nil, max_size = nil, max_num = nil,
		 expiration = nil, hook = nil)
    if max_obj_size and max_size and max_obj_size > max_size
      raise ArgumentError, "max_obj_size exceeds max_size (#{max_obj_size} > #{max_size})"
    end
    if max_obj_size and max_obj_size <= 0
      raise ArgumentError, "invalid max_obj_size `#{max_obj_size}'"
    end
    if max_size and max_size <= 0
      raise ArgumentError, "invalid max_size `#{max_size}'"
    end
    if max_num and max_num <= 0
      raise ArgumentError, "invalid max_num `#{max_num}'"
    end
    if expiration and expiration <= 0
      raise ArgumentError, "invalid expiration `#{expiration}'"
    end
    
    @max_obj_size = max_obj_size
    @max_size = max_size
    @max_num = max_num
    @expiration = expiration
    @hook = hook
    
    @objs = {}
    @size = 0
    @list = []
    
    @hits = 0
    @misses = 0
  end

  attr_reader :max_obj_size, :max_size, :max_num, :expiration

  def cached?(key)
    @objs.include?(key)
  end
  alias :include? :cached?
  alias :key? :cached?

  def invalidate(key)
    obj = @objs[key]
    
    if @hook
      @hook.call(key, obj)
    end
    
    @size -= obj.size
    @objs.delete(key)
    @list.each_index do |i|
      if @list[i] == key
	@list.delete_at(i)
	break
      end
    end
  end
  alias :delete :invalidate

  def invalidate_all()
    if @hook
      @objs.each do |key, obj|
	@hook.call(key, obj)
      end
    end

    @objs.clear
    @list.clear
    @size = 0
  end
  alias :clear :invalidate_all
  
  def expire()
    if @expiration
      now = Time.now.to_i
      @list.each_index do |i|
	key = @list[i]
	
	break unless @objs[key].atime + @expiration <= now
	self.invalidate(key)
      end
    end
    
    GC.start
  end
	
  def [](key)
    unless @objs.include?(key)
      @misses += 1
      return nil
    end
    
    obj = @objs[key]
    now = Time.now.to_i
    if @expiration and obj.atime + @expiration <= now
      self.expire()
      @misses += 1
      return nil
    end

    obj.atime = now
    @list.each_index do |i|
      if @list[i] == key
	@list.delete_at(i)
	break
      end
    end
    @list.push(key)

    @hits += 1
    obj.content
  end
  
  def []=(key, obj)
    if self.cached?(key)
      self.invalidate(key)
    end

    size = obj.to_s.size
    if @max_obj_size and @max_obj_size < size
      if $DEBUG
	$stderr.puts("warning: `#{obj.inspect}' isn't cached because its size exceeds #{@max_obj_size}")
      end
      return obj
    end
    if @max_obj_size.nil? and @max_size and @max_size < size
      if $DEBUG
	$stderr.puts("warning: `#{obj.inspect}' isn't cached because its size exceeds #{@max_size}")
      end
      return obj
    end
      
    if @max_num and @max_num == @list.size
      self.invalidate(@list.first)
    end

    @size += size
    if @max_size
      while @max_size < @size
	self.invalidate(@list.first)
      end
    end

    @objs[key] = CACHE_OBJECT.new(obj, size, Time.now.to_i)
    @list.push(key)

    obj
  end

  # The total size of cached objects, the number of cached objects,
  # the number of cache hits, and the number of cache misses.
  def statistics()
    [@size, @list.size, @hits, @misses]
  end
end

# Run a test, if executed.
if __FILE__ == $0
  cache = Cache.new(100 * 1024, 100 * 1024 * 1024, 256, 1)
  1000.times do
    key = rand(1000)
    cache[key] = key.to_s
  end
  1000.times do
    key = rand(1000)
    puts cache[key]
  end
  sleep 1
  1000.times do
    key = rand(1000)
    puts cache[key]
  end
  
  stat = cache.statistics()
  hits = stat[2]
  misses = stat[3]
  ratio = hits.to_f / (hits + misses)
  
  puts "Total size:\t#{stat[0]}"
  puts "Number:\t\t#{stat[1]}"
  puts "Hit ratio:\t#{ratio * 100}% (#{hits} / #{hits + misses})"
end
