import Foundation
import AVFoundation

class URLPlayer: NSObject {
  private let player = AVPlayer()
  
  var isPlaying = false
  private(set) var didEnd = false
  private(set) var currentURL: NSURL?
  
  override init() {
    super.init()
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "URLPlayerDidEnd:", name: AVPlayerItemDidPlayToEndTimeNotification, object: self)

    player.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions([.New, .Initial]),context: nil)
  }
  
  func play(url: NSURL) {
    pause()
    
    currentURL = url
    
    let playerItem = AVPlayerItem(URL: url)
    player.replaceCurrentItemWithPlayerItem(playerItem)
    player.play()
  }
  
  func pause() {
    if !isPlaying { return }
    player.pause()
  }
  
  func resume() {
    if isPlaying { return }
    if currentURL == nil { return }
    
    if didEnd { replay() }
    
    player.play()
  }
  
  func replay() {
    if !didEnd { return }
    
    if let url = currentURL {
      let playerItem = AVPlayerItem(URL: url)
      player.replaceCurrentItemWithPlayerItem(playerItem)
      player.play()
    }
  }
  
  func togglePlayPause() {
    isPlaying ? pause() : resume()
  }
  
}

extension URLPlayer {
  // MARK: AVPlayer Rate Observer

  override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
    
    if (keyPath == "rate") {
      if player.rate > 0 {
        isPlaying = true
      } else {
        isPlaying = false
      }
    }
    
  }
  
}

extension URLPlayer {
  // MARK: - AVPlayerItemDidPlayToEndTimeNotification
  
  func URLPlayerDidEnd(noti: NSNotification) {
    isPlaying = false
    didEnd = true
  }
  
}