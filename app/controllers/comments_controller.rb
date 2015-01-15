class CommentsController < ApplicationController

  respond_to :html, :json

  def index
    @commentable = find_commentable
    @comments = @commentable.comments
    render :layout => false
  end

  def show
    @comment = Comment.find(params[:id])
    render :layout => false
  end

  def new
    @comment = Comment.new
  end

  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(params[:comment])
    @comment.user_id = current_user.id
    if @comment.save
      flash[:success] = 'Comment Saved'
      return handle_redirect
    else
      render :action => 'new'
    end
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.user_id == current_user.id
      @comment.update_attributes(params[:comment])
      respond_with @comment.content
    else
      # return a not authorized
      respond_with @comment, :status => :unauthorized
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.user == current_user
      @comment.destroy
    else
      respond_with @comment, :status => :unauthorized
    end
  end

  private

  def handle_redirect
    if request.xhr?
      head 200
    else
      redirect_to request.referer
    end
  end

  def find_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end

end
