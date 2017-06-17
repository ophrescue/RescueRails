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

class AdopterSearcher
  PER_PAGE = 30

  STATUSES = [
    'new',
    'pend response',
    'workup',
    'ready for final',
    'approved'
  ].freeze

  def initialize(params: {})
    @params = params
  end

  def search
    @adopters = Adopter

    if name_search?
      @adopters = @adopters.where('adopters.name ILIKE ?', "%#{@params[:search].strip}%")
    elsif active_status_search?
      @adopters = @adopters.where('adopters.status IN (?)', STATUSES)
    elsif status_search?
      @adopters = @adopters.where(status: @params[:status])
    end

    with_includes
    with_sorting
    for_page(@params[:page])

    @adopters
  end

  def self.search(params: {})
    self.new(params: params).search
  end

  private

  def with_sorting
    if @params[:sort] == 'assigned_to'
      with_join_users_for_sort
      column = 'users.name'
    elsif @params[:sort] == 'comments.updated_at'
      with_join_comments_for_sort
      column = 'CASE WHEN comments.updated_at IS NULL THEN 0 ELSE 1 END desc, comments.updated_at'
    else
      column = sort_column
    end

    @adopters = @adopters.order(column + ' ' + sort_direction)
  end

  def sort_column
    Adopter.column_names.include?(@params[:sort]) ? @params[:sort] : 'id'
  end

  def sort_direction
    %w(asc desc).include?(@params[:direction]) ? @params[:direction] : 'desc'
  end

  def with_includes
    @adopters = @adopters.includes(:user, :comments, :dogs, :adoption_app)
  end

  def with_join_comments_for_sort
    @adopters = @adopters.joins("LEFT JOIN (SELECT commentable_id, max(updated_at) as updated_at FROM comments WHERE commentable_type = 'Adopter' GROUP BY commentable_id) AS comments ON adopters.id = comments.commentable_id")
  end

  def with_join_users_for_sort
    @adopters = @adopters.joins('LEFT OUTER JOIN users ON adopters.assigned_to_user_id = users.id')
  end

  def active_status_search?
    @params[:status] == 'active'
  end

  def status_search?
    @params.has_key? :status
  end

  def name_search?
    @params[:search].present?
  end

  def for_page(page = nil)
    @adopters = @adopters.paginate(per_page: PER_PAGE, page: page || 1)
  end
end
