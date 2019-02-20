require 'application_record'

ActiveRecord::Schema.define do
  create_table :subscriptions, force: true do |t|
    t.string :user_id
    t.string :hashtag_id
  end
end

class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :hashtag
end
