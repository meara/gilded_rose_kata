def update_quality(items)
  items.each do |item|
    update_item_quality(item)
    update_item_sell_in(item)
  end
end

private

def update_item_sell_in(item)
  item.sell_in -= 1 unless item.name == 'Sulfuras, Hand of Ragnaros'
end

def update_item_quality(item)
  if item.name == 'Sulfuras, Hand of Ragnaros'
    SulfurasItemUpdater.new(item).update_quality
  elsif item.name == 'Backstage passes to a TAFKAL80ETC concert'
    BackstagePassItemUpdater.new(item).update_quality
  elsif item.name == 'Aged Brie'
    BrieItemUpdater.new(item).update_quality
  elsif !!item.name.match(/\AConjured.*/)
    ConjuredItemUpdater.new(item).update_quality
  else
    ItemUpdater.new(item).update_quality
  end
end

class ItemUpdater
  attr_reader :item

  def initialize(item)
    @item = item
  end

  def update_quality
    if item.sell_in > 0
      increment_quality(item, -1)
    else
      increment_quality(item, -2)
    end
  end

  private

  def increment_quality(item, amount)
    item.quality += amount
    item.quality = 50 if item.quality > 50
    item.quality = 0 if item.quality < 0
  end
end

class SulfurasItemUpdater < ItemUpdater
  def update_quality
  end
end

class BackstagePassItemUpdater < ItemUpdater
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
  def update_quality
    if item.sell_in > 0
      increment_quality(item, 1)
    else
      increment_quality(item, 2)
    end
  end
end

class ConjuredItemUpdater < ItemUpdater
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

