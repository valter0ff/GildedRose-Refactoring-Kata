# frozen_string_literal: true

require_relative 'item_updater'
class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each { |item| ItemUpdater.for(item).update }
  end
end
