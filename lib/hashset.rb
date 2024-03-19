class HashSet
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

  def set(key)
    index = hash(key) % @buckets.length
    raise IndexError if index.negative? || index >= @buckets.length

    if @buckets[index]
      @buckets[index] << key
    else
      @buckets[index] = Set[key]
    end

    grow if length > @capacity * @load_factor
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
    key
  end

  def length
    keys.length
  end

  def clear
    @buckets = Array.new(@capacity)
  end

  def keys
    existing_keys = []
    @buckets.each { |bucket| existing_keys += bucket.to_a if bucket }
    existing_keys
  end

  def grow
    original_keys = keys
    @capacity *= 2
    clear
    original_keys.each do |key|
      set(key)
    end
  end
end
