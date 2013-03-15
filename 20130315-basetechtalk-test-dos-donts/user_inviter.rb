class UserInviter
  def initialize(account, email)
    @account = account
    @email = email
  end

  def invite
    new_user = create_user
    send_invitation_email(new_user)

    new_user
  end

  private
  attr_reader :email, :account

  def create_user
    new_user = User.new(:email => email, :account => account)
    ActiveRecord::Base.transaction do
      new_user.save!
      account.increment!("user_count")
      new_user
    end
  rescue ActiveRecord::RecordInvalid
    new_user
  end

  def send_invitation_email(new_user)
    UserMailer.deliver(new_user)
  end
end
