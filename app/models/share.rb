class Share < ActiveRecord::Base
  belongs_to :link
  belongs_to :recipient, :class_name => "User"
  
  def other_recipients(current_user)
    all_recipients = []
    self.link.shares.each { |s| all_recipients << s.recipient unless s.recipient == current_user }
    all_recipients
  end
  
  def submitted_time
    Time.parse(created_at.to_s) # TODO: Support timezones.
  end

  def email_recipient
    ShareMailer::deliver_notify self
  end
end
