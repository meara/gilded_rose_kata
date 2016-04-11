def update_quality(items)
  items.each do |item|
    update_item_quality(item)
    update_item_sell_in(item)
  end
end

private

def update_item_quality(item)
  if item.name == 'Backstage passes to a TAFKAL80ETC concert'
    if item.quality < 50
      if item.sell_in <= 0
        item.quality = 0
      elsif item.sell_in < 6
        item.quality += 3
      elsif item.sell_in < 11
        item.quality += 2
      else
        item.quality += 1
      end
    end
  elsif item.name == 'Aged Brie'
    item.quality += 1 if item.quality < 50
    if item.sell_in <= 0
      item.quality += 1 if item.quality < 50
    end
  elsif item.name != 'Sulfuras, Hand of Ragnaros'
    if item.sell_in > 0
      item.quality -= 1 if item.quality > 0
    else
      item.quality -= 2 if item.quality > 0
    end
  end
end

def update_item_sell_in(item)
  if item.name != 'Sulfuras, Hand of Ragnaros'
    item.sell_in -= 1
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

