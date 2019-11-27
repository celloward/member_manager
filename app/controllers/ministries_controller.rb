class MinistriesController < ApplicationController
  def new
    @ministry = Ministry.new
  end

  def create
    @ministry = Ministry.new(ministry_params)
  end
  
end
