class AttachmentsController < ApplicationController

  respond_to :html, :json
  before_filter :authenticate

  def index
    redirect_to :root
  end

  def destroy
    Attachment.find(params[:id]).destroy
    flash[:success] = "Attachment Deleted"
    handle_redirect
  end

  def show
    @attachment = Attachment.find(params[:id])
    redirect_to(@attachment.attachment.expiring_url(10))
  end

end
