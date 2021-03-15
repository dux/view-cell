class UserCell < AppCell
  delegate :email

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
    template './spec/misc/profile'
  end

  def profiles
    @users = [User.new('dux', 'dux@net'), User.new('foo', 'foo@net')]
    template './spec/misc/profiles'
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