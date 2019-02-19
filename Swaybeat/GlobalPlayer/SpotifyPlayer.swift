import Foundation

let SpotifyInternalPlayer = SPTAudioStreamingController(clientId: SPTAuth.defaultInstance().clientID)

class SpotifyPlayer: NSObject {
  
  static let sharedInstance = SpotifyPlayer()
  
  var player = SpotifyInternalPlayer
  private var previewPlayer = URLPlayer()
  
  var currentTrack: GlobalTrack?    
  
  var isPlaying = false
  
  override init() {
    super.init()
    
    player.playbackDelegate = self
  }  

}

extension SpotifyPlayer {
  func play(track: GlobalTrack) {
    currentTrack = track
    
    if player.loggedIn && !track.isPreview {
      
      player.playURIs([track.spotifyTrack!.playableUri!], withOptions: SPTPlayOptions(), callback: { (error: NSError!) in
        if (error != nil) {
          print("error playing: \(error)")
          return
        }
        
        print("success playing")
      })
      
    } else {
      track.markAsPreview()
      previewPlayer.play(track.previewURL!)
    }
  }
  
  func pause() {
    if let track = currentTrack {
      if track.isPreview {
        previewPlayer.pause()
      } else {
        
        player.setIsPlaying(false) {error in
          if (error != nil) {
            print("error pausing spotify player: \(error)")
            return
          }
        }
        
      }
    }
  }
  
  func resume() {
    if let track = currentTrack {
      if track.isPreview {
        previewPlayer.resume()
      } else {
        
        player.setIsPlaying(true) { error in
          if (error != nil) {
            print("error resuming spotify player: \(error)")
            return
          }
        }
        
      }
    }
  }
  
  func togglePlayPause() {
    isPlaying ? pause() : resume()
  }
  
  func replay() {
    if let track = currentTrack {
      if track.isPreview {
        previewPlayer.replay()
      } else {
        resume()
      }
    }
  }
}

extension SpotifyPlayer: SPTAudioStreamingPlaybackDelegate {
  
  // MARK: - SPTAudioStreamingPlaybackDelegate
  
  func audioStreaming(audioStreaming: SPTAudioStreamingController!, didChangePlaybackStatus isPlaying: Bool) {
    self.isPlaying = isPlaying
  }
  
  func audioStreaming(audioStreaming: SPTAudioStreamingController!, didFailToPlayTrack trackUri: NSURL!) {
    
    print("did fail to play track, now trying to play sample")
    
    SPTTrack.trackWithURI(trackUri, session: nil) { (error: NSError!, response: AnyObject!) in
      if (error != nil) {
        print("error requesting track with uri: \(error)")
        return
      }
      
      let track = response as! SPTPartialTrack
      
      let globalTrack = GlobalTrack(fromSpotifyTrack: track)
      globalTrack.markAsPreview()
      
      SpotifyPlayer.sharedInstance.play(globalTrack)
    }
    
  }
}
