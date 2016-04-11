def update_quality(items)
  items.each do |item|
    item_updater(item).update
  end
end

private

def item_updater(item)
  if item.name == 'Sulfuras, Hand of Ragnaros'
    SulfurasItemUpdater.new(item)
  elsif item.name == 'Backstage passes to a TAFKAL80ETC concert'
    BackstagePassItemUpdater.new(item)
  elsif item.name == 'Aged Brie'
    BrieItemUpdater.new(item)
  elsif !!item.name.match(/\AConjured.*/)
    ConjuredItemUpdater.new(item)
  else
    ItemUpdater.new(item)
  end
end

class ItemUpdater
  attr_reader :item

  def initialize(item)
    @item = item
  end

  def update
    update_quality
    update_sell_in
  end

  private

  def update_quality
    if item.sell_in > 0
      increment_quality(item, -1)
    else
      increment_quality(item, -2)
    end
  end

  def update_sell_in
    item.sell_in -= 1
  end

  def increment_quality(item, amount)
    item.quality += amount
    item.quality = 50 if item.quality > 50
    item.quality = 0 if item.quality < 0
  end
end

class SulfurasItemUpdater < ItemUpdater
  def update
  end
end

class BackstagePassItemUpdater < ItemUpdater
  private
  def update_quality
    if item.sell_in <= 0
      item.quality = 0
    elsif item.sell_in < 6
      increment_quality(item, 3)
    elsif item.sell_in < 11
      increment_quality(item, 2)
    else
      increment_quality(item, 1)
    end
  end
end

class BrieItemUpdater < ItemUpdater
  private
  def update_quality
    if item.sell_in > 0
      increment_quality(item, 1)
    else
      increment_quality(item, 2)
    end
  end
end

class ConjuredItemUpdater < ItemUpdater
  private
  def update_quality
    if item.sell_in > 0
      increment_quality(item, -2)
    else
      increment_quality(item, -4)
    end
  end
end

# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]

