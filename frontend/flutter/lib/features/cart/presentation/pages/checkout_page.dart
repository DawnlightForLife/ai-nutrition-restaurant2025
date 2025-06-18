import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../order/domain/entities/cart_order.dart';
import '../../../order/presentation/providers/cart_order_provider.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  
  List<Map<String, dynamic>> _cartItems = [];
  double _totalAmount = 0.0;
  String _selectedPaymentMethod = 'cash';
  String _orderType = 'dine_in';
  String? _selectedTable;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCheckoutData();
    });
  }

  void _loadCheckoutData() {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      setState(() {
        _cartItems = List<Map<String, dynamic>>.from(args['cartItems'] as List? ?? []);
        _totalAmount = (args['totalAmount'] as num?)?.toDouble() ?? 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmation'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: _cartItems.isEmpty
          ? _buildEmptyState()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOrderSummary(),
                    const SizedBox(height: 20),
                    _buildOrderTypeSelection(),
                    const SizedBox(height: 20),
                    if (_orderType == 'dine_in') _buildTableSelection(),
                    if (_orderType == 'dine_in') const SizedBox(height: 20),
                    _buildPaymentMethodSelection(),
                    const SizedBox(height: 20),
                    _buildSpecialNotes(),
                    const SizedBox(height: 20),
                    _buildPricingSummary(),
                    const SizedBox(height: 30),
                    _buildConfirmButton(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No items to checkout',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/menu'),
            child: const Text('Browse Menu'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            for (final item in _cartItems) Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      (item['name'] as String?) ?? 'Unknown Item',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'x${(item['quantity'] as int?) ?? 1}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '¥${(((item['price'] as num?) ?? 0) * ((item['quantity'] as int?) ?? 1)).toStringAsFixed(2)}',
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderTypeSelection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Dine In'),
                    value: 'dine_in',
                    groupValue: _orderType,
                    onChanged: (value) {
                      setState(() {
                        _orderType = value!;
                        _selectedTable = null;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Takeaway'),
                    value: 'takeaway',
                    groupValue: _orderType,
                    onChanged: (value) {
                      setState(() {
                        _orderType = value!;
                        _selectedTable = null;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableSelection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Table',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedTable,
              decoration: const InputDecoration(
                hintText: 'Choose a table',
                border: OutlineInputBorder(),
              ),
              items: List.generate(20, (index) => index + 1)
                  .map((table) => DropdownMenuItem(
                        value: 'T${table.toString().padLeft(2, '0')}',
                        child: Text('Table ${table.toString().padLeft(2, '0')}'),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTable = value;
                });
              },
              validator: _orderType == 'dine_in'
                  ? (value) => value == null ? 'Please select a table' : null
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSelection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Method',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                RadioListTile<String>(
                  title: const Text('Cash'),
                  subtitle: const Text('Pay at restaurant'),
                  value: 'cash',
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('WeChat Pay'),
                  subtitle: const Text('Digital payment'),
                  value: 'wechat',
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Alipay'),
                  subtitle: const Text('Digital payment'),
                  value: 'alipay',
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value!;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialNotes() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Special Notes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                hintText: 'Any special requests or dietary requirements...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              maxLength: 200,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingSummary() {
    final serviceCharge = _totalAmount * 0.1;
    final tax = _totalAmount * 0.05;
    final finalTotal = _totalAmount + serviceCharge + tax;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pricing Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Subtotal:'),
                Text('¥${_totalAmount.toStringAsFixed(2)}'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Service Charge (10%):'),
                Text('¥${serviceCharge.toStringAsFixed(2)}'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tax (5%):'),
                Text('¥${tax.toStringAsFixed(2)}'),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '¥${finalTotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Consumer(
      builder: (context, ref, child) {
        final orderState = ref.watch(orderCreationProvider);
        
        // 监听订单创建状态变化
        ref.listen(orderCreationProvider, (previous, next) {
          if (next.isSuccess && next.createdOrder != null) {
            // 订单创建成功，跳转到成功页面
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/order-success',
              (route) => route.isFirst,
              arguments: {
                'orderNumber': next.createdOrder!.orderNumber ?? 'ORD${DateTime.now().millisecondsSinceEpoch}',
                'totalAmount': next.createdOrder!.priceDetails.total,
                'orderType': next.createdOrder!.orderType,
                'tableNumber': next.createdOrder!.tableNumber,
                'estimatedTime': next.createdOrder!.orderType == 'dine_in' ? '15-20 minutes' : '10-15 minutes',
              },
            );
          } else if (next.error != null) {
            // 显示错误信息
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('下单失败: ${next.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
        
        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: orderState.isLoading ? null : _confirmOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: orderState.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Confirm Order',
                    style: TextStyle(fontSize: 16),
                  ),
          ),
        );
      }
    );
  }

  Future<void> _confirmOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authState = ref.read(authStateProvider);
    final userId = authState.user?.id;
    
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请先登录'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final serviceCharge = _totalAmount * 0.1;
    final tax = _totalAmount * 0.05;
    final finalTotal = _totalAmount + serviceCharge + tax;

    // 构建订单实体
    final order = CartOrder(
      userId: userId,
      merchantId: 'default_merchant', // TODO(dev): 从购物车中获取商家ID
      items: _cartItems.map((item) => CartOrderItem(
        dishId: (item['id'] as String?) ?? '',
        name: (item['name'] as String?) ?? '',
        price: ((item['price'] as num?) ?? 0).toDouble(),
        quantity: (item['quantity'] as int?) ?? 1,
        itemTotal: (((item['price'] as num?) ?? 0) * ((item['quantity'] as int?) ?? 1)).toDouble(),
        specifications: (item['specifications'] as String?) ?? '',
      )).toList(),
      priceDetails: OrderPriceDetails(
        subtotal: _totalAmount,
        serviceCharge: serviceCharge,
        tax: tax,
        total: finalTotal,
      ),
      payment: OrderPayment(
        method: _selectedPaymentMethod,
        status: 'pending',
      ),
      orderType: _orderType,
      tableNumber: _selectedTable,
      specialNotes: _notesController.text.trim(),
      status: 'pending',
    );

    // 使用Provider创建订单
    await ref.read(orderCreationProvider.notifier).createOrder(order);
  }


  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }
}