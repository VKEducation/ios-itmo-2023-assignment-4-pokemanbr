import Foundation

class CodeTask: Task {
    var priority: Int
    var isCompleted: Bool = false
    var dependencies: [Task] = []
    private let code: () -> Void
    
    func addDependency(_ task: Task) {
        dependencies.append(task)
    }
    
    func execute() {
        code()
    }
    
    required init(priority: Int, code: @escaping () -> Void) {
        self.priority = priority
        self.code = code
    }
}

let manager = TaskManager()

let taskA = CodeTask(priority: 0) {
    print("Task A executed", Thread.current)
}
let taskB = CodeTask(priority: 1) {
    print("Task B executed", Thread.current)
}
let taskC = CodeTask(priority: 2) {
    print("Task C executed", Thread.current)
}
let taskD = CodeTask(priority: 3) {
    print("Task D executed", Thread.current)
}
let taskE = CodeTask(priority: 3) {
    print("Task E executed", Thread.current)
}

taskA.addDependency(taskB)
taskA.addDependency(taskC)
taskB.addDependency(taskD)
taskE.addDependency(taskB)

manager.add(taskA)
manager.add(taskB)
manager.add(taskC)
manager.add(taskD)
manager.add(taskE)

try manager.start()
