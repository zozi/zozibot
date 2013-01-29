# Assign roles to people you're chatting with
#
# <user> is a badass guitarist - assign a role to a user
# <user> is not a badass guitarist - remove a role from a user
# who is <user> - see what roles a user has

# hubot holman is an ego surfer
# hubot holman is not an ego surfer
#

module.exports = (robot) ->

  getStagingOwner = (users) ->
    for own key, user of users
      roles = user.roles or []
      if /using staging/.test roles.join(" ")
        stagingOwner = user
    stagingOwner

  clearStagingOwner = (data) ->
    for own key, user of data.users
      roles = user.roles or [ ]
      user.roles = (role for role in roles when role isnt "using staging")

  setStagingOwner = (data, name) ->
    users = robot.brain.usersForFuzzyName(name)
    if users.length is 1
      user = users[0]
      user.roles = user.roles or [ ]
      if "using staging" not in user.roles
        user.roles.push("using staging")


  robot.hear /(who has|what\'s up with) staging?/i, (msg) ->
    stagingOwner = getStagingOwner(robot.brain.data.users)
    if stagingOwner
      msg.send "#{stagingOwner.name} has staging"
    else
      msg.send "No one has told me they have staging."

  robot.hear /staging is( all | )clear/i, (msg) ->
    clearStagingOwner(robot.brain.data)
    msg.send "All clear!"

  robot.hear /can [iI] have staging\??/, (msg) ->
    EMPTY = {}
    stagingOwner = getStagingOwner(robot.brain.data.users) || EMPTY
    if stagingOwner isnt EMPTY 
      if msg.message.user.name == stagingOwner.name
        msg.send "You already have it my little pumpkin pie."
      else
        msg.send "Sorry my sweet little #{stagingOwner.name} has it."
    else
      setStagingOwner(robot.brain.data, msg.message.user.name)
      msg.send "You got it Kimosabe"
