import 'package:currency_rate_calculator/Currency/Data/currency_list.dart';
import 'package:flutter/material.dart';

class CurrencyPickerSheet extends StatefulWidget {
  final String heroTag;

  const CurrencyPickerSheet({required this.heroTag});

  @override
  State<CurrencyPickerSheet> createState() => _CurrencyPickerSheetState();
}

class _CurrencyPickerSheetState extends State<CurrencyPickerSheet> {
  String query = "";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = currencies.where((country) {
      return country.code.toLowerCase().contains(query.toLowerCase()) ||
          country.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.5,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [

          Hero(
            tag: widget.heroTag,
            child: Material(
              color: Colors.transparent,
              child: Text(
                "Select Country",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),

          SizedBox(height: 20),

          TextField(
            decoration: InputDecoration(
              hintText: "Search Country",
              hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
              prefixIcon: Icon(Icons.search, color: theme.colorScheme.onSurfaceVariant),
              filled: true,
              fillColor: theme.colorScheme.surfaceVariant,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none),
            ),
            onChanged: (val) => setState(() => query = val),
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),

          SizedBox(height: 20),

          Expanded(
            child: ListView.separated(
              itemCount: filtered.length,
              separatorBuilder: (_, __) => Divider(color: theme.colorScheme.outline),
              itemBuilder: (_, i) {
                final item = filtered[i];
                return ListTile(
                  leading: Text(item.flag, style: TextStyle(fontSize: 28)),
                  title: Text(
                    "${item.code} — ${item.name}",
                    style: TextStyle(color: theme.colorScheme.onSurface),
                  ),
                  onTap: () => Navigator.pop(context, item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
