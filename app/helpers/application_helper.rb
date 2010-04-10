# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  # Return the string enclosed in quotes.
  def q(s)
    "\"#{s}\""
  end
  
  def me_ify(user)
    if user == current_user
      "me"
    else
      user.name
    end
  end
end
