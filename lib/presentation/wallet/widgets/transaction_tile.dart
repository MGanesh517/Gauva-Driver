import 'package:flutter/material.dart';
import 'package:gauva_driver/data/models/wallet_model/wallet_transaction_history_model.dart';

class TransactionTile extends StatelessWidget {
  final Transaction wallet;
  const TransactionTile({super.key, required this.wallet});

  @override
  Widget build(BuildContext context) {
    final isCredit = wallet.transaction == 'credit';
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isCredit ? Colors.green.shade100 : Colors.red.shade100,
          child: Icon(isCredit ? Icons.arrow_downward : Icons.arrow_upward, color: isCredit ? Colors.green : Colors.red),
        ),
        title: Text("${isCredit ? "Credit" : "Debit"} - ₹ ${wallet.amount?.toStringAsFixed(2)}"),
        subtitle: Text('${wallet.method?.toUpperCase()} • ${wallet.createdAt}'),
        trailing: Text('Order #${wallet.orderId}'),
      ),
    );
  }
}
