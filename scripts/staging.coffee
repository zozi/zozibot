# Track who has staging
#
# who has staging? - find out who has staging
# what's up with staging? - find out who has staging
# staging is (all) clear - clears out the staging user
# can I (have|use) staging - ask for staging
# i can haz staging? - ask for staging

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

  robot.hear /(?:[iI] can|[cC]an [iI]) (?:have|haz|use) staging\??/, (msg) ->
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
