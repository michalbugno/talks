require "./user_inviter"

describe UserInviter do
  let(:account) { Account.create!(:name => "getbase.com") }

  before(:each) do
    Account.delete_all
    User.delete_all
  end

  it "adds user to account" do
    inviter = build_inviter(account, "mike@getbase.com")

    user = inviter.invite
    user.account.should == account
  end

  it "sets user's email" do
    inviter = build_inviter(account, "paul@getbase.com")

    user = inviter.invite
    user.email.should == "paul@getbase.com"
  end

  it "sends email when invitation was succesfull" do
    inviter = build_inviter(account, "mike@getbase.com")

    inviter.should_receive(:send_invitation_email)
    user = inviter.invite
  end

  it "increases user_count in account" do
    old_count = account.user_count
    inviter = build_inviter(account, "mike@getbase.com")

    user = inviter.invite
    account.reload.user_count.should == old_count + 1
  end

  it "doesn't increase counter if user creation failed" do
    # Are we really that unsure of transaction here?
    old_count = account.user_count
    inviter = build_inviter(account, "mike@getbase.com")

    User.any_instance.should_receive(:save!).and_raise(ActiveRecord::RecordInvalid.new(User.new))
    inviter.invite
    account.reload.user_count.should == old_count
  end

  def build_inviter(account, email)
    inviter = UserInviter.new(account, email)
    inviter.stub(:send_invitation_email)
    inviter
  end
end
