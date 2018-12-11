public protocol AsyncProcessor {
    func process()
}
public protocol AsyncTaskPerformer {
    associatedtype TaskContent
    func performAsyncTask(_ completion: @escaping (TaskContent)->())
}
public protocol AsyncTaskWaiter {
    associatedtype TaskContent
    func taskStarted()
    func taskFinished(_ content: TaskContent)
}
public class AsyncProcessorImpl<Performer: AsyncTaskPerformer, TaskWaiter: AsyncTaskWaiter> where Performer.TaskContent == TaskWaiter.TaskContent {
    private let performer: Performer
    private let taskWaiter: TaskWaiter
    public init(_ performer: Performer, _ taskWaiter: TaskWaiter) {
        self.performer = performer
        self.taskWaiter = taskWaiter
    }
}
extension AsyncProcessorImpl: AsyncProcessor {
    public func process() {
        taskWaiter.taskStarted()
        performer.performAsyncTask { (content) in
            self.taskWaiter.taskFinished(content)
        }
    }
}
