class FriendshipsController < ApplicationController
  layout "application"
  before_filter :authenticate_user
end
