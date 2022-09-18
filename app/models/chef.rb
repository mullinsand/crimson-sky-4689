class Chef < ApplicationRecord
  validates_presence_of :name
  has_many :dishes

  def unique_ingredients
    Ingredient.joins(:dishes).where("dishes.chef_id = ?", self.id).distinct
  end

  def top_three_popular_ingredients
    Ingredient.joins(:dishes).select(:name, "count(ingredients.name) as ing_count").where("dishes.chef_id = ?", self.id).group(:name).order(ing_count: :desc).limit(3)
  end
end