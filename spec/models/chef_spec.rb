require 'rails_helper'

RSpec.describe Chef, type: :model do
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
    @ing6 = @other_dish.ingredients.create!(name: Faker::Food.ingredient, calories: Faker::Number.between(from: 1, to: 5000))
    @water = @chef1.dishes.create!(name: 'water', description: 'just water')
    
  end

  describe "validations" do
    it {should validate_presence_of :name}
  end
  describe "relationships" do
    it {should have_many :dishes}
  end
  Faker::Lorem.unique.clear
  Faker::Food.unique.clear
  describe 'chef methods' do
    describe '#unique_ingredients' do
      it 'lists all ingredients a chef uses' do
        chef1_all_ingredients = [@ing1, @ing2, @ing3, @ing4, @ing5]
        chef2_all_ingredients = [@ing2, @ing3, @ing6]
        expect(@chef1.unique_ingredients).to eq(chef1_all_ingredients)
        expect(@chef2.unique_ingredients).to eq(chef2_all_ingredients)
      end
      
      it 'no ingredient is listed more than once' do
        chef1_all_ingredients = [@ing1, @ing2, @ing3, @ing4, @ing5]
        expect(@chef1.unique_ingredients.length).to eq(chef1_all_ingredients.length)
      end
    end

    describe '#top_three_popular_ingredients' do
      it 'lists the three most used ingredients by a chef' do
        @pie2 = @chef1.dishes.create!(name: Faker::Food.unique.dish, description: Faker::Lorem.unique.sentence)
        @pie2.ingredients << @ing1
        @pie2.ingredients << @ing2
        @pie2.ingredients << @ing4
        @pie3 = @chef1.dishes.create!(name: Faker::Food.unique.dish, description: Faker::Lorem.unique.sentence)
        @pie3.ingredients << @ing2

        chef1_pop_ingredients = [@ing2.name, @ing1.name, @ing4.name]


        expect(@chef1.top_three_popular_ingredients.first.name).to eq(chef1_pop_ingredients.first)
        expect(@chef1.top_three_popular_ingredients.second.name).to eq(chef1_pop_ingredients.second)
        expect(@chef1.top_three_popular_ingredients.third.name).to eq(chef1_pop_ingredients.third)

      end
    end
  end
end