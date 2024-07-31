import Foundation

extension CaseIterable where Self: Equatable {
    func next() -> Self {
        let all = Self.allCases
        let idx = all.firstIndex(of: self)!
        let next = all.index(after: idx)
        return all[next == all.endIndex ? all.startIndex : next]
    }

    func prev() -> Self {
        let all = Self.allCases
        let idx = all.firstIndex(of: self)! as! Int
        let prevIdx = idx == 0 ? all.count - 1 : idx - 1
        return all[prevIdx as! Self.AllCases.Index]
    }
}
