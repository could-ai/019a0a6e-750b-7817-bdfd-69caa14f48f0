import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Trading Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueGrey[900],
        scaffoldBackgroundColor: Colors.blueGrey[900],
        cardColor: Colors.blueGrey[800],
        colorScheme: ColorScheme.dark(
          primary: Colors.tealAccent,
          secondary: Colors.tealAccent,
          onPrimary: Colors.black,
          onSecondary: Colors.black,
          surface: Colors.blueGrey[800]!,
          onSurface: Colors.white,
          background: Colors.blueGrey[900]!,
          onBackground: Colors.white,
          error: Colors.redAccent,
          onError: Colors.black,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueGrey[900],
          elevation: 0,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const SignalScreen(),
    );
  }
}

enum SignalType { buy, sell, hold }

class TradingSignal {
  final String commodityName;
  final SignalType signalType;
  final String signalReason;
  final String entryZone;
  final String stopLoss;
  final String target;
  final String riskRewardRatio;
  final String warning;

  TradingSignal({
    required this.commodityName,
    required this.signalType,
    required this.signalReason,
    required this.entryZone,
    required this.stopLoss,
    required this.target,
    required this.riskRewardRatio,
    required this.warning,
  });
}

class SignalScreen extends StatefulWidget {
  const SignalScreen({super.key});

  @override
  State<SignalScreen> createState() => _SignalScreenState();
}

class _SignalScreenState extends State<SignalScreen> {
  // Mock data based on your strategy blueprint
  final List<TradingSignal> _signals = [
    TradingSignal(
      commodityName: 'RELIANCE',
      signalType: SignalType.buy,
      signalReason:
          'The 50-day moving average (₹2,400) has crossed above the 200-day moving average (₹2,380), indicating a potential shift to a long-term bullish trend.',
      entryZone: '₹2,405 - ₹2,410',
      stopLoss: '₹2,356 (2% below entry)',
      target: '₹2,505 (4% above entry)',
      riskRewardRatio: '1:2',
      warning: 'This is a lagging indicator. Confirm with current market volume. Trade with caution.',
    ),
    TradingSignal(
      commodityName: 'NIFTY 50',
      signalType: SignalType.sell,
      signalReason:
          'The 50-day moving average has crossed below the 200-day moving average, indicating a potential shift to a long-term bearish trend.',
      entryZone: '₹18,500 - ₹18,510',
      stopLoss: '₹18,880 (2% above entry)',
      target: '₹17,760 (4% below entry)',
      riskRewardRatio: '1:2',
      warning: 'Confirm with other indicators before shorting. Market is volatile.',
    ),
     TradingSignal(
      commodityName: 'BANKNIFTY',
      signalType: SignalType.hold,
      signalReason:
          'No crossover detected. ADX is below 25, indicating a weak or sideways market.',
      entryZone: 'N/A',
      stopLoss: 'N/A',
      target: 'N/A',
      riskRewardRatio: 'N/A',
      warning: 'Avoid taking new positions in a choppy market. Wait for a clear trend to emerge.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Trading Signals'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: _signals.length,
        itemBuilder: (context, index) {
          return SignalCard(signal: _signals[index]);
        },
      ),
    );
  }
}

class SignalCard extends StatelessWidget {
  final TradingSignal signal;

  const SignalCard({super.key, required this.signal});

  Color _getSignalColor() {
    switch (signal.signalType) {
      case SignalType.buy:
        return Colors.green;
      case SignalType.sell:
        return Colors.red;
      case SignalType.hold:
        return Colors.grey;
    }
  }

  String _getSignalLabel() {
    switch (signal.signalType) {
      case SignalType.buy:
        return 'STRONG BUY';
      case SignalType.sell:
        return 'STRONG SELL';
      case SignalType.hold:
        return 'HOLD';
    }
  }

    IconData _getSignalIcon() {
    switch (signal.signalType) {
      case SignalType.buy:
        return Icons.trending_up;
      case SignalType.sell:
        return Icons.trending_down;
      case SignalType.hold:
        return Icons.pause_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: _getSignalColor(), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 12),
            Text(
              'Reason: ${signal.signalReason}',
              style: theme.textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            _buildActionPlan(theme),
            const SizedBox(height: 16),
            _buildWarning(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          signal.commodityName,
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getSignalColor(),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Icon(_getSignalIcon(), color: Colors.white, size: 16),
              const SizedBox(width: 6),
              Text(
                _getSignalLabel(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionPlan(ThemeData theme) {
    if (signal.signalType == SignalType.hold) {
      return Container();
    }
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Action Plan', style: theme.textTheme.titleLarge),
          const Divider(height: 20),
          _buildInfoRow('Suggested Entry Zone:', signal.entryZone, theme),
          _buildInfoRow('Stop-Loss:', signal.stopLoss, theme),
          _buildInfoRow('Target:', signal.target, theme),
          _buildInfoRow('Risk-Reward Ratio:', signal.riskRewardRatio, theme),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70)),
          Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildWarning(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber, width: 1)
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              signal.warning,
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.amber[200]),
            ),
          ),
        ],
      ),
    );
  }
}
