module LikesHelper
  private

  def type_subject?(params)
    type = 'post' if params.key?('post_id')
    type = 'comment' if params.key?('comment_id')
    subject = Post.find(params[:post_id]) if type == 'post'
    subject = Comment.find(params[:comment_id]) if type == 'comment'

    [type, subject]
  end

  def already_liked?(type)
    result = false

    result = Like.where(user_id: current_user.id, post_id: params[:post_id]).exists? if type == 'post'

    result = Like.where(user_id: current_user.id, comment_id: params[:comment_id]).exists? if type == 'comment'

    result
  end

  def dislike(type)
    @like = Like.find_by(post_id: params[:post_id]) if type == 'post'

    @like = Like.find_by(comment_id: params[:comment_id]) if type == 'comment'

    return unless @like

    @like.destroy
    redirect_back(fallback_location: root_path)
  end
end
