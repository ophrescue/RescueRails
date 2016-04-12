# == Schema Information
#
# Table name: attachments
#
#  id                      :integer          not null, primary key
#  attachable_id           :integer
#  attachable_type         :string(255)
#  attachment_file_name    :string(255)
#  attachment_content_type :string(255)
#  attachment_file_size    :integer
#  attachment_updated_at   :datetime
#  updated_by_user_id      :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  description             :text
#  agreement_type          :string
#

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
