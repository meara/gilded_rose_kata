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
    update_sulfuras_quality(item)
  elsif item.name == 'Backstage passes to a TAFKAL80ETC concert'
    update_backstage_pass_quality(item)
  elsif item.name == 'Aged Brie'
    update_brie_quality(item)
  elsif !!item.name.match(/\AConjured.*/)
    update_conjured_quality(item)
  else
    update_general_quality(item)
  end
end

def update_brie_quality(item)
  if item.sell_in > 0
    increment_quality(item, 1)
  else
    increment_quality(item, 2)
  end
end

def update_backstage_pass_quality(item)
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

def update_sulfuras_quality(item)
end

def update_conjured_quality(item)
  if item.sell_in > 0
    increment_quality(item, -2)
  else
    increment_quality(item, -4)
  end
end

def update_general_quality(item)
  if item.sell_in > 0
    increment_quality(item, -1)
  else
    increment_quality(item, -2)
  end
end

def increment_quality(item, amount)
  item.quality += amount
  item.quality = 50 if item.quality > 50
  item.quality = 0 if item.quality < 0
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

