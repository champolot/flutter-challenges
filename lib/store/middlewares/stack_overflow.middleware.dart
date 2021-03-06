import 'package:playground_flutter/constants/navigation.dart';
import 'package:playground_flutter/services/stack_overflow.service.dart';
import 'package:playground_flutter/store/actions/stack_overflow.action.dart';
import 'package:playground_flutter/store/state/app.state.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> overflowMiddlewares() {
  final StackOverflowService service = new StackOverflowService();

  final loginRequest = _createLoadQuestionRequest(service);

  return ([
    TypedMiddleware<AppState, LoadQuestionAction>(loginRequest),
    TypedMiddleware<AppState, ViewQuestionAction>(_viewQuestion),
  ]);
}

Middleware<AppState> _createLoadQuestionRequest(StackOverflowService service) {
  return (Store<AppState> store, action, NextDispatcher next) async {
    try {
      var questions = await service.list();
      store.dispatch(new LoadQuestionSuccessAction(questions: questions));
    } catch (error) {
      store.dispatch(new LoadQuestionFailureAction(error: error));
    }

    // Make sure to forward actions to the next middleware in the chain!
    next(action);
  };
}

_viewQuestion(Store<AppState> store, action, NextDispatcher next) {
  NavigationConstrants.navKey.currentState.pushNamed("/redux-view-question");
  // Make sure to forward actions to the next middleware in the chain!
  next(action);
}
