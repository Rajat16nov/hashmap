class HashMap

  def initialize
    @buckets = Array.new(16)
  end

  def hash(key)
    hash_code = 0
    prime_number = 31

    key.each_char { |char| hash_code = prime_number * hash_code + char.ord }

    hash_code
  end

  def set(key, value)
    resize if load_factor > 0.75

    index = hash(key) % @buckets.length
    validate_index(index)

    # If the bucket is nil, initialize it as an empty array.
    @buckets[index] ||= []

    # Check if the key already exists within the bucket.
    pair = @buckets[index].find { |pair| pair[0] == key }

    if pair
      # If the key exists, update the value.
      pair[1] = value
    else
      # If the key doesn't exist, append the new key-value pair.
      @buckets[index] << [key, value]
    end
  end


  def get(key)
    index = hash(key) % @buckets.length
    validate_index(index)

    bucket = @buckets[index]
    return nil unless bucket

    # Find the key-value pair with the matching key and return its value.
    pair = bucket.find { |pair| pair[0] == key }
    pair ? pair[1] : nil
  end

  def has?(key)
    !get(key).nil?
  end

  def remove(key)
    index = hash(key) % @buckets.length
    validate_index(index)

    bucket = @buckets[index]
    return nil unless bucket

    pair_index = bucket.find_index { |pair| pair[0] == key }
    return nil unless pair_index

    # Delete the pair from the bucket and return its value.
    deleted_pair = bucket.delete_at(pair_index)
    deleted_pair[1]
  end

  def clear
    @buckets = Array.new(16) # Reset to the initial number of buckets.
  end

  def length
    @buckets.compact.sum { |bucket| bucket.size }
  end

  def keys
    @buckets.compact.flatten(1).map { |pair| pair[0] }
  end

  def values
    @buckets.compact.flatten(1).map { |pair| pair[1] }
  end

  def entries
    @buckets.compact.flatten(1)
  end

  def load_factor
    length.to_f / @buckets.length
  end

  def resize
    old_buckets = @buckets
    @buckets = Array.new(@buckets.length * 2) # Double the size

    old_buckets.compact.flatten(1).each do |key, value|
      set(key, value)
    end
  end


  private

  def validate_index(index)
    raise IndexError if index.negative? || index >= @buckets.length
  end

end
