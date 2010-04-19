class Comment < ActiveRecord::Base
  belongs_to :link
  belongs_to :user
  
  validate_presence_of :content, :link_id, :user_id
  
  def submitted_time
    Time.parse(created_at.to_s) # TODO: Support timezones.
  end
end
