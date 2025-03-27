/// 订单模型
class Order {
  final String id;
  final String orderNumber;
  final String userId;
  final String merchantId;
  final String merchantType;
  final List<OrderItem> items;
  final String status;
  final String orderType;
  final PaymentInfo payment;
  final PriceDetails priceDetails;
  final DeliveryInfo? delivery;
  final DineInInfo? dineIn;
  final Map<String, dynamic>? nutritionSummary;
  final bool? nutritionGoalAlignment;
  final DateTime createdAt;
  final DateTime updatedAt;
  final OrderRating? rating;

  Order({
    required this.id,
    required this.orderNumber,
    required this.userId,
    required this.merchantId,
    required this.merchantType,
    required this.items,
    required this.status,
    required this.orderType,
    required this.payment,
    required this.priceDetails,
    this.delivery,
    this.dineIn,
    this.nutritionSummary,
    this.nutritionGoalAlignment,
    required this.createdAt,
    required this.updatedAt,
    this.rating,
  });

  /// 从JSON创建Order对象
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'] ?? json['id'] ?? '',
      orderNumber: json['order_number'] ?? json['orderNumber'] ?? '',
      userId: json['user_id'] ?? json['userId'] ?? '',
      merchantId: json['merchant_id'] ?? json['merchantId'] ?? '',
      merchantType: json['merchant_type'] ?? json['merchantType'] ?? '',
      items: json['items'] != null
          ? List<OrderItem>.from(
              json['items'].map((x) => OrderItem.fromJson(x)))
          : [],
      status: json['status'] ?? 'pending',
      orderType: json['order_type'] ?? json['orderType'] ?? 'delivery',
      payment: json['payment'] != null
          ? PaymentInfo.fromJson(json['payment'])
          : PaymentInfo(method: 'pending', status: 'pending'),
      priceDetails: json['price_details'] != null
          ? PriceDetails.fromJson(json['price_details'])
          : (json['priceDetails'] != null
              ? PriceDetails.fromJson(json['priceDetails'])
              : PriceDetails(
                  subtotal: 0, tax: 0, deliveryFee: 0, discount: 0, total: 0)),
      delivery: json['delivery'] != null
          ? DeliveryInfo.fromJson(json['delivery'])
          : null,
      dineIn:
          json['dine_in'] != null ? DineInInfo.fromJson(json['dine_in']) : null,
      nutritionSummary: json['nutrition_summary'] ?? json['nutritionSummary'],
      nutritionGoalAlignment:
          json['nutrition_goal_alignment'] ?? json['nutritionGoalAlignment'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : (json['createdAt'] != null
              ? DateTime.parse(json['createdAt'])
              : DateTime.now()),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : (json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'])
              : DateTime.now()),
      rating: json['rating'] != null ? OrderRating.fromJson(json['rating']) : null,
    );
  }

  /// 将Order对象转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderNumber': orderNumber,
      'userId': userId,
      'merchantId': merchantId,
      'merchantType': merchantType,
      'items': items.map((x) => x.toJson()).toList(),
      'status': status,
      'orderType': orderType,
      'payment': payment.toJson(),
      'priceDetails': priceDetails.toJson(),
      'delivery': delivery?.toJson(),
      'dineIn': dineIn?.toJson(),
      'nutritionSummary': nutritionSummary,
      'nutritionGoalAlignment': nutritionGoalAlignment,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'rating': rating?.toJson(),
    };
  }

  /// 用于调试的字符串表示
  @override
  String toString() {
    return 'Order{id: $id, orderNumber: $orderNumber, userId: $userId, '
           'merchantId: $merchantId, status: $status, orderType: $orderType, '
           'total: ${priceDetails.total}, items: ${items.length}}';
  }

  /// 创建带有更新属性的Order副本
  Order copyWith({
    String? status,
    PaymentInfo? payment,
    DeliveryInfo? delivery,
    OrderRating? rating,
  }) {
    return Order(
      id: id,
      orderNumber: orderNumber,
      userId: userId,
      merchantId: merchantId,
      merchantType: merchantType,
      items: items,
      status: status ?? this.status,
      orderType: orderType,
      payment: payment ?? this.payment,
      priceDetails: priceDetails,
      delivery: delivery ?? this.delivery,
      dineIn: dineIn,
      nutritionSummary: nutritionSummary,
      nutritionGoalAlignment: nutritionGoalAlignment,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      rating: rating ?? this.rating,
    );
  }
}

/// 订单项模型
class OrderItem {
  final String dishId;
  final String name;
  final double price;
  final int quantity;
  final Map<String, dynamic>? nutritionInfo;
  final List<String>? options;
  final String? specialInstructions;

  OrderItem({
    required this.dishId,
    required this.name,
    required this.price,
    required this.quantity,
    this.nutritionInfo,
    this.options,
    this.specialInstructions,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      dishId: json['dish_id'] ?? json['dishId'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 1,
      nutritionInfo: json['nutritionInfo'] ?? json['nutrition_info'],
      options: json['options'] != null ? List<String>.from(json['options']) : null,
      specialInstructions: json['specialInstructions'] ?? json['special_instructions'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dishId': dishId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'nutritionInfo': nutritionInfo,
      'options': options,
      'specialInstructions': specialInstructions,
    };
  }

  @override
  String toString() {
    return 'OrderItem{dishId: $dishId, name: $name, price: $price, quantity: $quantity}';
  }
}

/// 支付信息模型
class PaymentInfo {
  final String method;
  final String status;
  final String? transactionId;
  final DateTime? paidAt;

  PaymentInfo({
    required this.method,
    required this.status,
    this.transactionId,
    this.paidAt,
  });

  factory PaymentInfo.fromJson(Map<String, dynamic> json) {
    return PaymentInfo(
      method: json['method'] ?? 'unknown',
      status: json['status'] ?? 'pending',
      transactionId: json['transactionId'] ?? json['transaction_id'],
      paidAt: json['paidAt'] != null 
          ? DateTime.parse(json['paidAt']) 
          : (json['paid_at'] != null ? DateTime.parse(json['paid_at']) : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'method': method,
      'status': status,
      'transactionId': transactionId,
      'paidAt': paidAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'PaymentInfo{method: $method, status: $status, transactionId: $transactionId}';
  }
}

/// 价格详情模型
class PriceDetails {
  final double subtotal;
  final double tax;
  final double deliveryFee;
  final double discount;
  final double total;

  PriceDetails({
    required this.subtotal,
    required this.tax,
    required this.deliveryFee,
    required this.discount,
    required this.total,
  });

  factory PriceDetails.fromJson(Map<String, dynamic> json) {
    return PriceDetails(
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      tax: (json['tax'] ?? 0).toDouble(),
      deliveryFee: (json['deliveryFee'] ?? json['delivery_fee'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subtotal': subtotal,
      'tax': tax,
      'deliveryFee': deliveryFee,
      'discount': discount,
      'total': total,
    };
  }

  @override
  String toString() {
    return 'PriceDetails{subtotal: $subtotal, tax: $tax, deliveryFee: $deliveryFee, discount: $discount, total: $total}';
  }
}

/// 配送信息模型
class DeliveryInfo {
  final String address;
  final Map<String, dynamic>? coordinates;
  final String contactName;
  final String contactPhone;
  final String? deliveryNotes;
  final String? estimatedDeliveryTime;
  final String? actualDeliveryTime;
  final String? deliveryPersonId;
  final String? deliveryStatus;

  DeliveryInfo({
    required this.address,
    this.coordinates,
    required this.contactName,
    required this.contactPhone,
    this.deliveryNotes,
    this.estimatedDeliveryTime,
    this.actualDeliveryTime,
    this.deliveryPersonId,
    this.deliveryStatus,
  });

  factory DeliveryInfo.fromJson(Map<String, dynamic> json) {
    return DeliveryInfo(
      address: json['address'] ?? '',
      coordinates: json['coordinates'],
      contactName: json['contactName'] ?? json['contact_name'] ?? '',
      contactPhone: json['contactPhone'] ?? json['contact_phone'] ?? '',
      deliveryNotes: json['deliveryNotes'] ?? json['delivery_notes'],
      estimatedDeliveryTime: json['estimatedDeliveryTime'] ?? json['estimated_delivery_time'],
      actualDeliveryTime: json['actualDeliveryTime'] ?? json['actual_delivery_time'],
      deliveryPersonId: json['deliveryPersonId'] ?? json['delivery_person_id'],
      deliveryStatus: json['deliveryStatus'] ?? json['delivery_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'coordinates': coordinates,
      'contactName': contactName,
      'contactPhone': contactPhone,
      'deliveryNotes': deliveryNotes,
      'estimatedDeliveryTime': estimatedDeliveryTime,
      'actualDeliveryTime': actualDeliveryTime,
      'deliveryPersonId': deliveryPersonId,
      'deliveryStatus': deliveryStatus,
    };
  }

  @override
  String toString() {
    return 'DeliveryInfo{address: $address, contactName: $contactName, contactPhone: $contactPhone}';
  }
}

/// 堂食信息模型
class DineInInfo {
  final String tableNumber;
  final int numberOfPeople;
  final String? specialRequests;

  DineInInfo({
    required this.tableNumber,
    required this.numberOfPeople,
    this.specialRequests,
  });

  factory DineInInfo.fromJson(Map<String, dynamic> json) {
    return DineInInfo(
      tableNumber: json['tableNumber'] ?? json['table_number'] ?? '',
      numberOfPeople: json['numberOfPeople'] ?? json['number_of_people'] ?? 1,
      specialRequests: json['specialRequests'] ?? json['special_requests'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tableNumber': tableNumber,
      'numberOfPeople': numberOfPeople,
      'specialRequests': specialRequests,
    };
  }

  @override
  String toString() {
    return 'DineInInfo{tableNumber: $tableNumber, numberOfPeople: $numberOfPeople}';
  }
}

/// 订单评价模型
class OrderRating {
  final double rating;
  final String? comment;
  final DateTime createdAt;
  final Map<String, double>? detailedRatings;

  OrderRating({
    required this.rating,
    this.comment,
    required this.createdAt,
    this.detailedRatings,
  });

  factory OrderRating.fromJson(Map<String, dynamic> json) {
    Map<String, double>? detailed;
    if (json['detailedRatings'] != null) {
      detailed = Map<String, double>.from(json['detailedRatings']);
    } else if (json['detailed_ratings'] != null) {
      detailed = Map<String, double>.from(json['detailed_ratings']);
    }

    return OrderRating(
      rating: (json['rating'] ?? 0).toDouble(),
      comment: json['comment'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : (json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : DateTime.now()),
      detailedRatings: detailed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'detailedRatings': detailedRatings,
    };
  }

  @override
  String toString() {
    return 'OrderRating{rating: $rating, comment: $comment != null ? "有评论" : "无评论"}';
  }
} 