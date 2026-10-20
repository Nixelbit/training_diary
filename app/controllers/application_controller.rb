class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  class << self
    def current_user_resolver = -> { User.second }
  end

  def current_user
    @current_user ||= self.class.current_user_resolver.call
  end
end
