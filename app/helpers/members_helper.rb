module MembersHelper

  def member_params
    params.require(:member).permit(:first_name, :last_name, :email, :address, :city, :state_id, :zipcode, :phone, :picture, :dob)
  end
end
