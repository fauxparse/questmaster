emoji = require "node-emoji"
Item = require "./item"
Hero = require "./hero"

class Reward
  constructor: (tweet) ->
    @tweet = tweet
    @hero = new Hero tweet.user
    @body = @tweet.text.replace /^[\.\s]*\@[^\s]+\s*/, ""
    console.log "#{@hero.name} completed a quest: #{@body}"

  toString: ->
    (str for str in [@salutation(), @xp(), @gold(), @item()] when str)
      .join("\n")

  salutation: ->
    "@#{@hero.username} Your reward, brave hero:"

  xp: ->
    xp = @body.length * 10 * @hero.level
    "#{emoji.get("star")} #{xp} XP"

  gold: ->
    longest = 0
    coins = 0
    @body.replace /[^\s]+/g, (word) ->
      longest = Math.max word.length, longest
      coins += word.length * word.length * 5
    complexity = Math.max(0, Math.min(3, Math.floor(longest / 2) - 4))
    coinage = ["CP", "SP", "GP", "PP"][complexity]
    "#{emoji.get("moneybag")} #{coins} #{coinage}"

  item: ->
    Item.random(@hero.level).toString()

module.exports = Reward
