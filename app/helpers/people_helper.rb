module PeopleHelper

  def person_params
    params.require(:person).permit(:first_name, :last_name, :email, :address, :city, :state, :zipcode, :phone, :picture, :dob)
  end

  def to_date date
    Date.strptime(date, "%Y-%m-%d")
  end
end
