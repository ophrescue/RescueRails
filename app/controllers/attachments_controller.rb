class AttachmentsController < ApplicationController

	respond_to :html, :json


	def destroy
		Attachment.find(params[:id]).destroy
		flash[:success] = "Attachment Deleted"
		redirect_to folders_path
	end

end
