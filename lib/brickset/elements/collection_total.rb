module Brickset
  module Elements
    class CollectionTotal
      include HappyMapper

      tag 'collectionTotals'

      element :total_sets_owned, Integer, tag: 'totalSetsOwned'
      element :total_sets_wanted, Integer, tag: 'totalSetsWanted'
      element :total_distinct_sets_owned, Integer, tag: 'totalDistinctSetsOwned'
      element :total_minifigs_owned, Integer, tag: 'totalMinifigsOwned'
      element :total_minifigs_wanted, Integer, tag: 'totalMinifigsWanted'
    end
  end
end
