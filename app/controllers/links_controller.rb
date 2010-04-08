class LinksController < ApplicationController
  layout "application"
  before_filter :authenticate_user
  
  def new
    @link = Link.new
  end

  # Create a link database entry.
  # Create a user account for every email not yet present.
  # Send out an email to every user.
  # Create friendships between users.
  def create
    # First, remove any duplicates and verify we have at least
    # one recipient who is not the submitter.
    # TODO: Validate recipients before submission with JS.
    emails = params[:recipients]
    emails = [] if emails.nil?
    emails.map! { |e| e.strip }
    emails.map! { |e| e.downcase }
    emails.uniq!
    emails.delete(@current_user.email.downcase)

    if emails.length == 0
      # TODO: Fill in the form with the data the user has already entered.
      redirect_to new_link_path
      flash[:error] = 'You need at least one recipient.'

    else
      @link = @current_user.submissions.new(params[:link])
      if @link.save
        emails.each do |email|
          # Find the user or create a "placeholder" user.
          recipient = User.find_by_email(email)

          if recipient.nil?
            # We do not yet have an account associated with this email.
            # We will create a placeholder account to associate the shares with.
            # Authlogic requires all users have a password,
            # so we'll generate a random one.
            password = Digest::SHA1.hexdigest(rand(1000000).to_s)
            recipient = User.new(:email => email, :password => password,
                                 :password_confirmation => password)
          end

          if recipient.save
            share = recipient.shares.create(:link => @link)

            # TODO: Make email notifications optional.
            #if recipient.email_notifications || !recipient.activated
              # TODO: Possibly distinguish between these three cases:
              #  - Non-Activated User receiving first ever email from us
              #  - Non-Activated User receiving not first email
              #  - Activated User with email notifications on
            share.email_recipient
            #end

            # Create friendships between submitter and recipient,
            # if they don't already exist.
            if !@current_user.friends.find_by_id(recipient)
              @current_user.friends.push(recipient)
              recipient.friends.push(@current_user)
              @current_user.save
              recipient.save
            end
            
          end # End if recipient.save
        end # End emails.each

        self_share = @current_user.shares.create(:link => @link)
        redirect_to share_path(self_share)

      else
        flash[:error] = 'The link could not be saved. Please wait a while then try again.'
      end # End if link saved
      
    end # End if emails.length
  end # End create method
  
end # End LinkController class
