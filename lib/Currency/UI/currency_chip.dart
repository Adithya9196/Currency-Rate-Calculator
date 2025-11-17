import 'package:currency_rate_calculator/Currency/UI/currency_picker_sheet.dart';
import 'package:flutter/material.dart';
import 'package:currency_rate_calculator/Currency/Data/currency_list.dart';

class CurrencyChip extends StatelessWidget {
  final CurrencyItem label;
  final String heroTag;
  final Function(CurrencyItem) onSelect;

  const CurrencyChip({
    super.key,
    required this.label,
    required this.heroTag,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await showModalBottomSheet<CurrencyItem>(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return CurrencyPickerSheet(heroTag: heroTag);
          },
        );

        if (result != null) {
          onSelect(result);
        }
      },
      child: Hero(
        tag: heroTag,
        child: Chip(
          label: Row(
            children: [
              Text(label.flag, style: TextStyle(fontSize: 20)),
              SizedBox(width: 6),
              Text(label.code),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
    );
  }
}