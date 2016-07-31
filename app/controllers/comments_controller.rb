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
  before_action :load_comment, only: %i(edit show update)

  respond_to :html, :json

  def index
    @commentable = find_commentable
    @comments = @commentable.comments
    render layout: false
  end

  def show
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

  def update
    if @comment.user_id == current_user.id
      @comment.update_attributes(comment_params)
      render json: nil, status: :ok
    else
      respond_with @comment, status: :unauthorized
    end
  end

  private

  def load_comment
    @comment = Comment.find(params[:id])
  end

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
