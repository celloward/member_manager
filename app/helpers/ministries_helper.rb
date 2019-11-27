module MinistriesHelper

  def ministry_params
    params.require(:ministry).permit(:name, :leadership_id)  
end
