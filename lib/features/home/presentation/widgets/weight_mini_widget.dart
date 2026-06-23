import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:numi/features/home/presentation/bloc/weight/weight_bloc.dart';
import 'package:numi/features/home/presentation/bloc/weight/weight_event.dart';
import 'package:numi/features/home/presentation/bloc/weight/weight_state.dart';
import 'package:numi/features/home/presentation/pages/weight_history_page.dart';

class WeightMiniWidget extends StatelessWidget {
  const WeightMiniWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeightBloc, WeightState>(
      builder: (context, state) {
        String weightText = '—';
        String changeText = '';
        Color changeColor = Theme.of(context).colorScheme.primary;

        if (state is WeightLoaded) {
          if (state.latest != null) {
            weightText = "${state.latest!.weightKg.toStringAsFixed(1)} kg";
            final ch = state.change;
            if (ch != null) {
              changeText =
                  ch >= 0 ? "▲ +${ch.toStringAsFixed(1)}" : "▼ ${ch.toStringAsFixed(1)}";
              changeColor = ch > 0 ? Colors.red : const Color(0xff24AC8B);
            }
          }
        }

        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16.r),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<WeightBloc>(),
                  child: const WeightHistoryPage(),
                ),
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Vazn",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          weightText,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        if (changeText.isNotEmpty)
                          Text(
                            "$changeText kg (7 kun)",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(color: changeColor),
                          ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Icon(Icons.monitor_weight_outlined,
                          color: Theme.of(context).colorScheme.primary),
                      SizedBox(height: 6.h),
                      GestureDetector(
                        onTap: () => _showAddDialog(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            "+ Kiriting",
                            style:
                                Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: Colors.white,
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<WeightBloc>(),
        child: const _QuickWeightDialog(),
      ),
    );
  }
}

class _QuickWeightDialog extends StatefulWidget {
  const _QuickWeightDialog();

  @override
  State<_QuickWeightDialog> createState() => _QuickWeightDialogState();
}

class _QuickWeightDialogState extends State<_QuickWeightDialog> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _save() {
    final w = double.tryParse(_ctrl.text);
    if (w == null || w < 20 || w > 300) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vazn 20–300 kg oralig'ida bo'lishi kerak")),
      );
      return;
    }
    context.read<WeightBloc>().add(
          AddWeightEntryEvent(weightKg: w, dateTime: DateTime.now()),
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text("Bugungi vazn",
          style: Theme.of(context).textTheme.titleMedium),
      content: TextField(
        controller: _ctrl,
        autofocus: true,
        keyboardType:
            const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: "Vazn (kg)",
          filled: true,
          fillColor: Theme.of(context).cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Bekor")),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary),
          onPressed: _save,
          child: const Text("Saqlash",
              style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
