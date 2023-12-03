import Foundation

class ThreadSafeArray<T>  {
    private var array: [T] = []
    private let lock = NSLock()

    func append(_ newElement: T) {
        lock.lock()
        defer { lock.unlock() }
        array.append(newElement)
    }

    func remove(at index: Int) -> T {
        lock.lock()
        defer { lock.unlock() }
        return array.remove(at: index)
    }

    func removeAll() {
        lock.lock()
        defer { lock.unlock() }
        array.removeAll()
    }
}

extension ThreadSafeArray: RandomAccessCollection {
    typealias Index = Int
    typealias Element = T

    var startIndex: Index {
        lock.lock()
        defer { lock.unlock() }
        return array.startIndex
    }
    var endIndex: Index {
        lock.lock()
        defer { lock.unlock() }
        return array.endIndex
    }
    
    subscript(index: Index) -> T {
        get {
            lock.lock()
            defer { lock.unlock() }
            return array[index]
        }
        set(newValue) {
            lock.lock()
            defer { lock.unlock() }
            array[index] = newValue
        }
    }

    func index(after i: Index) -> Index {
        lock.lock()
        defer { lock.unlock() }
        return array.index(after: i)
    }
}
