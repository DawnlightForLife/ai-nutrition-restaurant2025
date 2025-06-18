import 'package:flutter/material.dart';

class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    
    final orderNumber = (args?['orderNumber'] as String?) ?? 'N/A';
    final totalAmount = (args?['totalAmount'] as num?)?.toDouble() ?? 0.0;
    final orderType = (args?['orderType'] as String?) ?? 'dine_in';
    final tableNumber = args?['tableNumber'] as String?;
    final estimatedTime = (args?['estimatedTime'] as String?) ?? '15-20 minutes';

    return Scaffold(
      backgroundColor: Colors.green[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Order Placed Successfully!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Thank you for your order. We\'re preparing it now!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildOrderDetail('Order Number', orderNumber),
                      const SizedBox(height: 12),
                      _buildOrderDetail('Total Amount', '¥${totalAmount.toStringAsFixed(2)}'),
                      const SizedBox(height: 12),
                      _buildOrderDetail('Order Type', orderType == 'dine_in' ? 'Dine In' : 'Takeaway'),
                      if (tableNumber != null) ...[
                        const SizedBox(height: 12),
                        _buildOrderDetail('Table Number', tableNumber),
                      ],
                      const SizedBox(height: 12),
                      _buildOrderDetail('Estimated Time', estimatedTime),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue[700],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        orderType == 'dine_in'
                            ? 'Please remain at your table. Your order will be served shortly.'
                            : 'Please wait for pickup notification. You can track your order status.',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => _trackOrder(context, orderNumber),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Track Order'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () => _returnToMenu(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.green,
                        side: const BorderSide(color: Colors.green),
                      ),
                      child: const Text('Continue Shopping'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => _goHome(context),
                    child: const Text(
                      'Back to Home',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderDetail(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _trackOrder(BuildContext context, String orderNumber) {
    Navigator.pushNamed(
      context,
      '/order-tracking',
      arguments: {'orderNumber': orderNumber},
    );
  }

  void _returnToMenu(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/menu',
      (route) => route.isFirst,
    );
  }

  void _goHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/dashboard',
      (route) => false,
    );
  }
}