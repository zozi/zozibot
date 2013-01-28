# Description:
#   Send messages to users the next time they speak
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot ambush <user name>: <message>
#
# Author:
#   jmoses

appendAmbush = (robot, toUser, fromUser, message) ->
  ambushes = robot.brain.data.ambushes || {}
  if ambushes[toUser.name]
    ambushes[toUser.name].push [fromUser.name, message]
  else
    ambushes[toUser.name] = [[fromUser.name, message]]
  robot.brain.data.ambushes = ambushes

module.exports = (robot) ->
  robot.respond /ambush (.*): (.*)/i, (msg) ->
    users = robot.brain.usersForFuzzyName(msg.match[1].trim())
    if users.length is 1
      user = users[0]
      appendAmbush(robot, user, msg.message.user, msg.match[2])
      msg.send "Ambush prepared"
    else if users.length > 1
      msg.send "Too many users like that"
    else
      msg.send "#{msg.match[1]}? Never heard of 'em"
  
  robot.hear /./i, (msg) ->
    ambushes = robot.brain.data.ambushes || {}
    if (user_ambushes = ambushes[msg.message.user.name])
      for ambush in user_ambushes
        msg.send "@" + msg.message.user.name + " " + ambush[0] + " said: " + ambush[1] + "   (while you were out.)"
      delete robot.brain.data.ambushes[msg.message.user.name]
