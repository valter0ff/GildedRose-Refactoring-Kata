# frozen_string_literal: true

require 'rspec'
require 'debug'
require_relative '../item'
require_relative '../gilded_rose'

describe GildedRose do
  let(:gilded_rose) { GildedRose.new(items) }

  shared_examples 'quality degradation over days' do |days, expected_results|
    it "updates the quality and sell_in over #{days} days" do
      days.times do |day|
        gilded_rose.update_quality
        expected_sell_in, expected_quality = expected_results[:"Day #{day + 1}"]

        expect(items.first.sell_in).to eq(expected_sell_in)
        expect(items.first.quality).to eq(expected_quality)
      end
    end
  end

  context 'Normal item' do
    context 'with sell_in == 10' do
      let(:items) { [Item.new('+5 Dexterity Vest', 10, 20)] }

      it_behaves_like 'quality degradation over days', 10, {
        'Day 1': [9, 19],
        'Day 2': [8, 18],
        'Day 3': [7, 17],
        'Day 4': [6, 16],
        'Day 5': [5, 15],
        'Day 6': [4, 14],
        'Day 7': [3, 13],
        'Day 8': [2, 12],
        'Day 9': [1, 11],
        'Day 10': [0, 10]
      }
    end

    context 'with sell_in == 5' do
      let(:items) { [Item.new('Elixir of the Mongoose', 5, 12)] }

      it_behaves_like 'quality degradation over days', 10, {
        'Day 1': [4, 11],
        'Day 2': [3, 10],
        'Day 3': [2, 9],
        'Day 4': [1, 8],
        'Day 5': [0, 7],
        'Day 6': [-1, 5],
        'Day 7': [-2, 3],
        'Day 8': [-3, 1],
        'Day 9': [-4, 0],
        'Day 10': [-5, 0]
      }
    end
  end

  context 'Aged Brie' do
    let(:items) { [Item.new('Aged Brie', 2, 0)] }

    it_behaves_like 'quality degradation over days', 10, {
      'Day 1': [1, 1],
      'Day 2': [0, 2],
      'Day 3': [-1, 4],
      'Day 4': [-2, 6],
      'Day 5': [-3, 8],
      'Day 6': [-4, 10],
      'Day 7': [-5, 12],
      'Day 8': [-6, 14],
      'Day 9': [-7, 16],
      'Day 10': [-8, 18]
    }
  end

  context 'Backstage passes' do
    context 'with sell_in > 10' do
      let(:items) { [Item.new('Backstage passes to a TAFKAL80ETC concert', 15, 20)] }

      it_behaves_like 'quality degradation over days', 10, {
        'Day 1': [14, 21],
        'Day 2': [13, 22],
        'Day 3': [12, 23],
        'Day 4': [11, 24],
        'Day 5': [10, 25],
        'Day 6': [9, 27],
        'Day 7': [8, 29],
        'Day 8': [7, 31],
        'Day 9': [6, 33],
        'Day 10': [5, 35]
      }
    end

    context 'with sell_in 10' do
      let(:items) { [Item.new('Backstage passes to a TAFKAL80ETC concert', 10, 49)] }

      it_behaves_like 'quality degradation over days', 10, {
        'Day 1': [9, 50],
        'Day 2': [8, 50],
        'Day 3': [7, 50],
        'Day 4': [6, 50],
        'Day 5': [5, 50],
        'Day 6': [4, 50],
        'Day 7': [3, 50],
        'Day 8': [2, 50],
        'Day 9': [1, 50],
        'Day 10': [0, 50]
      }
    end

    context 'with sell_in 5' do
      let(:items) { [Item.new('Backstage passes to a TAFKAL80ETC concert', 5, 20)] }

      it_behaves_like 'quality degradation over days', 10, {
        'Day 1': [4, 23],
        'Day 2': [3, 26],
        'Day 3': [2, 29],
        'Day 4': [1, 32],
        'Day 5': [0, 35],
        'Day 6': [-1, 0],
        'Day 7': [-2, 0],
        'Day 8': [-3, 0],
        'Day 9': [-4, 0],
        'Day 10': [-5, 0]
      }
    end
  end

  context 'Sulfuras, Hand of Ragnaros' do
    let(:items) { [Item.new('Sulfuras, Hand of Ragnaros', 0, 80)] }

    context 'with sell_in 0' do
      it_behaves_like 'quality degradation over days', 5, {
        'Day 1': [0, 80],
        'Day 2': [0, 80],
        'Day 3': [0, 80],
        'Day 4': [0, 80],
        'Day 5': [0, 80],
        'Day 6': [0, 80],
        'Day 7': [0, 80],
        'Day 8': [0, 80],
        'Day 9': [0, 80],
        'Day 10': [0, 80]
      }
    end

    context 'with sell_in -1' do
      let(:items) { [Item.new('Sulfuras, Hand of Ragnaros', -1, 80)] }

      it_behaves_like 'quality degradation over days', 5, {
        'Day 1': [-1, 80],
        'Day 2': [-1, 80],
        'Day 3': [-1, 80],
        'Day 4': [-1, 80],
        'Day 5': [-1, 80],
        'Day 6': [-1, 80],
        'Day 7': [-1, 80],
        'Day 8': [-1, 80],
        'Day 9': [-1, 80],
        'Day 10': [-1, 80]
      }
    end
  end

  context 'Conjured item' do
    let(:items) { [Item.new('Conjured Mana Cake', 8, 12)] }

    it_behaves_like 'quality degradation over days', 5, {
      'Day 1': [7, 10],
      'Day 2': [6, 8],
      'Day 3': [5, 6],
      'Day 4': [4, 4],
      'Day 5': [3, 2],
      'Day 6': [2, 0],
      'Day 7': [1, 0],
      'Day 8': [0, 0],
      'Day 9': [-1, 0],
      'Day 10': [-2, 0]
    }
  end

  context 'dummy' do
    let(:items) { [Item.new('foo', 0, 0)] }

    it 'does not change the name' do
      gilded_rose.update_quality
      expect(items[0].name).to eq 'foo'
    end
  end
end
