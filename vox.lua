--- === hs.vox ===
---
--- Controls for VOX music player

------------------------------------------------
---            Global Declaration            ---
------------------------------------------------

local vox = {}

local alert = require "hs.alert"
local as = require "hs.applescript"
local app = require "hs.application"

-- Internal function to pass a command to Applescript.
local function tell(cmd)
  local _cmd = 'tell application "vox" to ' .. cmd
  local ok, result = as.applescript(_cmd)
  if ok then
    return result
  else
    return nil
  end
end

-- TODO: VERIFY
-- --- hs.vox.state_paused
-- --- Constant
-- --- Returned by `hs.vox.getPlaybackState()` to indicates vox is paused
-- vox.state_paused = "kPSp"
--
-- --- hs.vox.state_playing
-- --- Constant
-- --- Returned by `hs.vox.getPlaybackState()` to indicates vox is playing
-- vox.state_playing = "kPSP"
--
-- --- hs.vox.state_stopped
-- --- Constant
-- --- Returned by `hs.vox.getPlaybackState()` to indicates vox is stopped
-- vox.state_stopped = "kPSS"

------------------------------------------------
---              Basic Command               ---
------------------------------------------------
--- hs.vox.pause()
--- Function
--- Pauses the current vox track
---
--- Parameters:
---  * None
---
--- Returns:
---  * None
function vox.pause()
  tell('pause')
end

--- hs.vox.play()
--- Function
--- Plays the current vox track
---
--- Parameters:
---  * None
---
--- Returns:
---  * None
function vox.play()
  tell('play')
end

--- hs.vox.playpause()
--- Function
--- Toggles play/pause of current vox track
---
--- Parameters:
---  * None
---
--- Returns:
---  * None
function vox.playpause()
  tell('playpause')
end

--- hs.vox.next()
--- Function
--- Skips to the next vox track
---
--- Parameters:
---  * None
---
--- Returns:
---  * None
function vox.next()
  tell('next track')
end

--- hs.vox.previous()
--- Function
--- Skips to previous vox track
---
--- Parameters:
---  * None
---
--- Returns:
---  * None
function vox.previous()
  tell('previous track')
end

--- hs.vox.shuffle()
--- Function
--- Toggle shuffle state of current list
---
--- Parameters:
---  * None
---
--- Returns:
---  * None
function vox.shuffle()
  tell('shuffle')
end

--- hs.vox.playurl(url)
--- Function
--- Play media from the given URL
---
--- Parameters:
---  * url {string}
---
--- Returns:
---  * None
function vox.playurl(url)
  tell('playurl \"' .. url .. '\"')
end

--- hs.vox.addurl(url)
--- Function
--- Add media URL to current list
---
--- Parameters:
---  * url {string}
---
--- Returns:
---  * None
function vox.addurl(url)
  tell('addurl \"' .. url .. '\"')
end

--- hs.vox.forward()
--- Function
--- Skips the playback position forwards by about 7 seconds
---
--- Parameters:
---  * None
---
--- Returns:
---  * None
function vox.forward()
  tell('rewindforward')
end

--- hs.vox.backward()
--- Function
--- Skips the playback position backwards by about 7 seconds
---
--- Parameters:
---  * None
---
--- Returns:
---  * None
function vox.backward()
  tell('rewindbackward')
end

--- hs.vox.fastForward()
--- Function
--- Skips the playback position forwards by about 17 seconds
---
--- Parameters:
---  * None
---
--- Returns:
---  * None
function vox.fastForward()
  tell('rewindforwardfast')
end

--- hs.vox.fastBackward()
--- Function
--- Skips the playback position backwards by about 14 seconds
---
--- Parameters:
---  * None
---
--- Returns:
---  * None
function vox.fastBackward()
  tell('rewindbackwardfast')
end

--- hs.vox.increaseVolume()
--- Function
--- Increases the palyer volume
---
--- Parameters:
---  * None
---
--- Returns:
---  * None
function vox.increaseVolume()
  tell('increasvolume')
end

--- hs.vox.decreaseVolume()
--- Function
--- Decreases the player volume
---
--- Parameters:
---  * None
---
--- Returns:
---  * None
function vox.decreaseVolume()
  tell('decreasevolume')
end

--- hs.vox.trackInfo()
--- Function
--- Displays information for current track on screen
---
--- Parameters:
---  * None
---
--- Returns:
---  * None
function vox.trackInfo()
  local artist = tell('artist') or "Unknown artist"
  local album  = tell('album') or "Unknown album"
  local track  = tell('track') or "Unknown track"
  alert.show(track .."\n".. album .."\n".. artist, 1.75)
end

--- hs.vox.getCurrentArtist()
--- Function
--- Gets the name of the artist of the current track
---
--- Parameters:
---  * None
---
--- Returns:
---  * A string containing the Artist of the current track, or nil if an error occurred
function vox.getCurrentArtist()
  return tell('artist') or "Unknown artist"
end

--- hs.vox.getCurrentAlbum()
--- Function
--- Gets the name of the album of the current track
---
--- Parameters:
---  * None
---
--- Returns:
---  * A string containing the Album of the current track, or nil if an error occurred
function vox.getCurrentAlbum()
  return tell('album') or "Unknown album"
end

--- hs.vox.getAlbumArtist()
--- Function
--- Gets the artist of current Album
---
--- Parameters:
---  * None
---
--- Returns:
---  * A string containing the artist of current Album, or nil if an error occurred
function vox.getAlbumArtist()
  return tell('albumArtist') or "Unknown album artist"
end

--- hs.vox.getUniqueID()
--- Function
--- Gets the uniqueID of the current track
---
--- Parameters:
---  * None
---
--- Returns:
---  * A string containing the name of the current track, or nil if an error occurred
function vox.getUniqueID()
  return tell('uniqueID') or "Unknown ID"
end

--- hs.vox.getPlayerState()
--- Function
--- Gets the current playback state of vox
---
--- Parameters:
---  * None
---
--- Returns:
---  * 0 for paused
---  * 1 for playing
function vox.getPlayerState()
  return tell('playerState')
end

--- TODO: VERIFY BELOW
--- hs.vox.isRunning()
--- Function
--- Returns whether vox is currently open. Most other functions in hs.vox will automatically start the application, so this function can be used to guard against that.
---
--- Parameters:
---  * None
---
--- Returns:
---  * A boolean value indicating whether the vox application is running.
function vox.isRunning()
  return app.get("vox") ~= nil
end

--- TODO: Start Here
--- hs.vox.getVolume()
--- Function
--- Gets the vox volume setting
---
--- Paramters:
---  * None
---
--- Returns:
---  * A number containing the volume vox is set to between 1 and 100
function vox.getVolume() return tell'sound volume' end

--- hs.vox.setVolume(vol)
--- Function
--- Sets the vox volume setting
---
--- Parameters:
---  * vol - A number between 1 and 100
---
--- Returns:
---  * None
function vox.setVolume(v)
  v=tonumber(v)
  if not v then error('volume must be a number 1..100',2) end
  return tell('set sound volume to '..math.min(100,math.max(0,v)))
end

--- hs.vox.getPosition()
--- Function
--- Gets the playback position (in seconds) in the current song
---
--- Parameters:
---  * None
---
--- Returns:
---  * A number indicating the current position in the song
function vox.getPosition() return tell'player position' end

--- hs.vox.setPosition(pos)
--- Function
--- Sets the playback position in the current song
---
--- Parameters:
---  * pos - A number containing the position (in seconds) to jump to in the current song
---
--- Returns:
---  * None
function vox.setPosition(p)
  p=tonumber(p)
  if not p then error('position must be a number in seconds',2) end
  return tell('set player position to '..p)
end

return vox