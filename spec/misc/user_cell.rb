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
    render './spec/misc/profile'
  end

  def not_found
    render :not_found
  end

  def uemail
    email
  end
end