class ShareMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  
  def notify(share, sent_at = Time.now)
    from          "shares@alist.heroku.com"
    reply_to      share.link.submitter.email
    recipients    share.recipient.email
    subject       "#{share.link.submitter.name} shared a link with you"
    #content_type  "text/html"
    body          :share => share
  end
end
