import Combine
import Dependencies
import SwiftUI

@MainActor
class AppModel: ObservableObject {
    @Published var path: [Destination]
    @Published var standupsList: StandupsListModel

    @Dependency(\.continuousClock) var clock
    @Dependency(\.date.now) var now
    @Dependency(\.uuid) var uuid

    private var detailCancellable: AnyCancellable?

    enum Destination: Hashable {
        case detail(StandupDetailModel)
        case meeting(Meeting, standup: Standup)
        case record(RecordMeetingModel)
    }

    init(
        path: [Destination] = [],
        standupsList: StandupsListModel
    ) {
        self.path = path
        self.standupsList = standupsList
        self.standupsList.app = self
    }

    func navToStandupDetail(standup: Standup, parentModel: StandupPresenter) {
        path.append(.detail(StandupDetailModel(standup: standup, parentModel: parentModel)))
    }
}

struct AppView: View {
    @ObservedObject var model: AppModel

    var body: some View {
        NavigationStack(path: self.$model.path) {
            StandupsList(model: self.model.standupsList)
                .environmentObject(model)
                .navigationDestination(for: AppModel.Destination.self) { destination in
                    switch destination {
                    case let .detail(detailModel):
                        StandupDetailView(model: detailModel)
                            .environmentObject(model)
                    case let .meeting(meeting, standup: standup):
                        MeetingView(meeting: meeting, standup: standup)
                            .environmentObject(model)
                    case let .record(recordModel):
                        RecordMeetingView(model: recordModel)
                    }
                }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(model: AppModel(standupsList: StandupsListModel(standups: [.engineeringMock, .designMock])))
    }
}
