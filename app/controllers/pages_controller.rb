class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :how_to]

  def profile
    # Get current authenticated user profile record
    @current_user = current_user
  end

  def home
  end

  def how_to
    
  end
end
