class Link < ActiveRecord::Base
  belongs_to :submitter, :class_name => "User"
  has_many :shares
  has_many :recipients, :through => :shares
  has_many :comments
  
  def domain
    if url.include? "//"
      url.split('/')[2]
    else
      url.split('/')[0]
    end
  end
end
