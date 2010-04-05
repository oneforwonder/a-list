class ShareMailer < ActionMailer::Base
  

  def notify(sent_at = Time.now)
    subject    'ShareMailer#notify'
    recipients ''
    from       ''
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

end
