import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos_app/features/todos_overview/bloc/todos_overview_bloc.dart';
import 'package:todos_app/l10n/l10n.dart';

@visibleForTesting
enum TodosOverviewOption { toggleAll, clearCompleted }

class TodosOverviewOptionsButton extends StatelessWidget {
  const TodosOverviewOptionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final todos = context.select((TodosOverviewBloc bloc) => bloc.state.todos);
    final hasTodos = todos.isNotEmpty;
    final completedTodosAmount = todos.where((todo) => todo.isCompleted).length;

    return PopupMenuButton<TodosOverviewOption>(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
      tooltip: l10n.todosOverviewOptionsTooltip,
      icon: const Icon(Icons.more_vert_rounded),
      onSelected: (options) {
        switch (options) {
          case TodosOverviewOption.toggleAll:
            context
                .read<TodosOverviewBloc>()
                .add(const TodosOverviewToggleAllRequest());
          case TodosOverviewOption.clearCompleted:
            context
                .read<TodosOverviewBloc>()
                .add(const TodosOverviewClearCompletedRequest());
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: TodosOverviewOption.toggleAll,
            enabled: hasTodos,
            child: Text(
              completedTodosAmount == todos.length
                  ? l10n.todosOverviewOptionsMarkAllIncomplete
                  : l10n.todosOverviewOptionsMarkAllComplete,
            ),
          ),
          PopupMenuItem(
            value: TodosOverviewOption.clearCompleted,
            enabled: hasTodos && completedTodosAmount > 0,
            child: Text(l10n.todosOverviewOptionsClearCompleted),
          ),
        ];
      },
    );
  }
}
