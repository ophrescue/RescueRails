# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  content          :text
#  commentable_id   :integer
#  commentable_type :string(255)
#  user_id          :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class CommentsController < ApplicationController
  include SessionsHelper

  before_action :authenticate

  respond_to :html, :json

  def index
    @commentable = find_commentable
    @comments = @commentable.comments
    render layout: false
  end

  def show
    @comment = Comment.find(params[:id])
    render layout: false
  end

  def new
    @comment = Comment.new
  end

  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      flash[:success] = 'Comment Saved'
      return handle_redirect
    else
      render action: 'new'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def find_commentable
    params.each do |name, value|
      matches = /(.+)_id$/.match(name)

      if matches.present?
        klass = matches[1]
        return klass.classify.constantize.find(value)
      end
    end

    nil
  end
end
