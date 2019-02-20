require 'application_record'

ActiveRecord::Schema.define do
  create_table :users, force: true do |t|
    t.string :email
    t.string :username
    t.string :password_digest
  end
end

class User < ApplicationRecord
  has_secure_password

  has_many :subscriptions
  has_many :tweets

  attribute :email, :string
  attribute :username, :string
  attribute :password, :string
  attribute :password_confirmation, :string

  validates :email, presence: true,
    unless: Proc.new { |user| user.username.present? }

  validates :username, presence: true,
    unless: Proc.new { |user| user.email.present? }

  def self.sign_in_with_email(email, password)
    authenticate_user({email: email}, password)
  end

  def self.sign_in_with_username(username, password)
    authenticate_user({username: username}, password)
  end

  def self.authenticate_user(options, password)
    User.find_by(options).try(:authenticate, password)
  end

  def subscribe_to_hashtag(hashtag)
    Subscription.find_or_create_by(user_id: self.id, hashtag_id: hashtag.id)
  end

  def notify
    # This function will send a notification out to the user using the
    # appropriate venue. Assume it is already written and use it where you need.
  end
end
