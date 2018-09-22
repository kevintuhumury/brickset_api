module Brickset
  module Elements
    class Subtheme
      include HappyMapper

      tag 'subthemes'

      element :theme, String
      element :subtheme, String
      element :set_count, Integer, tag: 'setCount'
      element :year_from, Integer, tag: 'yearFrom'
      element :year_to, Integer, tag: 'yearTo'
    end
  end
end
