# Description:
#   Allows Hubot to give a look of disapproval
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot lod <name> - gives back the character for the look of disapproval, optionally @name
#
# Author:
#   ajacksified

module.exports = (robot) ->
  robot.respond /lod(x\d+)?\s?(.*)/i, (msg) ->
    repeat = msg.match[1] || '1'
    repeat = parseInt repeat.replace(/x/,''), 10
    response = Array(repeat + 1).join 'ಠ_ಠ '

    name = msg.match[2].trim()
    response += " @" + name if name != ""

    msg.send(response)
