//
//  Group.swift
//  
//
//  Created by Rex Fang on 2024-07-05.
//

protocol Group {
  associatedtype Element: Hashable, CustomStringConvertible
  
  /// Name of the group.
  var name: String { get }
  
  /// Identity element of the group.
  var identity: Element { get }
  
  /// Inverse of a group element.
  /// - Parameter g: Group element to invert.
  /// - Returns: Inverted element.
  func inverse(of g: Element) -> Element
  
  /// Group operation.
  /// - Parameters:
  ///   - a: Left hand side.
  ///   - b: Right hand side.
  func operate(_ a: Element, _ b: Element) -> Element
  
  /// Apply group operation onto ordered operands.
  /// - Parameter operands: Elements to apply group operations on.
  /// - Returns: Result.
  func reduce(_ operands: Element...) -> Element
  
  /// A (possibly infinite) sequence of group elements.
  func elementSequence() -> any Sequence<Self.Element>
  
  /// Generate a subgroup of the current group with a set.
  /// - Parameter s: Generating set.
  /// - Returns: Subgroup generated by the set.
  func span(_ s: Set<Element>) -> Set<Element>
}

extension Group {
  typealias E = Element
  
  /// Apply group operation to a sequence of group elements.
  /// - Parameter operands: Group elements.
  /// - Returns: Result of group opreation.
  func reduce(_ operands: E...) -> E {
    return operands.reduce(self.identity) { self.operate($0, $1) }
  }
  
  /// Generate a subgroup of the current group with a set.
  /// - Parameter s: Generating set.
  /// - Returns: Subgroup generated by the set.
  func span(_ s: Set<E>) -> Set<E> {
    return (s.conjoin(s.setMap(self.inverse(of:))) + self.identity)
      .expandTillConvergence(with: self.operate(_:_:))
  }
}
