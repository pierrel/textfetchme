class String
  def self.random(hash = {:length => 10})
    hash[:length] = 10 unless hash.has_key?(:length)
    list = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    generated = ""
    1.upto(hash[:length]) do |number|
      generated = generated + list[rand(list.size - 1)]
    end
    return generated
  end
  
  def first_word()
    arr = self.split(' ')
    if arr.length >= 1
      return arr[0]
    else
      return nil
    end
  end
end