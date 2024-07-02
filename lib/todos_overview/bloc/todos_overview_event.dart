part of 'todos_overview_bloc.dart';

sealed class TodosOverviewEvent extends Equatable {
  const TodosOverviewEvent();

  @override
  List<Object> get props => [];
}

// This is the startup event. In response, the bloc subscribes to the stream of
// [todos] from the [TodosRepository].
final class TodosOVerviewSubscriptionRequested extends TodosOverviewEvent {
  const TodosOVerviewSubscriptionRequested();
}

// This toggles a [todo]’s completed status.
final class TodosOverviewTodoCompletionToggled extends TodosOverviewEvent {
  const TodosOverviewTodoCompletionToggled({
    required this.todo,
    required this.isCompleted,
  });

  final Todo todo;
  final bool isCompleted;

  @override
  List<Object> get props => [todo, isCompleted];
}

// This deletes a [todo]
final class TodosOverviewTodoDeleted extends TodosOverviewEvent {
  const TodosOverviewTodoDeleted(this.todo);

  final Todo todo;

  @override
  List<Object> get props => [todo];
}

//  This undoes a [todo] deletion, e.g. an accidental deletion.
final class TodosOverviewUndoDeletionRequested extends TodosOverviewEvent {
  const TodosOverviewUndoDeletionRequested();
}

// This takes a [TodosViewFilter] as an argument and changes the view by 
// applying a filter.
class TodosOverviewFilterChanged extends TodosOverviewEvent {
  const TodosOverviewFilterChanged(this.filter);

  final TodosViewFilter filter;

  @override
  List<Object> get props => [filter];
}

// This toggles completion for all todos.
class TodosOverviewToggleAllRequest extends TodosOverviewEvent {
  const TodosOverviewToggleAllRequest();
}

// This deletes all completed todos.
class TodosOverviewClearCompletedRequest extends TodosOverviewEvent {
  const TodosOverviewClearCompletedRequest();
}
