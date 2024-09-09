import Foundation

extension CaseIterable where Self: Equatable {
    func next() -> Self {
        let all = Self.allCases
        let idx = all.firstIndex(of: self)!
        let next = all.index(after: idx)
        return all[next == all.endIndex ? all.startIndex : next]
    }

    /// 첫 번째 인덱스에서 prev하면 맨 뒤로 안가도록 설정.
    func prev() -> Self {
        let all = Self.allCases
        let idx = all.firstIndex(of: self)! as! Int
        let prevIdx = idx == 0 ? 0 : idx - 1
        return all[prevIdx as! Self.AllCases.Index]
    }
}
