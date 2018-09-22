module Brickset
  module Elements
    class Instruction
      include HappyMapper

      tag 'instructions'

      element :url, String, tag: 'URL'
      element :description, String
    end
  end
end
