import nico

type
  Audio = object of RootObj
    channel: int
    index: int
    fileName: string
  MusicTrack = object of Audio
  Sound = object of Audio

var
  musicTrack = MusicTrack(channel: 0, index: 0, fileName: "chiptronical.ogg") 
  sound = Sound(channel: 1, index: 0, fileName: "wall-bounce.ogg")

proc loadAudioFiles*() =
  loadMusic(musicTrack.index, musicTrack.fileName)
  loadSfx(sound.index, sound.fileName)
  
proc playMusicTrack*() =
  music(musicTrack.channel, musicTrack.index)

proc playSound*() =
  sfx(sound.channel, sound.index)

proc stopMusicTrack*() =
  music(musicTrack.channel, -1)
