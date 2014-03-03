# Description:
#   Remind people that @adam and @chris have changed their @mention name
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot listens for @adam or @chris names and responds.
#
# Author:
#   radixhound

module.exports = (robot) ->
    robot.hear /\@adam/i, (msg) ->
        user = robot.brain.usersForFuzzyName(msg.message.user.name)[0]
        msg.send "@#{user.mention_name} YA DUN GOOFED! Did ya mean coopski or brillmuffin?"

module.exports = (robot) ->
    robot.hear /\@chris/i, (msg) ->
        user = robot.brain.usersForFuzzyName(msg.message.user.name)[0]
        msg.send "@#{user.mention_name} (youdungoofed) YA DUN GOOFED! Did ya mean not-silly schille or papa-d the great and powerful?"
