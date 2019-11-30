module PeopleHelper

  def person_params
    params.require(:person).permit(:first_name, :last_name, :email, :address, :city, :state, :zipcode, :phone, :picture, :dob)
  end
end
