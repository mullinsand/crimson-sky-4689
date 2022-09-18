require 'rails_helper'
require 'faker'

RSpec.describe 'Chef Ingredients index page' do
  before :each do
    Faker::Lorem.unique.clear
    Faker::Food.unique.clear
    @chef1 = Chef.create!(name: Faker::Name.name)
    @chef2 = Chef.create!(name: Faker::Name.name)
    @pie = @chef1.dishes.create!(name: Faker::Food.unique.dish, description: Faker::Food.unique.description)
    @stroodle = @chef1.dishes.create!(name: Faker::Food.unique.dish, description: Faker::Food.unique.description)
    @other_dish = @chef2.dishes.create!(name: Faker::Food.unique.dish, description: Faker::Food.unique.description)

    @ing1 = @pie.ingredients.create!(name: Faker::Food.unique.ingredient, calories: Faker::Number.between(from: 1, to: 5000))
    @ing2 = @pie.ingredients.create!(name: Faker::Food.unique.ingredient, calories: Faker::Number.between(from: 1, to: 5000))
    @ing3 = @pie.ingredients.create!(name: Faker::Food.unique.ingredient, calories: Faker::Number.between(from: 1, to: 5000))
    @ing4 = @pie.ingredients.create!(name: Faker::Food.unique.ingredient, calories: Faker::Number.between(from: 1, to: 5000))
    @stroodle.ingredients << @ing1
    @stroodle.ingredients << @ing2
    @ing5 = @stroodle.ingredients.create!(name: Faker::Food.unique.ingredient, calories: Faker::Number.between(from: 1, to: 5000))
    @other_dish.ingredients << @ing2
    @other_dish.ingredients << @ing3
    @ing6 = @other_dish.ingredients.create!(name: Faker::Food.unique.ingredient, calories: Faker::Number.between(from: 1, to: 5000))


    visit chef_ingredients_path(@chef1)
  end

  describe 'as a user'
    describe 'visit the chef ingredient index page' do
      it 'has a unique list of all ingredients this chef uses' do
        chef_ingredients = [@ing1, @ing2, @ing3, @ing4, @ing5]
        within "#chef_ingredients" do
          chef_ingredients.each do |ingredient|
            within "#ingredient_#{ingredient.id}" do
              expect(page).to have_content(ingredient.name)
              expect(page).to_not have_content(@ing6.name)
            end
          end
        end
      end
    end
end