class User < ActiveRecord::Base
  acts_as_authentic
  
  def name
    if first_name
      first_name.to_s + " " + last_name.to_s
    else
      email
    end
  end
end
