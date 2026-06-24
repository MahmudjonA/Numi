import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:numi/core/l10n/app_strings.dart';
import 'package:numi/features/home/presentation/bloc/weight/weight_bloc.dart';
import 'package:numi/features/home/presentation/bloc/weight/weight_event.dart';
import 'package:numi/features/home/presentation/bloc/weight/weight_state.dart';
import 'package:numi/features/home/domain/entities/weight_entry.dart';

class WeightHistoryPage extends StatelessWidget {
  const WeightHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(s.weightHistoryTitle,
            style: Theme.of(context).textTheme.titleLarge),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: BlocBuilder<WeightBloc, WeightState>(
        builder: (context, state) {
          if (state is WeightLoading) {
            return Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary));
          }

          if (state is WeightLoaded) {
            return ListView(
              padding: EdgeInsets.all(16.r),
              children: [
                if (state.entries.isNotEmpty) ...[
                  _WeightChart(entries: state.entries),
                  SizedBox(height: 16.h),
                  _SummaryRow(state: state),
                  SizedBox(height: 16.h),
                ],
                Text(s.weightRecords,
                    style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 10.h),
                if (state.entries.isEmpty)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 40.h),
                      child: Text(
                        s.noWeightYet,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  )
                else
                  ...state.entries.reversed.map(
                    (e) => _WeightTile(entry: e),
                  ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<WeightBloc>(),
        child: const _AddWeightDialog(),
      ),
    );
  }
}

// ── Chart ─────────────────────────────────────────────────────
class _WeightChart extends StatelessWidget {
  final List<WeightEntry> entries;
  const _WeightChart({required this.entries});

  @override
  Widget build(BuildContext context) {
    final spots = entries.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.weightKg);
    }).toList();

    final minY =
        entries.map((e) => e.weightKg).reduce((a, b) => a < b ? a : b) - 2;
    final maxY =
        entries.map((e) => e.weightKg).reduce((a, b) => a > b ? a : b) + 2;

    return Container(
      height: 180.h,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: LineChart(
        LineChartData(
          minY: minY,
          maxY: maxY,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                getTitlesWidget: (v, _) => Text(
                  v.toStringAsFixed(0),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (v, _) {
                  final idx = v.toInt();
                  if (idx < 0 || idx >= entries.length) {
                    return const SizedBox();
                  }
                  final d = entries[idx].dateTime;
                  return Text(
                    "${d.day}/${d.month}",
                    style: Theme.of(context).textTheme.labelSmall,
                  );
                },
              ),
            ),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Theme.of(context).colorScheme.primary,
              barWidth: 3,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Summary ───────────────────────────────────────────────────
class _SummaryRow extends StatelessWidget {
  final WeightLoaded state;
  const _SummaryRow({required this.state});

  @override
  Widget build(BuildContext context) {
    final s      = S.of(context);
    final change = state.change;
    final changeText = change == null
        ? '—'
        : change >= 0
            ? '+${change.toStringAsFixed(1)} kg'
            : '${change.toStringAsFixed(1)} kg';
    final changeColor = change == null
        ? Theme.of(context).colorScheme.primary
        : change > 0
            ? Colors.red
            : const Color(0xff24AC8B);

    return Row(
      children: [
        _Card(
          label: s.currentWeightLabel,
          value: "${state.latest?.weightKg.toStringAsFixed(1) ?? '—'} kg",
          color: Theme.of(context).colorScheme.primary,
          context: context,
        ),
        SizedBox(width: 8.w),
        _Card(
          label: s.weekChangeLabel,
          value: changeText,
          color: changeColor,
          context: context,
        ),
        SizedBox(width: 8.w),
        _Card(
          label: s.averageWeightLabel,
          value: "${state.average?.toStringAsFixed(1) ?? '—'} kg",
          color: Theme.of(context).colorScheme.primary,
          context: context,
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final BuildContext context;

  const _Card({
    required this.label,
    required this.value,
    required this.color,
    required this.context,
  });

  @override
  Widget build(BuildContext ctx) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelSmall),
            SizedBox(height: 4.h),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Tile ──────────────────────────────────────────────────────
class _WeightTile extends StatelessWidget {
  final WeightEntry entry;
  const _WeightTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(Icons.monitor_weight_outlined,
              color: Theme.of(context).colorScheme.primary),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${entry.weightKg.toStringAsFixed(1)} kg",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  "${entry.dateTime.day}/${entry.dateTime.month}/${entry.dateTime.year}${entry.note != null ? '  •  ${entry.note}' : ''}",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () => context
                .read<WeightBloc>()
                .add(DeleteWeightEntryEvent(id: entry.id)),
          ),
        ],
      ),
    );
  }
}

// ── Add Dialog ────────────────────────────────────────────────
class _AddWeightDialog extends StatefulWidget {
  const _AddWeightDialog();

  @override
  State<_AddWeightDialog> createState() => _AddWeightDialogState();
}

class _AddWeightDialogState extends State<_AddWeightDialog> {
  final _weightCtrl = TextEditingController();
  final _noteCtrl   = TextEditingController();
  DateTime _date    = DateTime.now();

  @override
  void dispose() {
    _weightCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final s = S.of(context);
    final w = double.tryParse(_weightCtrl.text);
    if (w == null || w < 20 || w > 300) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.weightRangeError)),
      );
      return;
    }
    context.read<WeightBloc>().add(
          AddWeightEntryEvent(
            weightKg: w,
            dateTime: _date,
            note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
          ),
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(s.addWeightDialogTitle,
          style: Theme.of(context).textTheme.titleMedium),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _weightCtrl,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: s.weightHint,
              filled: true,
              fillColor: Theme.of(context).cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          TextField(
            controller: _noteCtrl,
            decoration: InputDecoration(
              labelText: s.noteOptional,
              hintText: s.noteHint,
              filled: true,
              fillColor: Theme.of(context).cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.calendar_today,
                color: Theme.of(context).colorScheme.primary),
            title: Text(
              "${_date.day}/${_date.month}/${_date.year}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _date,
                firstDate:
                    DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now(),
              );
              if (picked != null) setState(() => _date = picked);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(s.cancelBtn),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary),
          onPressed: _save,
          child: Text(s.saveBtn,
              style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
