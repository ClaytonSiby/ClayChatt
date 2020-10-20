class LikesController < ApplicationController
  include ApplicationHelper

  def create
    type = type_subject?(params)[0]
    @subject = type_subject?(params)[1]
    notice_type = "like-#{type}"

    return unless @subject

    if already_liked?(type)
      dislike(type)

    else
      @like = @subject.likes.build(user_id: current_user.id)

      if @like.save
        flash[:success] = "#{type} like!"
        @notification = new_notification(@subject.user, @subject.id, notice_type)

        @notification.save
      else
        flash[:danger] = "#{type} like failed!"
      end

      redirect_back(fallback_location: root_path)
    end
  end
end
