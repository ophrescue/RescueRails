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

module ApplicationHelper
  def logo
    image_tag('logo.png', alt: 'Operation Paws for Homes')
  end

  def markdown(text)
    options = {
      filter_html:     true,
      hard_wrap:       true,
      link_attributes: { rel: 'nofollow', target: '_blank' },
      space_after_headers: true,
      fenced_code_blocks: true
    }

    extensions = {
      autolink:           true,
      superscript:        true,
      disable_indented_code_blocks: true
    }

    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)

    markdown.render(text).html_safe
  end

  def title
    @title ||= I18n.t("#{controller_i18n(controller_path)}.#{action_name}.title")
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  def base_title
    'Operation Paws for Homes'
  end

  def controller_i18n(controller_path)
    controller_path.gsub!('/','.') if controller_path.include?('/')
    controller_path
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_id = "sort_by_#{column}"
    css_class = column == params[:sort] ? "current #{params[:direction]}" : nil
    direction = column == params[:sort] && params[:direction] == 'asc' ? 'desc' : 'asc'
    status = params[:status]
    search_term = params[:search]
    is_status = params[:is_status]
    is_age = params[:is_age]
    is_size = params[:is_size]
    is_breed = params[:is_breed]
    commit = params[:commit]
    link_to title, { commit: commit, sort: column, direction: direction, status: status, search: search_term, is_size: is_size, is_age: is_age, is_status: is_status, is_breed: is_breed }, { class: css_class, id: css_id }
  end

  def submit_or_return_to(f,return_path)
    render partial: 'shared/submit_or_cancel', locals: {f:f, return_path:return_path}
  end

  def unlocked_user
    if current_user.locked?
      cookies.delete(:remember_token)
      flash[:error] = 'Your account is locked.  You must contact Joanne@ophrescue.org to reactivate your account'
      redirect_to(root_path)
    else
      return true
    end
  end

end
