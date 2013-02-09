# Deal with insults gracefully

# ZoziBot you are <an insult> - this will prompt a retort

comebacks = [
  "I'm rubber you're glue.",
  "Thank you. You are --??-- too.",
  "Only --??-- like you could teach me so well.",
  "Is that all you got?",
  "I really appreciate that. I never knew I could be --??--",
  "Friend, there is no need for such talk.",
  "Ahh, it's good to have a friend like you.",
  "If you find it hard to laugh at yourself, I would be happy to do it for you.",
  "I really appreciate you as well.",
  "Is it time for your medication?",
  "My gratitude is overwhelming.",
  "I'm not so good with advice, can I interest you with a sarcastic comment?",
  "Yes, master. I will try to be good at being --??--.",
  "Ahh, I wish we were better strangers.",
  "Muchas gracias",
  "I'll always cherish the original misconceptions I had about you.",
  "Thanks a bunch.",
  "I'll try being nicer if you'll try being smarter.",
  "Aww, you're so sweet.",
  "How many times do I have to flush before you go away?",
  "I'm glad you noticed that I am --??--.",
  "I'm busy now. Can I ignore you some other time?",
  "--??--!, --??--!, --??--!: My new favorite saying",
  "Nancy, if you were my wife, I'd drink it",
  "I'm sorry, I missed what you said. I gave up listening to you.",
  "I've been called worse things by better humans.",
  "Thank you. We're all refreshed and challenged by your unique point of view.",
  "Oh I get it. Like humour, but different...",
  "You're not yourself today, I noticed the improvement straight away.",
  "Do you hear that? That's the sound of no-one caring."
  ]

getComeback = (msg, insult) ->
  comeback = msg.random comebacks
  comeback.replace /--[?]+--/g, insult

module.exports = (robot) ->

  robot.respond /you (?:are )?(["'\w: -_]+)/i, (msg) ->
    insult = msg.match[1].trim()
    msg.send "#{getComeback msg, insult}"
