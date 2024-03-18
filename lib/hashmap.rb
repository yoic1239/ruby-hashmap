class HashMap
  attr_reader :buckets

  def initialize
    @capacity = 16
    @load_factor = 0.75
    @buckets = Array.new(@capacity)
  end

  def hash(key)
    hash_code = 0
    prime_number = 47

    key.each_char { |char| hash_code = prime_number * hash_code + char.ord }

    hash_code
  end

  def set(key, value)
    index = hash(key) % @buckets.length
    raise IndexError if index.negative? || index >= @buckets.length

    if @buckets[index]
      @buckets[index][key] = value
    else
      @buckets[index] = { key => value }
    end
    grow if length > @capacity * @load_factor
  end

  def get(key)
    index = hash(key) % @buckets.length
    raise IndexError if index.negative? || index >= @buckets.length

    @buckets[index][key] if @buckets[index]
  end

  def has(key)
    index = hash(key) % @buckets.length
    raise IndexError if index.negative? || index >= @buckets.length

    return false unless @buckets[index]

    @buckets[index].include?(key)
  end

  def remove(key)
    index = hash(key) % @buckets.length
    raise IndexError if index.negative? || index >= @buckets.length

    return nil unless has(key)

    @buckets[index].delete(key)
  end

  def length
    keys.length
  end

  def clear
    @buckets = Array.new(@capacity)
  end

  def keys
    existing_keys = []
    @buckets.each { |bucket| existing_keys += bucket.keys if bucket }
    existing_keys
  end

  def values
    existing_values = []
    @buckets.each { |bucket| existing_values += bucket.values if bucket }
    existing_values
  end

  def entries
    entries_arr = []
    keys.each do |key|
      entries_arr << [key, get(key)]
    end
    entries_arr
  end

  def grow
    original_entries = entries
    @capacity *= 2
    clear
    original_entries.each do |entry|
      set(entry[0], entry[1])
    end
  end
end
