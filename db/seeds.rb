email     = shell.ask 'Which email do you want use for logging into admin?'
password  = shell.ask 'Tell me the password to use:', :echo => false

shell.say ''

admin_group = Group.first_or_create(:name => 'admin')

user = User.new(
    :email => email,
    :username => 'hayden',
    :first_name => 'Hayden',
    :last_name => 'King',
    :password => password,
    :password_confirmation => password)

user.add_group(admin_group)

if user.valid?
  user.save
  shell.say '================================================================='
  shell.say 'User has been successfully created, now you can login with:'
  shell.say '================================================================='
  shell.say "   username: #{user.username}"
  shell.say "   password: #{?* * user.password.length}"
  shell.say '================================================================='
else
  shell.say 'Sorry but some thing went wrong!'
  shell.say ''
  user.errors.full_messages.each { |m| shell.say "   - #{m}" }
end

shell.say ''
