class Friendship < ApplicationRecord
  belongs_to :sent_to, class_name: :user, foreign_key: :sent_to_id
  belongs_to :sent_by, class_name: :user, foreign_key: :sent_by_id

  scope :friends, -> { where('status =?', true) }
  scope :non_friends, -> { where('status =?', false) }
end
