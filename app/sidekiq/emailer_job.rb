class EmailerJob
  include Sidekiq::Job

  def perform(receiver_id, bug_id)
    user = User.find(receiver_id)
    bug = Bug.find(bug_id)
    MailerMailer.bug_fixed(user, bug).deliver_later
  end
end
