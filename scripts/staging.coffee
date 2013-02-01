# Track who has staging
#
# @zozibot <user> is using staging - assign staging to someone else
# who has staging? - find out who has staging
# what's up with staging? - find out who has staging
# staging is (all) clear - clears out the staging user
# can I (have|use) staging - ask for staging
# i can haz staging? - ask for staging

module.exports = (robot) ->

  getResourceOwner = (users, resource) ->
    for own key, user of users
      roles = user.roles or []
      if ///using\s#{resource}///.test roles.join(" ")
        resourceOwner = user
    resourceOwner

  clearResourceOwner = (data, resource) ->
    for own key, user of data.users
      roles = user.roles or [ ]
      user.roles = (role for role in roles when role isnt "using #{resource}")

  setResourceOwner = (data, resource, name) ->
    users = robot.brain.usersForFuzzyName(name)
    if users.length is 1
      user = users[0]
      user.roles = user.roles or [ ]
      if "using #{resource}" not in user.roles
        user.roles.push("using #{resource}")

  appendResource = (brain, resource) ->
    resources = brain.data.resources || {}
    if resources[resource]
      false
    else
      resources[resource] = true
      brain.data.resources = resources
      true

  removeResource = (brain, resource) ->
    resources = brain.data.resources || {}
    if resources[resource]
      delete resources[resource]
      brain.data.resources = resources
      true
    else
      false

  robot.hear /(?:who has|what\'s up with) ([\w.-_]+)?/i, (msg) ->
    resource = msg.match[1].trim()
    if robot.brain.data.resources[resource]
      resourceOwner = getResourceOwner(robot.brain.data.users, resource)
      if resourceOwner
        msg.send "#{resourceOwner.name} has #{resource}"
      else
        msg.send "No one has told me they have #{resource}."
    else
      msg.send "/me scratches its virtual robotic head with a virtual robotic finger"

  robot.hear /([\w.-_]+) is( all | )clear/i, (msg) ->
    resource = msg.match[1].trim()
    if robot.brain.data.resources[resource]
      clearResourceOwner(robot.brain.data, resource)
      msg.send "#{resource} is all clear sugar."
    else
      msg.send "/me goes looking for a #{resource}"

  robot.hear /(?:[iI] can|[cC]an [iI]) (?:have|haz|use) ([\w.-_^?]+)\??/, (msg) ->
    EMPTY = {}
    resource = msg.match[1].trim()
    if robot.brain.data.resources[resource]
      stagingOwner = getResourceOwner(robot.brain.data.users, resource) || EMPTY
      if stagingOwner isnt EMPTY 
        if msg.message.user.name == stagingOwner.name
          msg.send "You already have it my little pumpkin pie."
        else
          msg.send "Sorry my sweet little #{stagingOwner.name} has it."
      else
        setResourceOwner(robot.brain.data, resource, msg.message.user.name)
        msg.send "You got it Kimosabe"
    else
      msg.send "I don't have a shiny #{resource} go play with your own."

  robot.respond /(?:give me|create)(?: a)(?: new) resource ([\w.-_]+)$/i, (msg) ->
    resource = msg.match[1]
    if appendResource robot.brain, resource
      msg.send "Oh, wow. That is the most wonderful #{resource} I have ever seen!"
    else
      msg.send "Meh. Seen it before"

  robot.respond /(?:destroy|blow away|get rid of) the resource ([\w.-_]+)$/i, (msg) ->
    resource = msg.match[1]
    if removeResource robot.brain, resource
      clearResourceOwner(robot.brain.data, resource)
      msg.send "Muahahahaha (boom) (boom) (awyeah)"
    else
      msg.send "WAT?"
