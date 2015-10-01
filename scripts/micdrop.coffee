# Description:
#   Mic droppage
#
#   Set the environment variable HUBOT_SHIP_EXTRA_SQUIRRELS (to anything)
#   for additional motivation
#
# Dependencies:
#   None
#
# Commands:
#   drops the mic | mic drop - show a mic drop image
#
# Author:
#   evanhourigan

micdrops = [
  "https://media.giphy.com/media/rq47PJe34Dj4k/giphy.gif",
  "https://media.giphy.com/media/qaFduOMYKkmwE/giphy.gif",
  "https://media.giphy.com/media/veL6DyCLYL3Fu/giphy.gif",
  "https://media.giphy.com/media/13py6c5BSnBkic/giphy.gif"
  "https://media.giphy.com/media/ZOLcVvXARqWk0/giphy.gif",
  "https://media.giphy.com/media/rfWAomOTPeOo8/giphy.gif",
  "https://media.giphy.com/media/IOCXHPvn3WErm/giphy.gif",
  "https://media.giphy.com/media/1NLE06PXA9TIA/giphy.gif",
  "https://media.giphy.com/media/yoJC2kLkvesUBfvtxS/giphy.gif",
  "https://media.giphy.com/media/iBifnOQ3ZodBC/giphy.gif",
  "https://media.giphy.com/media/6UiuzrSbRCts4/giphy.gif",
  "http://i.imgur.com/D3eWWTE.gif",
  "https://media.giphy.com/media/b7FNjKdGXEFos/giphy.gif",
  "https://media.giphy.com/media/DfbpTbQ9TvSX6/giphy.gif",
  "https://media.giphy.com/media/qqDoi59GPpwn6/giphy.gif"
]

module.exports = (robot) ->

  robot.hear /mic drop|drops the mic/i, (msg) ->
    msg.send msg.random micdrops
