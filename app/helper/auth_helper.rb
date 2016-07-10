def is_admin
  @current_user.has_group('admin')
end