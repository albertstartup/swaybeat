import Foundation
import Parse

class GlobalTrack {
  var soundcloudTrack: StreamableSoundcloudTrack?
  var spotifyTrack: SPTPartialTrack?
  var title: String
  var artist: String
  var previewURL: NSURL?
  var id: String
  
  var isSoundcloud: Bool {
    get {
      return soundcloudTrack != nil
    }
  }
  var isSpotify: Bool {
    get {
      return spotifyTrack != nil
    }
  }
  var isPreview: Bool {
    get {
      return previewURL != nil
    }
  }
  var streamURLString: String {
    get {
      if isSoundcloud {
        return soundcloudTrack!.streamURL.URLString
      } else {
        return spotifyTrack!.previewURL.URLString
      }
    }
  }
  var serviceString: String {
    if isSoundcloud {
      return "Soundcloud"
    } else {
      return "Spotify"
    }
  }
  
  init(fromSoundCloudTrack track: StreamableSoundcloudTrack) {
    soundcloudTrack = track
    
    title = track.title
    artist = track.artist
    id = track.id
  }
  
  init(fromSpotifyTrack track: SPTPartialTrack) {
    spotifyTrack = track
    
    title = track.name
    artist = track.artists[0].name
    id = track.identifier
  }
  
  func markAsPreview() {
    if isSpotify {
      previewURL = spotifyTrack!.previewURL
    }
  }
  
}