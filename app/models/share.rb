class Share < ActiveRecord::Base
  belongs_to :link
  belongs_to :recipient, :class_name => "User"

  # Returns all recipients other than the submitter.
  def other_recipients
    self.link.recipients.select { |r| r != self.link.submitter }
  end
  
  def other_shares
    self.link.shares.select { |s| s != self }
  end
  
  # Better method name?
  def other_shares_except_with(user)
    self.link.shares.select { |s| s.recipient != user }
  end
  
  def submitted_time
    Time.parse(created_at.to_s) # TODO: Support timezones.
  end

  def email_recipient
    ShareMailer::deliver_notify self
  end
end
