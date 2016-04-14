class Tester
  class T1
    def palindrome?(string)
      return false if string.nil? || !string.is_a?(String) || string.empty?

      str = Tester.normalize_string(string)
      str == str.reverse
    end
  end

  class T2
    def palindrome?(string)
      return false if string.nil? || !string.is_a?(String) || string.empty?

      str = Tester.normalize_string(string)
      (0..str.length/2).all? { |i| str[i] == str[-(i + 1)] }
    end
  end

  # Returns a normalized copy of string with non alpha numeric characters
  # removed and characters downcased.
  def self.normalize_string(string)
    string.gsub(/[^[:alnum:]]/, '').downcase
  end
end
