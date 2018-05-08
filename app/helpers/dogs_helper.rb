module DogsHelper
  def index_page_title
    session[:mgr_view] ? 'Dog Manager' : 'Our Dogs'
  end
end
