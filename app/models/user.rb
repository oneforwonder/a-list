class User < ActiveRecord::Base
  acts_as_authentic
  
  has_many :submissions, :class_name => "Link", :foreign_key => :submitter_id
  has_many :shares, :foreign_key => :recipient_id, :order => "created_at DESC"
  has_many :comments
  has_many :friendships
  has_many :friends, :through => :friendships
  
  attr_protected :activated
  
  def active?
    activated
  end
  
  def name
    if active?
      first_name.to_s + " " + last_name.to_s
    else
      email
    end
  end
  
  def unread_shares
    shares.select {|s| !s.read }
  end

  def shares_from(submitter)
    shares.select {|s| s.link.submitter == submitter }
  end
  
  def deliver_activation_instructions
    reset_perishable_token!
    ActivationMailer.deliver_activation_instructions(self)
  end
  
end
