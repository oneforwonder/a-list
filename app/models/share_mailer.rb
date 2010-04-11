class ShareMailer < ActionMailer::Base
  include ActionController::UrlWriter
  default_url_options[:host] = "alist.heroku.com"
  
  add_template_helper(ApplicationHelper)
  
  def notify(share, sent_at = Time.now)
    if share.recipient.activated
      # Send the user directly to the share.
      url = share_url(@share.id)
    else
      # The user needs to finish creating their account first.
      url = finish_registration_url(share.recipient.perishable_token)
    end
  
    from          "Share Notifier <shares@alist.heroku.com>"
    reply_to      share.link.submitter.email
    recipients    share.recipient.email
    subject       "#{share.link.submitter.name} shared a link with you"
    body          :share => share, :url => url
  end
end
