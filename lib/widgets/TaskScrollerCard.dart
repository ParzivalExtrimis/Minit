// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minit/models/dateTimeModel.dart';
import 'package:minit/models/taskModel.dart';
import 'package:minit/providers/taskListProvider.dart';
import 'package:minit/utils/shaders.dart';
import 'package:minit/widgets/coundown_widgets/coundown_trigger_widget.dart';
import 'package:minit/widgets/dismissable_background_tile.dart';
import 'package:minit/widgets/new_task_widgets/GradientElevatedButton.dart';

class TaskSCrollerCard extends ConsumerStatefulWidget {
  const TaskSCrollerCard({super.key, required this.task});

  final TaskModel task;

  @override
  ConsumerState<TaskSCrollerCard> createState() => _TaskSCrollerCardState();
}

class _TaskSCrollerCardState extends ConsumerState<TaskSCrollerCard> {
  void _startTask() {
    ref.read(taskListProvider.notifier).startTask(widget.task);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Dismissible(
          key: ValueKey(widget.task.id),
          direction: DismissDirection.startToEnd,
          background: const DissmissableBackgroundTile(),
          onDismissed: (_) {
            ref.read(taskListProvider.notifier).removeTask(widget.task.id);
          },
          child: Card(
            elevation: widget.task.isRunning ? 8 : 4,
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(12),
            // ),
            child: Padding(
              padding: widget.task.isRunning
                  ? const EdgeInsets.all(18)
                  : const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: size.width * 0.6,
                                child: Text(
                                  widget.task.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        foreground: Paint()
                                          ..shader = widget.task.isRunning
                                              ? gradientTextShader
                                              : plainBlackTextShader,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              SizedBox(
                                width: size.width * 0.6,
                                child: Text(
                                  widget.task.description,
                                  softWrap: true,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black38,
                                      ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: widget.task.isRunning
                                              ? colorGradientList
                                              : [Colors.white, Colors.white]),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(9),
                                      child: Text(
                                        DateTimeModel(
                                                date: widget.task.startTime)
                                            .hourMinute,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              foreground: Paint()
                                                ..shader = widget.task.isRunning
                                                    ? plainWhiteTextShader
                                                    : gradientTextShader,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  if (widget.task.duration != null)
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: widget.task.isRunning
                                              ? colorGradientList
                                              : [Colors.white, Colors.white],
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(9),
                                        child: Text(
                                          widget.task.duration!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                foreground: Paint()
                                                  ..shader =
                                                      widget.task.isRunning
                                                          ? plainWhiteTextShader
                                                          : gradientTextShader,
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 73,
                        height: 73,
                        child: CountdownTriggerWidget(
                          task: widget.task,
                        ),
                      ),
                    ],
                  ),
                  !widget.task.isRunning
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: GradientElevatedButton(
                                text: 'Start Now!', onPressed: _startTask),
                          ),
                        )
                      : const SizedBox(
                          width: 0,
                          height: 0,
                        ),
                  widget.task.isRunning
                      ? Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            'Task in progress. Don\'t give up!',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: Colors.grey.shade500),
                          ),
                        )
                      : const SizedBox(
                          width: 0,
                          height: 0,
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
