import 'package:flutter/material.dart';

import '../../helper/date_helper.dart';
import 'add_product_form_widgets.dart';

class ExpiryDateSection extends StatelessWidget {
  const ExpiryDateSection({
    required this.hasNoExpiryDate,
    required this.expiryDate,
    required this.onNoExpiryChanged,
    required this.onPickExpiryDate,
    super.key,
  });

  final bool hasNoExpiryDate;
  final DateTime? expiryDate;
  final ValueChanged<bool> onNoExpiryChanged;
  final VoidCallback onPickExpiryDate;

  @override
  Widget build(BuildContext context) {
    return AddProductSectionCard(
      title: 'EXPIRY DATE',
      children: [
        NoExpiryToggle(
          value: hasNoExpiryDate,
          onChanged: onNoExpiryChanged,
        ),
        const SizedBox(height: 14),
        const AddProductFieldLabel('Expiry Date *'),
        ExpiryDateField(
          expiryDate: expiryDate,
          isEnabled: !hasNoExpiryDate,
          onTap: onPickExpiryDate,
        ),
      ],
    );
  }
}

class ExpiryDateField extends StatelessWidget {
  const ExpiryDateField({
    required this.expiryDate,
    required this.isEnabled,
    required this.onTap,
    super.key,
  });

  final DateTime? expiryDate;
  final bool isEnabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: isEnabled ? onTap : null,
      child: InputDecorator(
        decoration: const AddProductInputDecoration(hintText: 'mm/dd/yyyy'),
        child: Row(
          children: [
            Expanded(
              child: Text(
                expiryDate == null ? 'mm/dd/yyyy' : formatDate(expiryDate!),
                style: const TextStyle(
                  color: AddProductFormColors.inputText,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const Icon(
              Icons.calendar_today_outlined,
              color: AddProductFormColors.inputHint,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class NoExpiryToggle extends StatelessWidget {
  const NoExpiryToggle({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => onChanged(!value),
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isDarkTheme
              ? Theme.of(context).colorScheme.surfaceContainerHighest
              : const Color(0xFFF0F2F8),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Expanded(
              child: Text(
                'No expiry date',
                style: TextStyle(
                  color: Color(0xFF667096),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Icon(
              value
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: const Color(0xFFB1B8CC),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
