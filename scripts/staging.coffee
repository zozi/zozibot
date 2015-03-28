# Track who has a resource
#
# @zozibot <user> is using <resource> - assign <resource> to someone else
# who has <resource>? - find out who has the resource
# what's up with <resource>? - find out who has the resource
# <resource> is (all) clear - clears out the resource user
# can I (have|use) <resource> - ask for the resource
# i can haz <resource>? - ask for the resource
# @zozibot create a resource <resource> - creates a new resource
# @zozibot destroy the resource <resource> - blow away the resource

module.exports = (robot) ->

  getResourceOwner = (users, resource) ->
    for own key, user of users
      roles = user.roles or []
      if ///using\s#{resource}///.test roles.join(" ")
        resourceOwner = user
    resourceOwner

  getResourceBackup = (users, resource) ->
    for own key, user of users
      roles = user.roles or []
      if ///has\sdibs\son\s#{resource}///.test roles.join(" ") 
        resourceBackup = user
    resourceBackup

  clearResourceOwner = (data, resource) ->
    for own key, user of data.users
      roles = user.roles or [ ]
      user.roles = (role for role in roles when role isnt "using #{resource}")

  clearResourceBackup = (data, resource) ->
    for own key, user of data.users
      roles = user.roles or [ ]
      user.roles = (role for role in roles when role isnt "has dibs on #{resource}")

  setResourceOwner = (data, resource, name) ->
    users = robot.brain.usersForFuzzyName(name)
    if users.length is 1
      user = users[0]
      user.roles = user.roles or [ ]
      if "using #{resource}" not in user.roles
        user.roles.push("using #{resource}")

  setResourceBackup = (data, resource, name) ->
    users = robot.brain.usersForFuzzyName(name)
    if users.length is 1
      user = users[0]
      user.roles = user.roles or [ ]
      if "has dibs on #{resource}" not in user.roles
        user.roles.push("has dibs on #{resource}")

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

  robot.respond /list resources/i, (msg) ->
    resourceStatuses = []
    for own resource, active of robot.brain.data.resources
      owner = getResourceOwner(robot.brain.data.users, resource)
      if owner
        resourceStatuses.push "#{owner.name} has #{resource}"
      else
        resourceStatuses.push "#{resource} is free"
    msg.send resourceStatuses.join(", ")

  robot.hear /(?:who has|who is using|what\'s up with) ([\w.-]+)?/i, (msg) ->
    resource = msg.match[1].trim()
    if robot.brain.data.resources[resource]
      resourceOwner = getResourceOwner(robot.brain.data.users, resource)
      if resourceOwner
        msg.send "#{resourceOwner.name} (@#{resourceOwner.mention_name}) has #{resource}"
      else
        msg.send "No one has told me they have #{resource}."
      resourceBackup = getResourceBackup(robot.brain.data.users, resource)
      if resourceBackup
        msg.send "#{resourceBackup.name} has dibs on #{resource}"
    else
      msg.send "/me scratches its virtual robotic head with a virtual robotic finger"

  robot.hear /([\w.-]+) is( all | )clear/i, (msg) ->
    EMPTY = {}
    resource = msg.match[1].trim()
    if robot.brain.data.resources[resource]
      clearResourceOwner(robot.brain.data, resource)
      resourceBackup = getResourceBackup(robot.brain.data.users, resource) || EMPTY
      if resourceBackup isnt EMPTY
        clearResourceBackup(robot.brain.data, resource)
        setResourceOwner(robot.brain.data, resource, resourceBackup.name)
        msg.send "ok @#{resourceBackup.mention_name} now has #{resource}"
      else
        msg.send "okay #{resource} is clear."
    else
      msg.send "/me goes looking for a #{resource}"

  robot.hear /(?:I can|can [iI]|gimme) (?:have|haz|use|some) ([\w.-]+)\??/i, (msg) ->
    EMPTY = {}
    resource = msg.match[1].trim()
    if robot.brain.data.resources[resource]
      stagingOwner = getResourceOwner(robot.brain.data.users, resource) || EMPTY
      if stagingOwner isnt EMPTY 
        if msg.message.user.name == stagingOwner.name
          msg.send "You already have it my little pumpkin pie."
        else
          friendly_things = ["the lovely", "my sweet little", "my darling", "the fabulous", "the amazing"]
          msg.send "Sorry #{msg.random friendly_things} #{stagingOwner.name} has #{resource}. (@#{stagingOwner.mention_name})"
          resourceBackup = getResourceBackup(robot.brain.data.users, resource) || EMPTY
          if resourceBackup isnt EMPTY
            msg.send "And #{resourceBackup.name} has dibs." 
          else
          msg.send "But you can have dibs if you want it."
      else
        setResourceOwner(robot.brain.data, resource, msg.message.user.name)
        msg.send "You got it Kimosabe"
    else
      silly_things = ["the barn", "the kumquat", "that wookie", "the star port", "the dinghy", "your marbles", "the prisoner", "the llama massage booth", "the... I don't know, you silly human.", "the lost boys"]
      msg.send "I don't have a #{resource}. Maybe you should look out back by #{msg.random silly_things}?"

  robot.hear /(?:I call dibs|dibs|shotgun) on ([\w.-]+)\??/i, (msg) ->
    EMPTY = {}
    resource = msg.match[1].trim()
    if robot.brain.data.resources[resource]
      resourceOwner = getResourceOwner(robot.brain.data.users, resource) || EMPTY
      if resourceOwner isnt EMPTY
        resourceBackup = getResourceBackup(robot.brain.data.users, resource) || EMPTY
        if resourceBackup isnt EMPTY 
          if msg.message.user.name == resourceBackup.name
            msg.send "Well shewt, ya don't have ta keep tellin me!"
          else
            friendly_things = ["The beefy", "The mighty", "The patient", "The gracious", "The delightful", "One fantastic"]
            msg.send "Denied. #{msg.random friendly_things} #{resourceBackup.name} has dibs."
        else
          setResourceBackup(robot.brain.data, resource, msg.message.user.name)
          msg.send "You are now on deck"
      else
        msg.send "Why are you calling dibs? You can have it silly."
    else
      silly_things = ["tabanus nippontucki", 'heerz tooya', 'heerz lukenatcha', 'verae peculya', 'greasy spoon', 'troglodyte', 'furry faced hobbit', 'smiley faced fool', 'faulty flatulent feline friend', 'sweet little buttercup', 'bag of mostly watter']
      msg.send "You can't call dibs on #{resource} you silly little #{msg.random silly_things}"

  robot.respond /(?:give me|create)(?: a)?(?: new)? resource ([\w.-]+)$/i, (msg) ->
    resource = msg.match[1]
    if appendResource robot.brain, resource
      msg.send "Yeehaw! Oh boy this will be the best #{resource} you ever did see."
    else
      msg.send "Meh. Seen it before"

  robot.respond /(?:destroy|blow away|get rid of)(?: the)? resource ([\w.-]+)$/i, (msg) ->
    resource = msg.match[1]
    if removeResource robot.brain, resource
      clearResourceOwner(robot.brain.data, resource)
      msg.send "Muahahahaha (boom) (boom) (awyeah)"
    else
      msg.send "WAT? (wat)"
