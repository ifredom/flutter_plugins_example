import 'package:event_bus/event_bus.dart';

/// The global [EventBus] object.
EventBus eventBus = EventBus();

/// Event A.
class EventTeacherHome {
  String pageName;

  EventTeacherHome(this.pageName);
}

class EventChangeTeacherHomeMenuIndex {
  num index;

  EventChangeTeacherHomeMenuIndex(this.index);
}
