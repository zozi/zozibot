# Assign roles to people you're chatting with
#
# <user> is a badass guitarist - assign a role to a user
# <user> is not a badass guitarist - remove a role from a user
# who is <user> - see what roles a user has

# hubot holman is an ego surfer
# hubot holman is not an ego surfer
#

module.exports = (robot) ->

  getAmbiguousUserText = (users) ->
    "Be more specific, I know #{users.length} people named like that: #{(user.name for user in users).join(", ")}"

  robot.hear /(who has|what\'s up with) staging?/i, (msg) ->
    users = robot.brain.data.users
    for own key, user of robot.brain.data.users
      roles = user.roles or []
      if /using staging/.test roles.join(" ")
        stagingOwner = user
    if stagingOwner
      msg.send "#{stagingOwner.name} has staging"
    else
      msg.send "No one has told me they have staging."
