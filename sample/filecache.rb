# Copyright (C) 2002  Koji Arai
# Copyright (C) 2002  Yoshinori K. Okuji
#
# You may redistribute it and/or modify it under the same term as Ruby.

require 'cache'

class FileCache
  def initialize(maxopen = 10)
    @cache = Cache.new(nil, nil, maxopen) {|key, obj| obj.close}
    @saw = {}
  end
  
  def open(file)
    @cache.fetch(file) do
      mode = if @saw.key?(file) then 'a' else 'w' end
      @saw[file] = true
      File.open(file, mode)
    end
  end
  
  def close
    @cache.invalidate_all
  end
end

if $0 == __FILE__
  File.open("/tmp/foo", "w") {|f|
    1000.times {|i|
      f.printf("file%03d %d\n", rand(100), i)
    }
  }
  
  # /tmp/foo
  # foo001 0
  # foo099 1
  # foo050 2
  # foo001 3
  #   :
  #   :
  
  cacheout = FileCache.new(10)
  
  File.open("/tmp/foo") {|f|
    while line = f.gets
      file, number = line.split
      
      cacheout.open(file).puts number
    end
  }
end
