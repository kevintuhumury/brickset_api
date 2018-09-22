module Brickset
  module Api
    module Collection
      module Advanced
        extend ActiveSupport::Concern

        included do
          attr_accessor :condition

          with_options(on: :collection_detail_conditions) do |options|
            options.validates :condition, inclusion: { in: %w(acquired now) }
          end
        end

        def collection_detail(set_id)
          xml = call('/getCollectionDetail', setID: set_id)
          Brickset::Elements::CollectionDetail.parse(xml, single: true)
        end

        def collection_detail_conditions(condition)
          self.condition = condition

          if valid?(:collection_detail_conditions)
            xml = call('/getCollectionDetailConditions', which: condition)
            Brickset::Elements::Condition.parse(xml)
          else
            raise ValidationError, self.errors.full_messages.to_sentence
          end
        end

      end
    end
  end
end
