#    Copyright 2020 Operation Paws for Homes
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

class TreatmentRecordsController < ApplicationController
  before_action :require_login
  before_action :unlocked_user
  before_action :active_user
  before_action :edit_dog_check, only: %i[new edit update delete]
  before_action :select_bootstrap41
  before_action :show_user_navbar

  def index
    @treatment_records = TreatmentRecord.order(:id)
    respond_to do |format|
      format.html
    end
  end

  def new
    @treatment_record = TreatmentRecord.new
  end

  def create
    @treatment_record = TreatmentRecord.new(treatment_record_params)
    if @treatment_record.save
      flash[:success] = "New Treatment Record Added"
    else
      render 'new'
    end
  end

  def edit
    @treatment_record = TreatmentRecord.find(params[:id])
  end

  def update
    @treatment_record = TreatmentRecord.find(params[:id])
    if @treatment_record.update(treatment_record_params)
      flash[:success] = "Record updated."
    else
      render 'edit'
    end
  end

  private

  def treatment_record_params
    params.require(:treatment_record).permit(:administered_date,
                                             :result,
                                             :comments)
  end
end
