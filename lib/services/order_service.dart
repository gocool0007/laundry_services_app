import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart':
import '../models/freshpress_models.dart';
import 'firebase_app_service.dart';

class OrderService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new order
  static Future<Order> createOrder({
    required String userId,
    required List<OrderItem> items,
    required double totalAmount,
    String? notes,
  }) async {
    try {
      final orderId = _firestore.collection('orders').doc().id;
      final now = DateTime.now();

      final order = Order(
        id: orderId,
        userId: userId,
        items: items,
        status: 'pending',
        totalAmount: totalAmount,
        currency: 'INR',
        createdAt: now,
        notes: notes,
      );

      await _firestore.collection('orders').doc(orderId).set(order.toMap());
      return order;
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  // Get user orders
  static Stream<List<Order>> getUserOrders(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Order.fromMap(doc.data()))
          .toList();
    });
  }

  // Get single order
  static Future<Order?> getOrder(String orderId) async {
    try {
      final doc = await _firestore.collection('orders').doc(orderId).get();
      if (doc.exists) {
        return Order.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch order: $e');
    }
  }

  // Update order status
  static Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': newStatus,
      });
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  // Assign partner to order
  static Future<void> assignPartnerToOrder(
    String orderId,
    String partnerId,
  ) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'assignedPartnerId': partnerId,
        'status': 'confirmed',
      });
    } catch (e) {
      throw Exception('Failed to assign partner: $e');
    }
  }

  // Rate order
  static Future<void> rateOrder(
    String orderId,
    double rating,
    String review,
  ) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'rating': rating,
        'review': review,
        'status': 'completed',
      });
    } catch (e) {
      throw Exception('Failed to rate order: $e');
    }
  }
}

class PartnerTaskService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create task for partner
  static Future<PartnerTask> createTask({
    required String partnerId,
    required String orderId,
    required String taskType,
  }) async {
    try {
      final taskId = _firestore.collection('partner_tasks').doc().id;
      final now = DateTime.now();

      final task = PartnerTask(
        id: taskId,
        partnerId: partnerId,
        orderId: orderId,
        taskType: taskType,
        status: 'open',
        createdAt: now,
      );

      await _firestore.collection('partner_tasks').doc(taskId).set(task.toMap());
      return task;
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  // Get partner tasks
  static Stream<List<PartnerTask>> getPartnerTasks(String partnerId) {
    return _firestore
        .collection('partner_tasks')
        .where('partnerId', isEqualTo: partnerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => PartnerTask.fromMap(doc.data()))
          .toList();
    });
  }

  // Update task status
  static Future<void> updateTaskStatus(String taskId, String newStatus) async {
    try {
      await _firestore.collection('partner_tasks').doc(taskId).update({
        'status': newStatus,
        if (newStatus == 'completed') 'completedAt': DateTime.now(),
      });
    } catch (e) {
      throw Exception('Failed to update task status: $e');
    }
  }

  // Add barcode to task
  static Future<void> addBarcodeToTask(String taskId, String barcode) async {
    try {
      await _firestore.collection('partner_tasks').doc(taskId).update({
        'itemBarcodes': FieldValue.arrayUnion([barcode]),
      });
    } catch (e) {
      throw Exception('Failed to add barcode: $e');
    }
  }
}

class EarningsService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get partner earnings
  static Future<PartnerEarnings?> getPartnerEarnings(String partnerId) async {
    try {
      final doc =
          await _firestore.collection('partner_earnings').doc(partnerId).get();
      if (doc.exists) {
        return PartnerEarnings.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch earnings: $e');
    }
  }

  // Update earnings after task completion
  static Future<void> updateEarningsAfterTask(
    String partnerId,
    double amount,
  ) async {
    try {
      final docRef =
          _firestore.collection('partner_earnings').doc(partnerId);
      await docRef.update({
        'weekEarnings': FieldValue.increment(amount),
        'monthEarnings': FieldValue.increment(amount),
        'totalEarnings': FieldValue.increment(amount),
        'pendingAmount': FieldValue.increment(amount),
        'completedTasks': FieldValue.increment(1),
      });
    } catch (e) {
      throw Exception('Failed to update earnings: $e');
    }
  }
}

class ServiceCatalogService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all services
  static Stream<List<Service>> getServices() {
    return _firestore
        .collection('services')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Service.fromMap(doc.data()))
          .toList();
    });
  }

  // Get service by category
  static Stream<List<Service>> getServicesByCategory(String category) {
    return _firestore
        .collection('services')
        .where('category', isEqualTo: category)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Service.fromMap(doc.data()))
          .toList();
    });
  }
}
