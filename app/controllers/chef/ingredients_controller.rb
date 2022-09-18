class Chef::IngredientsController < ApplicationController
  def index
    @ingredients = Chef.find(params[:id]).unique_ingredients
  end
end