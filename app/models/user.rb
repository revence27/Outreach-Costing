class User < ActiveRecord::Base
  def admin?
    self.is_admin
  end
end
