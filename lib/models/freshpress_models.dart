import 'package:cloud_firestore/cloud_firestore.dart';

class FreshPressUser {
  final String uid;
  final String email;
  final String displayName;
  final String role; // 'customer', 'partner'
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? phoneNumber;
  final String? profileImageUrl;
  final double? rating;
  final int? reviewCount;

  FreshPressUser({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    this.phoneNumber,
    this.profileImageUrl,
    this.rating,
    this.reviewCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'role': role,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }

  factory FreshPressUser.fromMap(Map<String, dynamic> map) {
    return FreshPressUser(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      role: map['role'] ?? 'customer',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      phoneNumber: map['phoneNumber'],
      profileImageUrl: map['profileImageUrl'],
      rating: (map['rating'] as num?)?.toDouble(),
      reviewCount: map['reviewCount'],
    );
  }
}

class Service {
  final String id;
  final String name;
  final String description;
  final double basePrice;
  final String currency; // 'INR'
  final String category; // 'express', 'traditional', 'regular'
  final List<String> features;
  final bool isActive;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.basePrice,
    required this.currency,
    required this.category,
    required this.features,
    required this.isActive,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'basePrice': basePrice,
      'currency': currency,
      'category': category,
      'features': features,
      'isActive': isActive,
    };
  }

  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      basePrice: (map['basePrice'] as num?)?.toDouble() ?? 0.0,
      currency: map['currency'] ?? 'INR',
      category: map['category'] ?? 'regular',
      features: List<String>.from(map['features'] ?? []),
      isActive: map['isActive'] ?? true,
    );
  }
}

class OrderItem {
  final String id;
  final String garmentType; // 'shirt', 'pants', 'formal', etc.
  final int quantity;
  final String serviceType; // 'wash', 'iron', 'tailoring'
  final double pricePerUnit;
  final double totalPrice;
  final String? specialInstructions;

  OrderItem({
    required this.id,
    required this.garmentType,
    required this.quantity,
    required this.serviceType,
    required this.pricePerUnit,
    required this.totalPrice,
    this.specialInstructions,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'garmentType': garmentType,
      'quantity': quantity,
      'serviceType': serviceType,
      'pricePerUnit': pricePerUnit,
      'totalPrice': totalPrice,
      'specialInstructions': specialInstructions,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id'] ?? '',
      garmentType: map['garmentType'] ?? '',
      quantity: map['quantity'] ?? 0,
      serviceType: map['serviceType'] ?? '',
      pricePerUnit: (map['pricePerUnit'] as num?)?.toDouble() ?? 0.0,
      totalPrice: (map['totalPrice'] as num?)?.toDouble() ?? 0.0,
      specialInstructions: map['specialInstructions'],
    );
  }
}

class Order {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final String status; // 'pending', 'confirmed', 'in_progress', 'ready', 'completed', 'cancelled'
  final double totalAmount;
  final String currency; // 'INR'
  final DateTime createdAt;
  final DateTime? pickupDate;
  final DateTime? deliveryDate;
  final String? assignedPartnerId;
  final String? notes;
  final double? rating;
  final String? review;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.status,
    required this.totalAmount,
    required this.currency,
    required this.createdAt,
    this.pickupDate,
    this.deliveryDate,
    this.assignedPartnerId,
    this.notes,
    this.rating,
    this.review,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'status': status,
      'totalAmount': totalAmount,
      'currency': currency,
      'createdAt': createdAt,
      'pickupDate': pickupDate,
      'deliveryDate': deliveryDate,
      'assignedPartnerId': assignedPartnerId,
      'notes': notes,
      'rating': rating,
      'review': review,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      items: (map['items'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
      status: map['status'] ?? 'pending',
      totalAmount: (map['totalAmount'] as num?)?.toDouble() ?? 0.0,
      currency: map['currency'] ?? 'INR',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      pickupDate: (map['pickupDate'] as Timestamp?)?.toDate(),
      deliveryDate: (map['deliveryDate'] as Timestamp?)?.toDate(),
      assignedPartnerId: map['assignedPartnerId'],
      notes: map['notes'],
      rating: (map['rating'] as num?)?.toDouble(),
      review: map['review'],
    );
  }
}

class PartnerTask {
  final String id;
  final String partnerId;
  final String orderId;
  final String taskType; // 'intake', 'processing', 'quality_check', 'delivery'
  final String status; // 'open', 'in_progress', 'completed', 'on_hold'
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? notes;
  final List<String>? itemBarcodes;
  final double? estimatedDuration; // in minutes

  PartnerTask({
    required this.id,
    required this.partnerId,
    required this.orderId,
    required this.taskType,
    required this.status,
    required this.createdAt,
    this.completedAt,
    this.notes,
    this.itemBarcodes,
    this.estimatedDuration,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'partnerId': partnerId,
      'orderId': orderId,
      'taskType': taskType,
      'status': status,
      'createdAt': createdAt,
      'completedAt': completedAt,
      'notes': notes,
      'itemBarcodes': itemBarcodes,
      'estimatedDuration': estimatedDuration,
    };
  }

  factory PartnerTask.fromMap(Map<String, dynamic> map) {
    return PartnerTask(
      id: map['id'] ?? '',
      partnerId: map['partnerId'] ?? '',
      orderId: map['orderId'] ?? '',
      taskType: map['taskType'] ?? 'intake',
      status: map['status'] ?? 'open',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      completedAt: (map['completedAt'] as Timestamp?)?.toDate(),
      notes: map['notes'],
      itemBarcodes: List<String>.from(map['itemBarcodes'] ?? []),
      estimatedDuration: (map['estimatedDuration'] as num?)?.toDouble(),
    );
  }
}

class PartnerEarnings {
  final String partnerId;
  final double weekEarnings;
  final double monthEarnings;
  final double totalEarnings;
  final double pendingAmount;
  final double releasedAmount;
  final String currency; // 'INR'
  final DateTime? nextPayoutDate;
  final int completedTasks;
  final double averageRating;

  PartnerEarnings({
    required this.partnerId,
    required this.weekEarnings,
    required this.monthEarnings,
    required this.totalEarnings,
    required this.pendingAmount,
    required this.releasedAmount,
    required this.currency,
    this.nextPayoutDate,
    required this.completedTasks,
    required this.averageRating,
  });

  Map<String, dynamic> toMap() {
    return {
      'partnerId': partnerId,
      'weekEarnings': weekEarnings,
      'monthEarnings': monthEarnings,
      'totalEarnings': totalEarnings,
      'pendingAmount': pendingAmount,
      'releasedAmount': releasedAmount,
      'currency': currency,
      'nextPayoutDate': nextPayoutDate,
      'completedTasks': completedTasks,
      'averageRating': averageRating,
    };
  }

  factory PartnerEarnings.fromMap(Map<String, dynamic> map) {
    return PartnerEarnings(
      partnerId: map['partnerId'] ?? '',
      weekEarnings: (map['weekEarnings'] as num?)?.toDouble() ?? 0.0,
      monthEarnings: (map['monthEarnings'] as num?)?.toDouble() ?? 0.0,
      totalEarnings: (map['totalEarnings'] as num?)?.toDouble() ?? 0.0,
      pendingAmount: (map['pendingAmount'] as num?)?.toDouble() ?? 0.0,
      releasedAmount: (map['releasedAmount'] as num?)?.toDouble() ?? 0.0,
      currency: map['currency'] ?? 'INR',
      nextPayoutDate: (map['nextPayoutDate'] as Timestamp?)?.toDate(),
      completedTasks: map['completedTasks'] ?? 0,
      averageRating: (map['averageRating'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
