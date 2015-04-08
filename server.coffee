nTwitter = require "ntwitter"
http = require "http"

Reward = require "./reward"

options =
  twitter:
    username: process.env.TWITTER_USERNAME
    consumer_key: process.env.CONSUMER_KEY
    consumer_secret: process.env.CONSUMER_SECRET
    access_token_key: process.env.ACCESS_TOKEN
    access_token_secret: process.env.ACCESS_TOKEN_SECRET

twitter = new nTwitter options.twitter

listen = ->
  twitter.verifyCredentials (err, data) ->
    err && console.log "Bad Twitter credentials."
  .stream "user", { track: options.twitter.username }, (stream) ->
    console.log "Listening for tweets to @#{options.twitter.username}…"

    stream.on "data", (data) ->
      if data.user? && data.in_reply_to_screen_name == options.twitter.username
        reward = new Reward data
        id = data.id_str
        twitter.updateStatus reward.toString(), in_reply_to_status_id: id, ->

    stream.on "end", reconnect
    stream.on "destroy", reconnect

reconnect = ->
  console.log "Reconnecting…"
  setTimeout 1000, listen

listen()

http.createServer((request, response) ->)
  .listen(process.env.PORT || 5000)
