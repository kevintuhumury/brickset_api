module Brickset
  module Elements
    class MinifigCollection
      include HappyMapper

      tag 'minifigCollection'

      element :minifig_number, String, tag: 'minifigNumber'
      element :owned_in_sets, Integer, tag: 'ownedInSets'
      element :owned_loose, Integer, tag: 'ownedLoose'
      element :owned_total, Integer, tag: 'ownedTotal'
      element :wanted, Boolean
    end
  end
end
