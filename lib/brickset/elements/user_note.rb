module Brickset
  module Elements
    class UserNote
      include HappyMapper

      tag 'userNotes'

      element :set_id, Integer, tag: 'setID'
      element :user_notes, String, tag: 'userNotes'
    end
  end
end
