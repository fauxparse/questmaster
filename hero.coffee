class Hero
  constructor: (user) ->
    @name = user.name
    @username = user.screen_name
    @level = Math.floor(user.followers_count / 100) + 1

module.exports = Hero
