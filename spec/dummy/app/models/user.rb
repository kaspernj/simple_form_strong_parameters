class User < ActiveRecord::Base
  has_many :roles, dependent: :destroy

  accepts_nested_attributes_for :roles

  validates_presence_of :name
end
