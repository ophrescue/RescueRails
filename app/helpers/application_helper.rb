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
    @title ||= I18n.t("title.#{controller_name}.#{action_name}")

    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  def base_title
    'Operation Paws for Homes'
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = (column == params[:sort]) ? "current #{params[:direction]}" : nil
    direction = (column == params[:sort] && params[:direction] == 'asc') ? 'desc' : 'asc'
    status = params[:status]
    link_to title, { sort: column, direction: direction, status: status }, { class: css_class }
  end
end
