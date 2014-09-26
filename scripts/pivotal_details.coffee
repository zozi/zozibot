# Description:
#   Listen for a specific story from PivotalTracker
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_PIVOTAL_TOKEN
#
# Commands:
#   paste a pivotal tracker link or type "sid-####" in the presence of hubot
#
# Author:
#   christianchristensen

module.exports = (robot) ->
  robot.hear /(sid-|SID-|pivotaltracker.com\/story\/show)/i, (msg) ->
    token = process.env.HUBOT_PIVOTAL_TOKEN
    story_id = msg.message.text.match(/\d+/) # look for some numbers in the string

    msg.http("https://www.pivotaltracker.com/services/v5/projects").headers("X-TrackerToken": token).get() (err, res, body) ->
      return msg.send "Pivotal says: #{err}" if err

      try
        projects = JSON.parse(body)
      catch e
        return msg.send "Error parsing pivotal projects body: #{e}"

      for project in projects
        msg.http("https://www.pivotaltracker.com/services/v5/projects/#{project.id}/stories/#{story_id}").headers("X-TrackerToken": token).get() (err, res, body) ->
          return msg.send "Pivotal says: #{err}" if err
          return if res.statusCode == 404 # No story found in this project

          try
            story = JSON.parse(body)
          catch e
            return msg.send "Error parsing pivotal story body: #{e}"

          message = "#{story.name}\n\n"
          # message += "State: #{story.current_state}\n" if story.current_state && story.current_state != "unstarted"
          message += "Story: #{story.url}\n"

          url = "https://www.pivotaltracker.com/services/v5/projects/#{story.project_id}/stories/#{story_id}/comments"

          msg.http(url).headers("X-TrackerToken": token).get() (err, res, body) ->
            return msg.send "Pivotal says: #{err}" if err
            try
              comments = JSON.parse(body)
            catch e
              return msg.send "Error parsing pivotal comments body: #{e}"

            for comment in comments
              match = comment.text.match /(https?:\/\/)?github.com\/\w+\/\w+\/pull\/\S+/
              if match
                message += "Codes: #{match[0]}\n"

            msg.send message



