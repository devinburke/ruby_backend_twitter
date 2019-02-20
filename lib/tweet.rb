require 'application_record'

ActiveRecord::Schema.define do
  create_table :tweets, force: true do |t|
    t.string :content
  end
end

class Tweet < ApplicationRecord
  belongs_to :user
  has_many :hashtags

  attribute :content, :string

  validates :content, length: { maximum: 140 }

  after_create do
    tags = self.content.scan(/#\w+/).flatten

    hashtags = tags.map { |tag| Hashtag.find_or_create_by(tag: tag) }

    hashtags.each(&:notify_users)
  end
end
