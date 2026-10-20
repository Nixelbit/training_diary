module TestCurrentUserResolver
  def current_user_resolver = -> { User.first }
end
