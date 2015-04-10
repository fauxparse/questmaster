emoji = require "node-emoji"

pick = (array) ->
  array[Math.floor(Math.random() * array.length)]

class Item
  constructor: (level = 1) ->
    @level = level

  emoji: -> emoji.get("package")
  description: -> "Mysterious box"
  toString: -> "#{@emoji()} #{@description()}"
  @chance: -> 1

  fiddle: (level) ->
    Math.max 0, Math.min 9, (level + Math.floor(Math.random() * 4) - 2)

  @random: (level = 1) ->
    items = []
    for klass in @all
      if chance = klass.chance(level)
        for i in [1..chance]
          items.push new klass(level)
    pick items

class Weapon extends Item
  constructor: (level) ->
    super
    @bonus = if Math.random() < 0.1 then "+1 " else ""
    @adjective = ["Broken", "Rusty", "Crude", "Simple", "Handy", "Quality", "Masterful", "Bejewelled", "Legendary", "Lost"][@fiddle(level)]
    @noun = pick ["Sword", "Axe", "Dagger", "Knife", "Halberd", "Longsword", "Broadsword", "Short Sword", "Staff", "Stick", "Crossbow", "Longbow", "Bow"]
    @qualifier = if Math.random() < 0.5
      " of " + pick ["Disembowelling", "Productivity", "Luck", "the Beast", "the Abyss", "the Ages", "Harsh Language", "Biting", "Manners", "Farts", "Time", "Forgetfulness", "Clues", "Smiting", "Passive Aggression"]
    else
      ""

  emoji: -> emoji.get("hocho")
  description: ->
    "#{@adjective} #{@noun}#{@qualifier}"

  @chance: (level) -> level + 1

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
      emoji.get("wine_glass")

  description: ->
    size = if @level < 5 then "Small" else "Large"
    "#{size} Health Potion"

class Treasure extends Item
  constructor: (level) ->
    super
    @descriptor = if Math.random() < 0.5
      pick(["Small", "Large", "Mysterious", "Depleted", "Interesting", "Curious", "Glowing", "Humming"]) + " "
    else
      ""
    @container = pick ["Box", "Jar", "Tube", "Bottle", "Assortment", "Pouch", "Purse", "Bag"]
    @contents = pick ["Spiders", "Mysteries", "Shadows", "Gemstones", "Wood Shavings", "Teeth", "Regrets", "Sandwiches", "Goblin Pubes", "Buttons", "Boiled Sweets", "Coloured Sand", "Marbles", "Lint", "Dried Peas", "Bath Salts", "Bees", "Chickpeas", "Carved Figures", "Knucklebones", "Leather Scraps", "Rubies", "Emeralds", "Pretzels", "Crayons", "Herbs", "Ghosts", "Licorice Allsorts"]

  description: ->
    "#{@descriptor}#{@container} of #{@contents}"

  @chance: (level) -> level * 2 + 1

Weapon.all = [Weapon]
Consumable.all = [Bread, Ale, Apple, Potion]
Item.all = [Treasure].concat(Consumable.all).concat(Weapon.all)

module.exports = Item
