import Foundation
import AVFoundation
import MediaPlayer

// We will let each different player manage its own state. GlobalPlayer will route the track to the correct player.

class GlobalPlayer {
  
  static let sharedInstance = GlobalPlayer()
  
  private let audioSession = AVAudioSession.sharedInstance()
  
  private var currentTrack: GlobalTrack?
  
  let mpic = MPNowPlayingInfoCenter.defaultCenter()
  
  init() {
    setup()
  }
  
  func play(track: GlobalTrack) {
    pause()
    
    currentTrack = track
    
    mpic.nowPlayingInfo = [
      MPMediaItemPropertyArtist: track.artist,
      MPMediaItemPropertyTitle: track.title
    ]
    
    if track.isSoundcloud {
      SoundcloudPlayer.sharedInstance.play(track.soundcloudTrack!.streamURL)
    } else if track.isSpotify {
      SpotifyPlayer.sharedInstance.play(track)
    }
  }
  
  func pause() {
    if let track = currentTrack {
      if track.isSoundcloud {
        SoundcloudPlayer.sharedInstance.pause()
      } else if track.isSpotify {
        SpotifyPlayer.sharedInstance.pause()
      }
    }
  }
  
  func resume() {
    if let track = currentTrack {
      if track.isSoundcloud {
        SoundcloudPlayer.sharedInstance.resume()
      } else if track.isSpotify {
        SpotifyPlayer.sharedInstance.resume()
      }
    }
  }
  
  func togglePlayPause() {
    if let track = currentTrack {
      if track.isSoundcloud {
        SoundcloudPlayer.sharedInstance.togglePlayPause()
      } else if track.isSpotify {
        SpotifyPlayer.sharedInstance.togglePlayPause()
      }
    }
  }
  
  func replay() {
    if let track = currentTrack {
      if track.isSoundcloud {
        SoundcloudPlayer.sharedInstance.replay()
      } else if track.isSpotify {
        SpotifyPlayer.sharedInstance.replay()
      }
    }
  }
  
}

extension GlobalPlayer {
  
  func setup() {
    setupAudioSession()
  }
  
  func setupAudioSession() {
    do {
      try audioSession.setCategory(AVAudioSessionCategoryPlayback)
      try audioSession.setActive(true)
    } catch let error {
      print(error)
    }
  }
  
  func isPlaying() -> Bool {
    if let track = currentTrack {
      if track.isSoundcloud {
        return SoundcloudPlayer.sharedInstance.isPlaying
      } else if track.isSpotify {
        return SpotifyPlayer.sharedInstance.isPlaying
      }
    }
    return false
  }
  
}
