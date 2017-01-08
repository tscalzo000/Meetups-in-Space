class Meetup < ActiveRecord::Base
  has_many :signups
  has_many :users, through: :signups
  has_many :comments

  validates :name, presence: true
  validates :location, presence: true
  validates :description, presence: true

  def signups
    Signup.where(meetup_id: id)
  end

  def comments
    Comment.where(meetup_id: id)
  end
end
