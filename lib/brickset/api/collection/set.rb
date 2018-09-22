module Brickset
  module Api
    module Collection
      module Set
        extend ActiveSupport::Concern

        included do
          attr_accessor :set_id, :number_owned, :wanted, :owned, :notes, :rating

          with_options(on: :update_collection) do |options|
            options.validates :set_id, :number_owned, :wanted, presence: true
            options.validates :number_owned, inclusion: { in: (0..999) }
            options.validates :wanted, inclusion: { in: [0, 1] }
          end

          with_options(on: :update_collection_owned) do |options|
            options.validates :set_id, :owned, presence: true
            options.validates :owned, inclusion: { in: [0, 1] }
          end

          with_options(on: :update_collection_wanted) do |options|
            options.validates :set_id, :wanted, presence: true
            options.validates :wanted, inclusion: { in: [0, 1] }
          end

          with_options(on: :update_collection_number_owned) do |options|
            options.validates :set_id, :number_owned, presence: true
            options.validates :number_owned, inclusion: { in: (0..999) }
          end

          with_options(on: :update_collection_user_notes) do |options|
            options.validates :set_id, :notes, presence: true
            options.validates :notes, length: { maximum: 200 }
          end

          with_options(on: :update_user_rating) do |options|
            options.validates :set_id, :rating, presence: true
            options.validates :rating, inclusion: { in: (0..5) }
          end
        end

        def collection_totals
          xml = call('/getCollectionTotals')
          Brickset::Elements::CollectionTotal.parse(xml)
        end

        def update_collection(options)
          extract_attributes_from_options(options)

          if valid?(:update_collection)
            handle_update call('/setCollection', setID: set_id, qtyOwned: number_owned, wanted: wanted)
          else
            raise ValidationError, self.errors.full_messages.to_sentence
          end
        end

        def update_collection_owned(options)
          extract_attributes_from_options(options)

          if valid?(:update_collection_owned)
            handle_update call('/setCollection_owns', setID: set_id, owned: owned)
          else
            raise ValidationError, self.errors.full_messages.to_sentence
          end
        end

        def update_collection_wanted(options)
          extract_attributes_from_options(options)

          if valid?(:update_collection_wanted)
            handle_update call('/setCollection_wants', setID: set_id, wanted: wanted)
          else
            raise ValidationError, self.errors.full_messages.to_sentence
          end
        end

        def update_collection_number_owned(options)
          extract_attributes_from_options(options)

          if valid?(:update_collection_number_owned)
            handle_update call('/setCollection_qtyOwned', setID: set_id, qtyOwned: number_owned)
          else
            raise ValidationError, self.errors.full_messages.to_sentence
          end
        end

        def update_collection_user_notes(options)
          extract_attributes_from_options(options)

          if valid?(:update_collection_user_notes)
            handle_update call('/setCollection_userNotes', setID: set_id, notes: notes)
          else
            raise ValidationError, self.errors.full_messages.to_sentence
          end
        end

        def update_user_rating(options)
          extract_attributes_from_options(options)

          if valid?(:update_user_rating)
            handle_update call('/setUserRating', setID: set_id, rating: rating)
          else
            raise ValidationError, self.errors.full_messages.to_sentence
          end
        end

        def user_notes
          xml = call('/getUserNotes')
          Brickset::Elements::UserNote.parse(xml).reject do |user_note|
            user_note.set_id.nil? && user_note.user_notes.nil?
          end
        end

      end
    end
  end
end
