import Foundation

extension Bool {
  init<T :IntegerType>(_ integer: T) {
    self.init(integer != 0)
  }
}
