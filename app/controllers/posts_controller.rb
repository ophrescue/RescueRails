#    Copyright 2019 Operation Paws for Homes
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

class PostsController < ApplicationController
  # before_action :set_type
  before_action :require_login
  before_action :unlocked_user
  before_action :select_bootstrap41
  before_action :admin_user, only: %i[new create edit update destroy]

  def index
    @posts = type_class.order(created_at: :desc)
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = type_class.new
  end

  def edit; end

  def create
    @post = type_class.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      flash[:success] = "New #{params[:type]} added"
      redirect_to @post
    else
      render 'new'
    end
  end

  def update
    if @post.update(post_params)
      flash[:notice] = "#{params[:type]} updated"
      redirect_to @post
    else
      render 'edit'
    end
  end

  def destroy
    @post = Post.find_by(id: paras[:id])
    @post.destroy
    flash[:notice] = "#{params[:type]} deleted"
    redirect_to dashboards_path
  end

  private

  def admin_user
    flash[:error] = "You aren't allowed to do that." unless current_user.admin?
    redirect_to(root_path) unless current_user.admin?
  end

  def allowed_types
    ['Bulletin', 'Opportunity']
  end

  def type_class
    params[:type].constantize if params[:type].in? allowed_types
  end

  def post_params
    params.require(type_class.name.underscore.to_sym).permit(:title, :content)
  end
end
