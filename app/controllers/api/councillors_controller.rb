class Api::CouncillorsController < ApiController
  def index
  	@councillors = Councillor.all

  	render json: @councillors
  end

  def show
  	@councillor = Councillor.find(params[:id])

		render json: @councillor, serializer: CouncillorDetailSerializer
  end
end
