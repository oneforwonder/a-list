class LinksController < ApplicationController
  layout "application"
  before_filter :authenticate_user
  
  def new
    @link = Link.new
  end

  # Create a link object/database entry.
  # Create a user account for every user not yet present.
  # Send out an email to every user.
  # Create "friendships" between users.
  def create
    @link = @current_user.submissions.new(params[:link])
    if @link.save
      flash[:notice] = 'Link shared successfully.'
      self_share = @current_user.shares.create(:link => @link)
      
      params[:recipients].each do |email|
        puts "email: #{email}"

        # Find or create recipient.
        recipient = User.find_by_email(email)
        if !recipient
          password = SecureRandom.hex(8)
          recipient = User.new(:email => email, :password => password,
                               :password_confirmation => password)
          # The DB schema requires a password
        end

        if recipient.save!
          share = recipient.shares.create(:link => @link)

          # TODO: Make email notifications optional.
          #if recipient.email_notifications || !recipient.activated
            # TODO: Possibly distinguish between these three cases:
            #  - Non-Activated User receiving first ever email from us
            #  - Non-Activated User receiving not first email
            #  - Activated User with email notifications on
          share.email_recipient
          #end
          
          # Create "friendships"
          if !@current_user.friends.find_by_id(recipient)
            @current_user.friends.push(recipient)
            recipient.friends.push(@current_user)
            @current_user.save
            recipient.save
          end # End friendships if
        end # End recipient if
      end # End each recipient
      
      redirect_to share_path(self_share.id)
      
    else
      flash[:notice] = 'Link sharing failed. Sorry.'
    end # End link saved
  end # End create method
end # End LinkController class
