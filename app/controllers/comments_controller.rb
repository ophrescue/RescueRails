#    Copyright 2017 Operation Paws for Homes
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

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

  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      render @comment
    else
      render action: 'new'
    end
  end

  def update
    if @comment.user_id == current_user.id
      @comment.update_attributes(comment_params)
      render @comment
    else
      head :unauthorized
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
      if name == 'dogs_manager_id'  #duct tape to fix #834
        name = 'dogs_id'
      end                           #end duct tape
      matches = /(.+)_id$/.match(name)

      if matches.present?
        klass = matches[1]
        return klass.classify.constantize.find(value)
      end
    end

    nil
  end
end
