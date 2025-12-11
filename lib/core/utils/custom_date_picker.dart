import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<String?> customDatePickerReturnString(BuildContext context, {DateTime? initialDate, DateTime? lastDate, DateTime? firstDate, DateFormat? dateFormat})async{
  final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime.now(),
      lastDate: lastDate ?? DateTime(2100),
  );

  if(picked != null){
    return dateFormat != null ? dateFormat.format(picked) : DateFormat('dd-MM-yyyy', 'en').format(picked, ) ;
  }else{
    return null;
  }
}

Future<DateTime?> customDatePickerReturnDate(BuildContext context, {DateTime? initialDate, DateTime? lastDate, DateTime? firstDate,})async{
  final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime.now().subtract(const Duration(days: 365)),
      lastDate: lastDate ?? DateTime.now().add(const Duration(days: 3654)),
  );
  return picked;
}