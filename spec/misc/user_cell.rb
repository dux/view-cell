class UserCell < AppCell
  delegate :email

  css 'css/user.scss'

  def before
    super
    @numbers.push 456
  end

  def sq num
    num * num
  end

  def numbers
    @numbers.join '-'
  end

  def profile
    @user = parent { @user }
    template :profile
  end

  def profiles
    @users = [User.new('dux', 'dux@net'), User.new('foo', 'foo@net')]
    template 'profiles'
  end

  def not_found
    template :not_found
  end

  def uemail
    email
  end

  def render user
    '>%s<' % user.name
  end
end