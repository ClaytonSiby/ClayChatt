module ApplicationHelper
  # Returns the new record created in notifications table

  def new_notification(user, notice_id, notice_type)
    notice = user.notifications.build(notice_id: notice_id, notice_type: notice_type)

    user.notice_seen = false
    user.save
    notice
  end
end
