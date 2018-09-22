module Brickset
  module Elements
    class Condition
      include HappyMapper

      tag 'conditions'

      element :condition, String
    end
  end
end
