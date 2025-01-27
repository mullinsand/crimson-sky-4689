require 'rails_helper'

RSpec.describe Dish, type: :model do
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
    @water = @chef1.dishes.create!(name: 'water', description: 'just water')
  end

  describe "validations" do
    it {should validate_presence_of :name}
    it {should validate_presence_of :description}
  end
  describe "relationships" do
    it {should belong_to :chef}
    it {should have_many :dish_ingredients}
    it {should have_many(:ingredients).through(:dish_ingredients)}
  end

  describe 'dish methods' do
    describe '#total_calories' do
      it 'sums the calories of all ingredients in that dish' do
        total_pie_calories = @ing1.calories + @ing2.calories + @ing3.calories + @ing4.calories
        total_stroodle_calories = @ing1.calories + @ing2.calories + @ing5.calories
        total_other_dish_calories = @ing2.calories + @ing3.calories
        expect(@pie.total_calories).to eq(total_pie_calories)
        expect(@stroodle.total_calories).to eq(total_stroodle_calories)
        expect(@other_dish.total_calories).to eq(total_other_dish_calories)
      end

      context 'when there are no ingredients in that dish' do
        it 'returns 0' do
          expect(@water.total_calories).to eq(0)
        end
      end
    end

  end
end