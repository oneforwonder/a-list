class ActivationMailer < ActionMailer::Base
  
  def activation_instructions(user, sent_at = Time.now)
    from          "A-List Account Activation <activation@alist.heroku.com>"
    reply_to      "no-reply@alist.heroku.com"
    recipients    user.email
    subject       "Activate Your A-List Account"
    body          :account_activation_url => activate_url(user.perishable_token)
  end

end
