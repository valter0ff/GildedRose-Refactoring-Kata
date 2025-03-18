# frozen_string_literal: true

class ItemUpdater
  attr_reader :item

  def initialize(item)
    @item = item
  end

  def self.for(item)
    case item.name
    when 'Aged Brie' then AgedBrieUpdater.new(item)
    when 'Backstage passes to a TAFKAL80ETC concert' then BackstagePassUpdater.new(item)
    when 'Sulfuras, Hand of Ragnaros' then LegendaryItemUpdater.new(item)
    when /^Conjured/ then ConjuredItemUpdater.new(item)
    else NormalItemUpdater.new(item)
    end
  end

  def update
    decrease_sell_in unless legendary?
  end

  protected

  def decrease_sell_in
    item.sell_in -= 1
  end

  def increase_quality(amount = 1)
    item.quality = [item.quality + amount, 50].min
  end

  def decrease_quality(amount = 1)
    item.quality = [item.quality - amount, 0].max
  end

  def legendary?
    item.is_a?(LegendaryItemUpdater) || item.name == 'Sulfuras, Hand of Ragnaros'
  end
end

class NormalItemUpdater < ItemUpdater
  def update
    super
    amount = item.sell_in.negative? ? 2 : 1
    decrease_quality(amount)
  end
end

class AgedBrieUpdater < ItemUpdater
  def update
    super
    amount = item.sell_in.negative? ? 2 : 1
    increase_quality(amount)
  end
end

class BackstagePassUpdater < ItemUpdater
  QUALITY_INCREASE_RATES = {
    (0...5) => 3,
    (5...10) => 2,
    (10..) => 1
  }.freeze

  def update
    super
    return item.quality = 0 if item.sell_in.negative?

    amount = QUALITY_INCREASE_RATES.find { |range, _| range.cover?(item.sell_in) }.last
    increase_quality(amount)
  end
end

class ConjuredItemUpdater < ItemUpdater
  def update
    super
    amount = item.sell_in.negative? ? 4 : 2
    decrease_quality(amount)
  end
end

class LegendaryItemUpdater < ItemUpdater
  # "Sulfuras" never changes
  def update; end
end
