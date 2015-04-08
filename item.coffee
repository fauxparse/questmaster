emoji = require "node-emoji"

pick = (array) ->
  array[Math.floor(Math.random() * array.length)]

class Item
  constructor: (level = 1) ->
    @level = level

  emoji: -> emoji.get("package")
  description: -> "Mysterious box"
  toString: -> "#{@emoji()}  #{@description()}"
  @chance: -> 1

  fiddle: (level) ->
    Math.max 0, Math.min 9, (level + Math.floor(Math.random() * 4) - 2)

  @random: (level = 1) ->
    items = []
    for klass in @all
      if chance = klass.chance(level)
        for i in [1..chance]
          items.push new klass(level)
    i = Math.floor(Math.random() * items.length)
    items[i]

class Weapon extends Item
  constructor: (level) ->
    super
    @bonus = if Math.random() > 0.95 then "+1 " else ""
    @adjective = ["Broken", "Rusty", "Crude", "Simple", "Handy", "Quality", "Masterful", "Bejeweled", "Legendary", "Lost"][@fiddle(level)]
    @noun = pick ["Sword", "Axe", "Dagger", "Knife", "Halberd", "Longsword", "Broadsword", "Short Sword"]
    @qualifier = if Math.random() < 0.3
      " of " + pick ["Disemboweling", "Productivity", "Luck", "the Beast", "the Abyss", "the Ages", "Harsh Language"]
    else
      ""

  emoji: -> emoji.get("hocho")
  description: ->
    "#{@adjective} #{@noun}#{@qualifier}"

  @chance: (level) -> level

class Consumable extends Item

class Bread extends Consumable
  emoji: -> emoji.get("bread")
  description: -> "Nourishing Bread"

class Ale extends Consumable
  emoji: -> emoji.get("beer")
  description: -> "Refreshing Ale"

class Apple extends Consumable
  emoji: -> emoji.get("apple")
  description: -> "Juicy Apple"

class Potion extends Consumable
  emoji: ->
    if @level < 5
      emoji.get("baby_bottle")
    else
      emoji.get("wine")

  description: ->
    size = if @level < 5 then "Small" else "Large"
    "#{size} health potion"

class Treasure extends Item
  constructor: (level) ->
    super
    @descriptor = if Math.random() < 0.4
      pick(["Small", "Large", "Mysterious", "Depleted", "Interesting", "Curious"]) + " "
    else
      ""
    @container = pick ["Box", "Jar", "Tube", "Bottle", "Assortment", "Pouch", "Purse"]
    @contents = pick ["Spiders", "Mysteries", "Shadows", "Gemstones", "Wood Shavings", "Teeth", "Regrets", "Sandwiches", "Goblin Pubes", "Buttons", "Boiled Sweets", "Coloured Sand", "Marbles", "Lint", "Dried Peas", "Bath Salts", "Bees", "Chickpeas", "Carved Figures", "Knucklebones", "Leather Scraps", "Rubies", "Emeralds", "Pretzels"]

  description: ->
    "#{@descriptor}#{@container} of #{@contents}"

  @chance: (level) -> 2

Weapon.all = [Weapon]
Consumable.all = [Bread, Ale, Apple, Potion]
Item.all = [Treasure].concat(Consumable.all).concat(Weapon.all)

module.exports = Item
