class Link < ActiveRecord::Base
  belongs_to :submitter, :class_name => "User"
  has_many :shares
  has_many :recipients, :through => :shares
  has_many :comments
end
