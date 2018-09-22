module Brickset
  module Elements
    class Year
      include HappyMapper

      tag 'years'

      element :theme, String
      element :year, String
      element :set_count, Integer, tag: 'setCount'
    end
  end
end
