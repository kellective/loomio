class UserMailer < BaseMailer
  include ApplicationHelper
  include ERB::Util
  include ActionView::Helpers::TextHelper
  default :from => "\"Loomio\" <noreply@loomio.org>", :css => :email

  def daily_activity(user, activity, since_time)
    @user = user
    @activity = activity
    @since_time = since_time
    @since_time_formatted = since_time.strftime('%A, %-d %B')
    @groups = user.groups.sort{|a,b| a.full_name <=> b.full_name }
    set_email_locale(user.language_preference, nil)
    mail to: @user.email,
         subject: "Loomio - Summary of the last 24 hours"
  end

  def mentioned(user, comment)
    @user = user
    @comment = comment
    @rendered_comment_body = render_rich_text(comment.body, comment.uses_markdown)
    @discussion = comment.discussion
    set_email_locale(user.language_preference, comment.author.language_preference)
    mail to: @user.email,
         subject: "#{comment.author.name} mentioned you in the #{comment.group.name} group on Loomio"
  end

  def group_membership_approved(user, group)
    @user = user
    @group = group
    set_email_locale(user.language_preference, User.find_by_email(@group.admin_email).language_preference)
    mail( :to => user.email,
          :reply_to => @group.admin_email,
          :subject => "#{email_subject_prefix(@group.full_name)} Membership approved")
  end

  def motion_closing_soon(user, motion)
    @user = user
    @motion = motion
    set_email_locale(user.language_preference, @motion.author.language_preference)
    @rendered_motion_description = render_rich_text(motion.description, false) #later: change false to motion.uses_markdown
    mail to: user.email,
         reply_to: @motion.author.email,
         subject: "[Loomio - #{@motion.group.name}] Proposal closing soon: #{@motion.name}"
  end
end
