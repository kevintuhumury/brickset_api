module Brickset
  module Elements
    class Theme
      include HappyMapper

      tag 'themes'

      element :theme, String
      element :set_count, Integer, tag: 'setCount'
      element :subtheme_count, Integer, tag: 'subthemeCount'
      element :year_from, Integer, tag: 'yearFrom'
      element :year_to, Integer, tag: 'yearTo'
    end
  end
end
