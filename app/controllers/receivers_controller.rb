# frozen_string_literal: true

# Email registery
class ReceiversController < ApplicationController
  def new
    @receiver = Receiver.new
  end

  def create
    @receiver = Receiver.new(receiver_params)

    if @receiver.save
      flash[:notice] = "#{@receiver.email} have been registered successfully."

      redirect_to action: :new
    else
      flash[:alert] = "#{@receiver.email} couldn't register because #{error_message}"

      render :new
    end
  end

  private

  def receiver_params
    params.require(:receiver).permit(:email)
  end

  def error_message
    @receiver.errors.full_messages.map { |message| "`#{message}`" }.join(' and ') + '.'
  end
end
