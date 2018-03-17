class LinesController < ApplicationController
  before_action :check_user_role
  before_action :find_line, only: :destroy

  def create
    LinesEngine.new(lines_params).build
  end

  def destroy
    @line.destroy
  end

  private def find_line
    @line = Line.find_by(id: params[:id])
    render_404 if @line.nil?
  end

  private def lines_params
    params.require(:lines).permit!
  end
end
