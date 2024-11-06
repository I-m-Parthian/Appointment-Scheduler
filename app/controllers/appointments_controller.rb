class AppointmentsController < ApplicationController
  before_action :set_appointment, only: %i[ choose_appointment update destroy ]

  # GET /appointments
  def index
    begin
      slots = Appointment.where(status: "available").select(:id, :status, :date_time).map do |slot|
        {
          id: slot.id,
          status: slot.status,
          date_time: slot.formatted_date_time
        }
      end

      render json: { available_slots: slots }, status: :ok
    rescue => e
      render json: { error: { code: "unknown_error", details: e.message } }, status: :internal_server_error
    end
  end

  # PUT /choose_appointment/1
  def choose_appointment
    if @appointment.status == "available"
      @appointment.status = "booked"
      if @appointment.save
        render json: { message: "Appointment created successfully", appointment: formatted_appointment }, status: :created
      else
        render json: { errors: @appointment.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: { code: "invalid_slot", message: "Given date/time is not available" } }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /appointments/1
  def update
    if @appointment.status == "booked"
      new_appointment = Appointment.where(id: new_appointment_params[:new_appointment_id], status: "available").first
      if new_appointment
        @appointment.update(status: "available")
        new_appointment.update(status: "booked")
        @appointment = new_appointment
        render json: { message: "Appointment created successfully", appointment: formatted_appointment }, status: :created
      else
        render json: { error: { code: "unavailable_slot", message: "New date/time is not available" } }, status: :unprocessable_entity
      end
    else
      render json: { error: { code: "invalid_slot", message: "Given date/time is not available" } }, status: :unprocessable_entity
    end
  end

  # DELETE /appointments/1
  def destroy
    if @appointment.update(status: "canceled")
      render json: { message: "Appointment canceled successfully.", appointment: formatted_appointment }
    else
      render json: { error: { code: "cancellation_failed", message: "Unable to cancel the appointment", details: @appointment.errors.full_messages } }, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_appointment
    @appointment = Appointment.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def new_appointment_params
    params.require(:appointment).permit(:new_appointment_id)
  end

  def formatted_appointment
    {
      id: @appointment.id,
      status: @appointment.status,
      date_time: @appointment.formatted_date_time
    }
  end
end
