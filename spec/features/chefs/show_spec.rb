require 'rails_helper'
require 'faker'

RSpec.describe 'Chef show page' do
  before :each do
    Faker::Lorem.unique.clear
    Faker::Food.unique.clear
    @chef1 = Chef.create!(name: Faker::Name.name)
    @chef2 = Chef.create!(name: Faker::Name.name)
    @pie = @chef1.dishes.create!(name: Faker::Food.unique.dish, description: Faker::Lorem.unique.sentence)
    @stroodle = @chef1.dishes.create!(name: Faker::Food.unique.dish, description: Faker::Lorem.unique.sentence)
    @other_dish = @chef2.dishes.create!(name: Faker::Food.unique.dish, description: Faker::Lorem.unique.sentence)

    @ing1 = @pie.ingredients.create!(name: Faker::Food.unique.ingredient, calories: Faker::Number.between(from: 1, to: 5000))
    @ing2 = @pie.ingredients.create!(name: Faker::Food.unique.ingredient, calories: Faker::Number.between(from: 1, to: 5000))
    @ing3 = @pie.ingredients.create!(name: Faker::Food.unique.ingredient, calories: Faker::Number.between(from: 1, to: 5000))
    @ing4 = @pie.ingredients.create!(name: Faker::Food.unique.ingredient, calories: Faker::Number.between(from: 1, to: 5000))
    @stroodle.ingredients << @ing1
    @stroodle.ingredients << @ing2
    @ing5 = @stroodle.ingredients.create!(name: Faker::Food.unique.ingredient, calories: Faker::Number.between(from: 1, to: 5000))
    @other_dish.ingredients << @ing2
    @other_dish.ingredients << @ing3

    visit chef_path(@chef1)
  end

  describe 'as a user'
    describe 'visit the chef show page' do
      it 'has the chef name' do
        within "#chef_name" do
          expect(page).to have_content(@chef1.name)
          expect(page).to_not have_content(@chef2.name)
        end
      end

      it 'has a link to all the ingredients chef uses in their dishes' do
        expect(page).to have_link("Chef's Ingredients")
        click_on("Chef's Ingredients")
        expect(current_path).to eq(chef_ingredients_path(@chef1))
      end

      it 'has a list of all ingredients for that dish' do

        @pie2 = @chef1.dishes.create!(name: Faker::Food.unique.dish, description: Faker::Lorem.unique.sentence)
        @pie2.ingredients << @ing1
        @pie2.ingredients << @ing2
        @pie2.ingredients << @ing4
        @pie3 = @chef1.dishes.create!(name: Faker::Food.unique.dish, description: Faker::Lorem.unique.sentence)
        @pie3.ingredients << @ing2

        popular_ingredients = [@ing1, @ing2, @ing4]
        within "#popular_ingredients" do
          pie_ingredients.each do |ingredient|
            within "#pop_ingredient_#{ingredient.id}" do
              expect(page).to have_content(ingredient.name)
              expect(page).to_not have_content(@ing3.name)
              expect(page).to_not have_content(@ing5.name)
            end
          end
        end
      end
    end
end