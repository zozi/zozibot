moment = require('moment-timezone')

# Track who has a resource
#
# @bot <user> is using <resource> - assign <resource> to someone else
# who has <resource>? - find out who has the resource
# what's up with <resource>? - find out who has the resource
# @bot <resource> is (all) clear - clears out the resource user
# @bot can I (have|use) <resource> - ask for the resource
# @bot i can haz <resource>? - ask for the resource
# Remove/Delete me from queue on <resource> - un-dibs yourself
# @bot create a resource <resource> - creates a new resource
# @bot destroy the resource <resource> - blow away the resource
# @bot watch for <repo> deploys to|on <resource> - remember branches of <rep> deployed to <resource>
# @bot ignore <repo> deploys to|on <resource> - stop remembering branches of <rep> deployed to <resource>
# what (branch is|branches are) on <resource> - ask for a list of deployed branches
# list deployed <repo>? branches - lists deployed branches, optionally filtered by repo

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
      resources[resource] = {}
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

  associateRepo = (brain, resource, repo) ->
    resources = brain.data.resources || {}
    relevantResource = resources[resource]
    if relevantResource
      branches = relevantResource.branches || []
      relevantBranch = false
      for branch in branches
        relevantBranch = branch if branch.repo is repo
      if !relevantBranch
        branches.push { repo: repo }
      relevantResource.branches = branches
      true
    else
      false

  dissociateRepo = (brain, resource, repo) ->
    resources = brain.data.resources || {}
    relevantResource = resources[resource]
    if relevantResource
      branches = relevantResource.branches || []
      branches = branches.filter (branch) -> (branch.repo isnt repo)
      relevantResource.branches = branches
      true
    else
      false

  getResourceBranches = (brain, resource) ->
    resources = brain.data.resources || {}
    relevantResource = resources[resource]
    if relevantResource
      relevantResource.branches
    else
      false

  findResourceRepoBranch = (brain, resource, repo) ->
    branches = getResourceBranches brain, resource
    if branches
      targetBranch = false
      for branch in branches
        targetBranch = branch if branch.repo is repo
      targetBranch
    else
      false

  ####################### RESOURCE CLAIMING ############################

  # inquire who is using a resource
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

  # free a resource
  robot.respond /([\w.-]+) is( all | )(free|clear)/i, (msg) ->
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

  # claim a resource
  robot.respond /(?:I can|can [iI]|gimme) (?:have|haz|use|some) ([\w.-]+)\??/i, (msg) ->
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

  # claim dibs on resource
  robot.respond /(?:I call dibs|dibs|shotgun) on ([\w.-]+)\??/i, (msg) ->
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

  # remove from dibs queue
  robot.hear /(?:Remove|Delete) me from queue on ([\w.-]+)\??/i, (msg) ->
    EMPTY = {}
    resource = msg.match[1].trim()
    if robot.brain.data.resources[resource]
      resourceBackup = getResourceBackup(robot.brain.data.users, resource) || EMPTY
      if resourceBackup isnt EMPTY
        if msg.message.user.name is resourceBackup.name
          clearResourceBackup(robot.brain.data, resource)
          msg.send "You are no longer in queue for #{resource}."
        else
          msg.send "#{resourceBackup.name} is already in queue for #{resource}."
      else
        msg.send "Silly Human, no one is in queue on #{resource}."
    else
      msg.send "#{resource}? We don't have no stinking #{resource}."

  # clear dibs queue
  robot.hear /Clear the queue on ([\w.-]+)\??/i, (msg) ->
    EMPTY = {}
    resource = msg.match[1].trim()
    if robot.brain.data.resources[resource]
      resourceBackup = getResourceBackup(robot.brain.data.users, resource) || EMPTY
      if resourceBackup isnt EMPTY
        clearResourceBackup(robot.brain.data, resource)
        msg.send "The queue is clear for #{resource}."
      else
        msg.send "Silly Human, no one is in queue on #{resource}."
    else
      msg.send "#{resource}? We don't have no stinking #{resource}."

  ####################### RESOURCES: CREATE/DESTROY/LIST ############################

  # robot resource creation commands
  robot.respond /(?:give me|create)(?: a)?(?: new)? resource ([\w.-]+)$/i, (msg) ->
    resource = msg.match[1]
    if appendResource robot.brain, resource
      msg.send "Yeehaw! Oh boy this will be the best #{resource} you ever did see."
    else
      msg.send "Meh. Seen it before"

  # robot resource destruction commands
  robot.respond /(?:destroy|blow away|get rid of)(?: the)? resource ([\w.-]+)$/i, (msg) ->
    resource = msg.match[1]
    if removeResource robot.brain, resource
      clearResourceOwner(robot.brain.data, resource)
      msg.send "Muahahahaha (boom) (boom) (awyeah)"
    else
      msg.send "WAT? (wat)"

  # lists resources
  robot.hear /list resources/i, (msg) ->
    resourceStatuses = []
    for own resource, active of robot.brain.data.resources
      owner = getResourceOwner(robot.brain.data.users, resource)
      if owner
        resourceStatuses.push "#{owner.name} has #{resource}"
      else
        resourceStatuses.push "#{resource} is free"
    msg.send resourceStatuses.join(", ")

  ####################### WATCHES FOR REPO/BRANCH DEPLOYS  ############################

  # robot repo deploy watch commands
  robot.respond /watch for (\w+) deploys (to|on) (.+)/i, (msg) ->
    repo = msg.match[1]
    resources = msg.match[3].split(",")
    for resource in resources
      resource = resource.trim()
      if associateRepo robot.brain, resource, repo
        msg.send "Well then, I'll be watching for #{repo} deploys #{msg.match[2]} #{resource}"
      else
        msg.send "Weird... I don't know about a #{resource}"

  # robot repo deploy ignore watch commands
  robot.respond /ignore (\w+) deploys (to|on) (.+)/i, (msg) ->
    repo = msg.match[1]
    resources = msg.match[3].split(",")
    for resource in resources
      resource = resource.trim()
      if dissociateRepo robot.brain, resource, repo
        msg.send "Alright, consider #{repo} dead to #{resource}"
      else
        msg.send "To be honest, I don't think #{resource} ever cared about #{repo} to begin with!"

  # listen for deploys of a watched repo to a given resource
  robot.hear /(.+) finished deploying (\w+)\/([A-Za-z0-9_-]+) (?:\((.+)\)\s)?to (?:\*?(\w+)\*?).*/i, (msg) ->
    branch = findResourceRepoBranch robot.brain, msg.match[5], msg.match[2]
    if branch
      branch.deployer = msg.match[1]
      branch.timestamp = moment().tz('US/Pacific').format('h:mmA on YYYY/MM/DD')
      branch.branch = msg.match[3]
      branch.commit = msg.match[4]

  # inquire what branches are on a given resource
  robot.hear /(?:what branch is|what branches are) on ([\w.-]+)?/i, (msg) ->
    resource = msg.match[1].trim()
    if robot.brain.data.resources[resource]
      resourceBranches = getResourceBranches robot.brain, resource
      if resourceBranches and resourceBranches.length
        for branch in resourceBranches
          if branch.branch
            message = "#{branch.repo}/#{branch.branch}"
            if branch.commit
              message = message + " (#{branch.commit})"
            message = message + " is on #{resource} (deployed by #{branch.deployer} at #{branch.timestamp})"
            msg.send message
      else
        msg.send "/me doesn't know of any branches deployed to #{resource}"
    else
      msg.send "/me didn't know it was supposed to be watching deploys to #{resource}"

  # list all deployed branches
  robot.hear /list deployed ([A-Za-z0-9_-]+) branches/i, (msg) ->
    for resource of robot.brain.data.resources
      branches = getResourceBranches robot.brain, resource
      if branches and branches.length
        for branch in branches
          if msg.match[1] and msg.match[1].trim() isnt branch.repo
            continue
          if branch.branch
            message = "#{branch.repo}/#{branch.branch}"
            if branch.commit
              message = message + " (#{branch.commit})"
            message = message + " is on #{resource} (deployed by #{branch.deployer} at #{branch.timestamp})"
            msg.send message
