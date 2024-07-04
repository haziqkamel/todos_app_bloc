import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos_app/features/todos_overview/bloc/todos_overview_bloc.dart';
import 'package:todos_app/features/todos_overview/model/models.dart';
import 'package:todos_app/features/todos_overview/model/todos_view_filter.dart';
import 'package:todos_app/l10n/l10n.dart';

class TodosOverviewFilterButton extends StatelessWidget {
  const TodosOverviewFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final activeFilter = context.select(
      (TodosOverviewBloc bloc) => bloc.state.filter,
    );

    return PopupMenuButton<TodosViewFilter>(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
      initialValue: activeFilter,
      tooltip: l10n.todosOverviewFilterTooltip,
      icon: const Icon(Icons.filter_list_rounded),
      onSelected: (filter) => context
          .read<TodosOverviewBloc>()
          .add(TodosOverviewFilterChanged(filter)),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: TodosViewFilter.all,
            child: Text(l10n.todosOverviewFilterAll),
          ),
          PopupMenuItem(
            value: TodosViewFilter.activeOnly,
            child: Text(l10n.todosOverviewFilterActiveOnly),
          ),
          PopupMenuItem(
            value: TodosViewFilter.completedOnly,
            child: Text(l10n.todosOverviewFilterCompletedOnly),
          ),
        ];
      },
    );
  }
}
