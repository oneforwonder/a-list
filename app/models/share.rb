class Share < ActiveRecord::Base
  belongs_to :link
  belongs_to :recipient, :class_name => "User"
  
  def submitted_time
    Time.parse(created_at.to_s) # TODO: Support timezones.
  end
end
