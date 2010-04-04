class Comment < ActiveRecord::Base
  belongs_to :link
  belongs_to :user
  
  def submitted_time
    Time.parse(created_at.to_s) # TODO: Support timezones.
  end
end
