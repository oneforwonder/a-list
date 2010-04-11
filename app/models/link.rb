class Link < ActiveRecord::Base
  belongs_to :submitter, :class_name => "User"
  has_many :shares
  has_many :recipients, :through => :shares
  has_many :comments
  
  before_create :add_http
  
  def domain
    if url.include? "//"
      url.split('/')[2]
    else
      url.split('/')[0]
    end
  end
  
  def is_url?(field)
    self.send(field).index(/^[A-Za-z]{1,8}:\/\//) == 0  # If the URL doesn't start with eight characters and ://...
  end
  
  private
    def add_http
      if !is_url?(:url)
        self.url = "http://" + self.url
      end
    end

end
