class MulligansController < ApplicationController
  before_action :find_mulligan_position, only: :destroy

  def create
    MulliganConstructor.new(mulligan_params).build
  end

  def destroy
    @position.destroy
  end

  private def find_mulligan_position
    @position = Position.find_by(id: params[:id])
    render_404 if @position.nil?
  end

  private def mulligan_params
    params.require(:mulligans).permit!
  end
end
