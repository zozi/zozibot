# Display a Rick Ross gif
#
# rick ross - Displays a gif of Rick Ross
#
# ,,,,,,,,,,,,,,,,,,,,,,INZ$DDDDZ$O$$ZZ7?I+I?III?II+++7I77ZO8O888DDDD,,,,,,,,,,,,,
# ,,,,,,,,,,,,,,,,,,,,,,ONND8ZD88OZ$$ZZ7III7IIIII???++7777OODDD8DDDNN?,,,,,,,,,,,,
# ,,,,,,,,,,,,,,,,,,,,,DNZI787I888ZZ$Z77$?77$$7III$O$$I7I77Z8DDDDDNDNN,,,,,,,,,,,,
# ,,,,,,,,,,,,,,,,,,,,,7ZI?:=$Z788ZZ$$I?I?$$ZI7I7I$$ZOD8ZZ$Z8DDDDDDNND,,,,,,,,,,,,
# ,,,,,,,,,,,,,,,,,,,,D7I8DNN88Z88O$$I?+??77ZZZ$7II7OOO8DN8888DDDDDDN8,,,,,,,,,,,,
# ,,,,,,,,,,,,,,,,,$8OO$=+=OIZ888Z$I7+++=?+$OZZZZZ8ZZO88ODD8ODDD88DN?,,,,,,,,,,,,
# ,,,,,,,,,,,,,,,,8OO$$?$$OI$ZNDDDZ7?I++?II??7O$I+~Z88NDD8D8DDD88DDN+,,,,,,,,,,,,
# ,,,,,,,,,,,,,,,+8OOZ7I?I+ZZ8NDDZOI7II??777?++IONINDDNDNOOODDDDDNNN~,,,,,,,,,,,,
# ,,,,,,,,,,,,,,,88OOD7II7$ZMNNNDN877??++=~?ZII7Z88NNMNN$$ZDNNNNNNNM=,,,,,,,,,,,,
# ,,,,,,,,,,,,,.888ZO8D$77Z8NNNNNDD87II$I=~=+?I?7O8DNNNN+=78NMNNNNNN,,,,,,,,,,,,,
# ,,,,,,,,,,,,,888OOZZDMMOOMNMNNNND8Z777I??++?I$I$ZOZOZI?~IONNDNNNNN,,,,,,,,,,,,,
# ,,,,,,,,,,,,88888OZ$ZZOODNNNNNMNMNN87$$7II?+II7$?$Z7?==~?$8N8NNND.,,,,,,,,,,,,,
# ,,,,,,,,,,=8D8O8OOZZ$8ODNDNNNMDMMMM8Z7$$$II??7I7Z$I++?~,:+ZNNOND,,,,,,,,,,,,,,,
# ,,,,,:.?=Z$888OOOOZZZOODMDDNDMMMMMND8O$$7777777778Z+~?Z=:=7DNNND~,,,,,,,,,,,,,,
# ,,,,Z$~Z:+7+8OOOOZZZO8NNNDNNMNNNMNNMDD8O777$7OZ8ZI7III$+:+78NN,,,,,,,,,,,,,,,,,
# ,,,,O?+~,,?7ID8O8ZZZ8DDNNMMNNMNNNNNDNMDDO8Z$OZOO7$ODNMMZ?$8OND,,,,,,,,,,,,,,,,,
# ,OZ$OD?+7:I=7$DOZ8ZODNMNDNNMMNMNMMNDMNMDDDN88OOOZ$$IO8NDOOZOD8,,,,,,,,,,,,,,,,,
# OZOO$OO$DO.$IO,ZDODOO8NNMNMMMNMMNNMNMNDMMMNMNNDNDDOZDODDNNNZNO,,,,,,,,,,,,,,,,,,
# OO$ZZZ8O88Z?I=I,O8ZDO8MMMMNNMNMNNMMMNMMNMMNMNMMNN8?+I7ODNMNDO8,,,,,,,,,,,,,,,,,,
# ZZZZOOZZO88~7+$,?=8Z88MMMNMMNMMMMMNNMMMMMMMDMMMND88OZZO88MMMD:,,,,,,,,,,,,,,,,,,
# Z$$OOZZ7$O8$7Z$+~$+8DDMMNMNMDMNMMNMMNMNMMNMMMMMZZII$MNDDDDMN8,,,,,,,,,,,,,,,,,,,
# O$ZZZOZ8O$7$OO=O~,M~DNNNNMMMMMMNMMNMMNMMMMDMMDDOO77IO8MMMMMMM,,,,,,,,,,,,,,,,,,,
# $77ZOO$ZZZOI77$8NZ.::OMMNMMMMNMNMNMMMMMMNMMNMMD88D8ZOD8Z8DMMNI,,,,,,,,,,,,,,,,,,
# Z$$Z7?OZOOO$8OZ7Z=O?,N$MMMMMMMNMMDNNMMMMMMNNNMNDNMNNN88DDMMMN~,,,,,,,,,,,,,,,,,,
# ZZZZO88OOZII7OO8ZZ8M.?+:MMNMMMMMNMMMDMNNNMMNNMN8OONMMMMMMMMM$:,,,,,,,,,,,,,,,,,,
# OOOZOOOO$ZOI$$8OZOO88?.78DMMMMNMMMDNMMMMMMNMMMMMDDDNMMMMMMMN:,,,,,,,,,,,,,,,,,,,
# $ZZOZ$7$Z88$OZZO8Z$$OODZ~+OMMMMMMMNMMMMMNMMMMNMMMDNDNMMMMMM8,,,,,,,,,,,,,,,,,,,,
# $I77$Z$Z878888Z7ZOOOOZ8OD7+DMMMMMMMMMMMMMMMMMMMMNMMMMMMMMMO~,,,,,,,,,,,,,,,,,,,,
# ZIIZ$$ZOOOOOOD88O$$7Z88OOM8O?NMMMMMMMMMMMMMMMNMMNMMNMNNMNN+,,,,,,,,,,,,,,,,,,,,,
# 7$$7$ZZO8ZOO8O8ODDD8ZO8O8ODDO$8MMMMMMMMMMMMNMMMMMMMMDMNMMZ,,,,,,,,,,,,,,,,,,,,,,
# 77I$$$Z?$ZOOZZ8888DDDD88OO88D87MMMMMMMMMMMMMNMMMMMMMMMNNO,,,,,,,,,,,,,,,,,,,,,,,
# 77777ZO$ZZOO8O888OO88D8Z8D88O=$+DMMNMMMMMMMMMMMMMMMMD8I,,,,,,,,,,,,,,,,,,,,,,,,,
# 77$I77$$ZOOZO8OO8DO8D8OZ8OD888ON=$NN8NMM$,..,+:~:~,::.,,,,,,,,,,,,,,,,,,,,,,,,,,
# I7I7$$$Z7ZZO8OZO88O88O$888ZZO8DD87DNNDNMMZ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,

module.exports = (robot) ->
  robot.hear /ricky?(ricky? )? r(o|aw)ss/i, (msg) ->
    msg.send msg.random(rickRossImages)

rickRossImages = [
  "http://cdnl.complex.com/assets/CHANNEL_IMAGES/MUSIC/2012/07/content/wheelchair_plnhn.gif",
  "http://cdnl.complex.com/assets/CHANNEL_IMAGES/MUSIC/2012/07/content/shakinghead.gif",
  "http://cdnl.complex.com/assets/CHANNEL_IMAGES/MUSIC/2012/07/content/boom.gif",
  "http://cdnl.complex.com/assets/CHANNEL_IMAGES/MUSIC/2012/07/content/rockon.gif",
  "http://cdnl.complex.com/assets/CHANNEL_IMAGES/MUSIC/2012/07/content/headnod.gif",
  "http://cdnl.complex.com/assets/CHANNEL_IMAGES/MUSIC/2012/07/content/flame_bpkqp.gif",
  "http://cdnl.complex.com/assets/CHANNEL_IMAGES/MUSIC/2012/07/content/dance4.gif",
  "http://cdnl.complex.com/assets/CHANNEL_IMAGES/MUSIC/2012/07/content/38rickrossbopping.gif",
  "http://cdnl.complex.com/assets/CHANNEL_IMAGES/MUSIC/2012/07/content/cooking.gif",
  "http://cdnl.complex.com/assets/CHANNEL_IMAGES/MUSIC/2012/07/content/choppa_mspxo.gif",
  "http://cdnl.complex.com/assets/CHANNEL_IMAGES/MUSIC/2012/07/content/cereal.gif",
  "http://cdnl.complex.com/assets/CHANNEL_IMAGES/MUSIC/2012/07/content/cash2.gif",
  "http://cdnl.complex.com/assets/CHANNEL_IMAGES/MUSIC/2012/07/content/car.gif",
  "http://cdnl.complex.com/assets/CHANNEL_IMAGES/MUSIC/2012/07/content/basketball.gif",
  "http://25.media.tumblr.com/tumblr_m8cz1t5g1b1r0u8ydo1_400.gif",
  "http://25.media.tumblr.com/tumblr_lpal2o2TQH1qfg5auo1_400.gif",
  "http://31.media.tumblr.com/148ada288a7ada7991f3f7680d0798ea/tumblr_mkb10qnh1y1rhkyyso1_250.gif",
  "http://25.media.tumblr.com/tumblr_lxxaaieOuQ1qb5ym2o1_400.gif",
  "http://media.giphy.com/media/BUHpeplQHusU/giphy.gif"
]
