import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'trend_bloc.dart';
import 'trend_event.dart';
import 'trend_state.dart';

class CurrencyTrendSheet extends StatefulWidget {
  final String fromCurrency;
  final String toCurrency;

  CurrencyTrendSheet({required this.fromCurrency, required this.toCurrency});

  @override
  State<CurrencyTrendSheet> createState() => _CurrencyTrendSheetState();
}

class _CurrencyTrendSheetState extends State<CurrencyTrendSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _lineController;

  @override
  void initState() {
    super.initState();
    _lineController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );
    _lineController.forward();
  }

  @override
  void dispose() {
    _lineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => TrendBloc()
        ..add(LoadTrendEvent(
            fromCurrency: widget.fromCurrency, toCurrency: widget.toCurrency)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.55,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: BlocBuilder<TrendBloc, TrendState>(
          builder: (context, state) {
            if (state is TrendLoading || state is TrendInitial) {
              return Center(
                child: CircularProgressIndicator(color: theme.colorScheme.primary),
              );
            } else if (state is TrendLoaded) {
              final spots = List.generate(
                  state.values.length,
                      (i) => FlSpot(i.toDouble(), state.values[i].toDouble()));

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.fromCurrency} → ${widget.toCurrency}",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _lineController,
                      builder: (context, child) {
                        final progress = _lineController.value;
                        return LineChart(
                          LineChartData(
                            gridData: FlGridData(
                                show: true,
                                horizontalInterval: 5,
                                getDrawingHorizontalLine: (value) => FlLine(
                                  color: theme.colorScheme.outline.withOpacity(0.3),
                                  strokeWidth: 1,
                                )),
                            borderData: FlBorderData(
                              show: true,
                              border: Border.all(
                                color: theme.colorScheme.outline,
                              ),
                            ),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 32,
                                  getTitlesWidget: (value, meta) {
                                    int index = value.toInt();
                                    if (value == index.toDouble() && index >= 0 && index < state.dates.length) {
                                      return Text(
                                        state.dates[index],
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: theme.colorScheme.onSurfaceVariant,
                                        ),
                                      );
                                    }
                                    return Text('');
                                  },
                                ),
                              ),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: spots
                                    .map((s) => FlSpot(s.x, s.y * progress))
                                    .toList(),
                                isCurved: true,
                                barWidth: 3,
                                color: theme.colorScheme.primary,
                                isStrokeCapRound: true,
                                dotData: FlDotData(
                                  show: true,
                                  getDotPainter: (spot, percent, barData, index) {
                                    return FlDotCirclePainter(
                                      radius: 4 * progress,
                                      color: theme.colorScheme.primary.withOpacity(progress),
                                      strokeWidth: 0,
                                    );
                                  },
                                ),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: theme.colorScheme.primary.withOpacity(0.2 * progress),
                                ),
                              ),
                            ],
                            lineTouchData: LineTouchData(
                              handleBuiltInTouches: true,
                              touchTooltipData: LineTouchTooltipData(
                                getTooltipItems: (spots) {
                                  return spots.map((spot) {
                                    return LineTooltipItem(
                                      "${state.dates[spot.x.toInt()]}\n${spot.y.toStringAsFixed(2)}",
                                      TextStyle(
                                        color: theme.colorScheme.onPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }).toList();
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Chip(
                          label: Text(
                              "Min: ${state.min.toStringAsFixed(2)}",
                              style: TextStyle(color: theme.colorScheme.onSurface)),
                          backgroundColor: theme.colorScheme.surfaceVariant,
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Chip(
                          label: Text(
                              "Avg: ${state.avg.toStringAsFixed(2)}",
                              style: TextStyle(color: theme.colorScheme.onSurface)),
                          backgroundColor: theme.colorScheme.surfaceVariant,
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Chip(
                          label: Text(
                              "Max: ${state.max.toStringAsFixed(2)}",
                              style: TextStyle(color: theme.colorScheme.onSurface)),
                          backgroundColor: theme.colorScheme.surfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else if (state is TrendError) {
              return Center(
                  child: Text(
                    state.message,
                    style: TextStyle(color: theme.colorScheme.error),
                  ));
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}