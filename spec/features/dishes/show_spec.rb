require 'rails_helper'
require 'faker'

RSpec.describe 'Dish show page' do
  before :each do
    @chef1 = Chef.create!(name: Faker::Name.name)
    @chef2 = Chef.create!(name: Faker::Name.name)
    @pie = @chef1.dishes.create!(name: Faker::Food.dish, description: Faker::Food.description)
    @stroodle = @chef1.dishes.create!(name: Faker::Food.dish, description: Faker::Food.description)
    @other_dish = @chef2.dishes.create!(name: Faker::Food.dish, description: Faker::Food.description)

    @ing1 = @pie.ingredients.create!(name: Faker::Food.ingredient, calories: Faker::Number.between(from: 1, to: 5000))
    @ing2 = @pie.ingredients.create!(name: Faker::Food.ingredient, calories: Faker::Number.between(from: 1, to: 5000))
    @ing3 = @pie.ingredients.create!(name: Faker::Food.ingredient, calories: Faker::Number.between(from: 1, to: 5000))
    @ing4 = @pie.ingredients.create!(name: Faker::Food.ingredient, calories: Faker::Number.between(from: 1, to: 5000))
    @stroodle.ingredients << @ing1
    @stroodle.ingredients << @ing2
    @ing5 = @stroodle.ingredients.create!(name: Faker::Food.ingredient, calories: Faker::Number.between(from: 1, to: 5000))
    @other_dish.ingredients << @ing2
    @other_dish.ingredients << @ing3

    visit dish_path(@pie)
  end

  describe 'as a user'
    describe 'visit the dish show page' do
      it 'has the dish name and description' do
        within "#dish_name" do
          expect(page).to have_content(@pie.name)
          expect(page).to_not have_content(@stroodle.name)
        end

        within "#dish_description" do
          expect(page).to have_content(@pie.description)
          expect(page).to_not have_content(@stroodle.description)
        end
      end

      it 'has a list of all ingredients for that dish' do
        pie_ingredients = [@ing1, @ing2, @ing3, @ing4]
        within "#dish_ingredients" do
          pie_ingredients.each do |ingredient|
            within "#ingredient_#{ingredient.id}" do
              expect(page).to have_content(ingredient.name)
              expect(page).to_not have_content(@ing5.name)
            end
          end
        end
      end

      it 'has the chefs name that made the dish' do
        within "#dish_chef" do
          expect(page).to have_content(@chef1.name)
          expect(page).to_not have_content(@chef2.name)
        end
      end
    end
end