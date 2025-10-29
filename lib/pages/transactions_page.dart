import 'package:expenses_tracker/pages/expense_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import '../databases/database_helper.dart';
import '../utils/widgets/app_bars.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});
  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _transactions = [];
  final NumberFormat _currencyFormat =
      NumberFormat.currency(symbol: '', decimalDigits: 2);

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    final transactions = await dbHelper.getExpenses();
    setState(() {
      _transactions = transactions;
    });
  }

  void _confirmDelete(BuildContext context, int transactionId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content:
              const Text('Are you sure you want to delete this transaction?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                _deleteTransaction(transactionId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteTransaction(int transactionId) async {
    await dbHelper.deleteExpense(transactionId);
    if (!mounted) return;
    await _fetchTransactions();
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Transaction deleted successfully!'),
        backgroundColor: theme.colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: const MinimalAppBar(title: 'Transactions'),
      body: LiquidPullToRefresh(
        color: theme.colorScheme.primary,
        backgroundColor: theme.scaffoldBackgroundColor,
        springAnimationDurationInMilliseconds: 700,
        height: 160,
        onRefresh: _fetchTransactions,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemBuilder: (context, index) => _buildTransactionTile(_transactions[index]),
          separatorBuilder: (_, __) => const SizedBox(height: 6),
          itemCount: _transactions.length,
        ),
      ),
    );
  }

  Widget _buildTransactionTile(Map<String, dynamic> t) {
    final theme = Theme.of(context);
    final isIncome = (t['credit'] ?? 0) > 0;
    final color = isIncome ? theme.colorScheme.tertiary : theme.colorScheme.error;
    final amount = isIncome ? (t['credit'] ?? 0) : (t['debit'] ?? 0);

    final leading = Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(10),
      child: Icon(isIncome ? Icons.south_west : Icons.north_east, color: color, size: 18),
    );

    final tile = ListTile(
      leading: leading,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              t['categoryName'] ?? '',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            t['transactionDate'] ?? '',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          t['description'] ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _currencyFormat.format(amount),
            style: TextStyle(fontWeight: FontWeight.w700, color: color),
          ),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Text(
              (t['transactionType'] ?? '').toString(),
              style: const TextStyle(fontSize: 10),
            ),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Slidable(
        endActionPane: ActionPane(motion: const StretchMotion(), children: [
          CustomSlidableAction(
            onPressed: (context) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExpensePage(expense: t),
                ),
              );
            },
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            child: const Icon(Icons.edit, size: 20),
          ),
          CustomSlidableAction(
            onPressed: (context) {
              _confirmDelete(context, t['id']);
            },
            backgroundColor: theme.colorScheme.error,
            foregroundColor: theme.colorScheme.onError,
            child: const Icon(Icons.delete, size: 20),
          )
        ]),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 1.5,
          child: tile,
        ),
      ),
    );
  }
}
