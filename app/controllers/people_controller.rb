class PeopleController < ApplicationController
  
  def new
    @person = Person.new
  end
  
  def create
    @person = Person.new(person_params)
    if @person.save
      redirect_to person_url(@person)
    else
      render :new
    end
  end
end
