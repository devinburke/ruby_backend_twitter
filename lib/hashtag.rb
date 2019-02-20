require 'application_record'

ActiveRecord::Schema.define do
  create_table :hashtags, force: true do |t|
    t.string :tag
  end
end

class Hashtag < ApplicationRecord
  has_many :subscriptions
  has_many :tweets
  
  attribute :tag, :string

  validates :tag, uniqueness: true

  def notify_users
    self.subscriptions.each { |s| s.user.notify }
  end
end
