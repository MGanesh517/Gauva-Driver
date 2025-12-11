import 'package:flutter/cupertino.dart';

import '../rounded_checkbox.dart';

class AppRadioButton<T> extends StatelessWidget {
  final T groupValue;
  final T value;
  final Function(T value) onChanged;

  const AppRadioButton({
    super.key,
    required this.groupValue,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => onChanged(value), minimumSize: const Size(0, 0),
        child: RoundedCheckbox(isSelected: groupValue == value));
}
