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
  before_action :load_treatable
  before_action :edit_pet_check, only: %i[new edit update]
  before_action :admin_user, only: %i[destroy]
  before_action :select_bootstrap41
  before_action :show_user_navbar

  def index
    @available_treatments = Treatment.where(available_for: @treatable.class.name).order(:name)
    @treatment_records = @treatable.treatment_records.order(administered_date: :desc)
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "#{@treatable.name}_medical_records",
               viewport_size: '1280x1024',
               show_as_html: params.key?('debug')
      end
    end
  end

  def new
    @treatment = Treatment.find(params[:treatment_id])
    @treatment_record = TreatmentRecord.new
  end

  def create
    @treatment_record = @treatable.treatment_records.build(treatment_record_params)
    @treatment_record.user_id = current_user.id
    if @treatment_record.save
      flash[:success] = "New Treatment Record Added"
      redirect_to polymorphic_path([@treatable, TreatmentRecord])
    else
      flash.now[:error] = 'form could not be saved'
      @treatment = Treatment.find(params[:treatment_id])
      @treatment_record = TreatmentRecord.new
      render 'new'
    end
  end

  def show
    redirect_to action: "index"
  end

  def edit
    @treatment_record = TreatmentRecord.find(params[:id])
    @treatment = @treatment_record.treatment
  end

  def update
    @treatment_record = TreatmentRecord.find(params[:id])
    if @treatment_record.update(treatment_record_params)
      flash[:success] = "Record updated."
      redirect_to polymorphic_path([@treatable, TreatmentRecord])
    else
      render 'edit'
    end
  end

  def destroy
    TreatmentRecord.find(params[:id]).destroy
    flash[:success] = "Treatment Record deleted."
    redirect_to action: "index"
  end

  private

  def treatment_record_params
    params.require(:treatment_record).permit(:administered_date,
                                             :result,
                                             :comment,
                                             :due_date,
                                             :treatment_id)
  end

  def edit_dogs_user
    redirect_to(root_path) unless current_user.edit_dogs?
  end

  def add_dogs_user
    redirect_to(root_path) unless current_user.add_dogs?
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  def fostering_pet?
    return false unless signed_in?

    @treatable.foster_id == current_user.id
  end

  def load_treatable
    resource, id = request.path.split('/')[1,2]
    @treatable = resource.singularize.classify.constantize.find(id)
  end

  def edit_pet_check
    redirect_to(root_path) unless fostering_pet? || current_user.edit_dogs?
  end

  def active_user
    redirect_to dogs_path unless current_user&.active?
  end
end
