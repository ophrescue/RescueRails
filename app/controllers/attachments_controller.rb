class AttachmentsController < ApplicationController

	respond_to :html, :json
	before_filter :authenticate

	def index
		redirect_to :root
	end

	def destroy
		Attachment.find(params[:id]).destroy
		flash[:success] = "Attachment Deleted"
		redirect_to folders_path
	end

	def show
		@attachment = Attachment.find(params[:id])

		send_file @attachment.attachment.path,
				 :type => @attachment.attachment_content_type,
				 :filename => @attachment.attachment_file_name,
				 :disposition => 'inline'
	end



end
