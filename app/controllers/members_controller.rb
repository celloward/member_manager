class MembersController < ApplicationController
  
  def new
    @member = Member.new
  end
  
  def create
    @member = Member.new(member_params)
    if @member.save
      redirect_to member_url(@member)
    else
      render :new
    end
  end
end
