class HomeController < ApplicationController
def index
  if not user_signed_in?
    redirect_to user_session_path
  end
end
end