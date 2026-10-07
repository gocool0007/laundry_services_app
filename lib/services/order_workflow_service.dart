import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/freshpress_models.dart';

class OrderWorkflowService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Order creation workflow
  static Future<Order> initiateOrder({
    required String userId,
    required List<OrderItem> items,
    required double totalAmount,
    required String? notes,
    required DateTime? pickupDate,
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
        pickupDate: pickupDate,
        notes: notes,
      );

      await _firestore.collection('orders').doc(orderId).set(order.toMap());

      // Log order workflow event
      await _logOrderEvent(
        orderId: orderId,
        userId: userId,
        eventType: 'order_created',
        status: 'pending',
        details: 'Order created with ${items.length} items',
      );

      return order;
    } catch (e) {
      throw Exception('Failed to initiate order: $e');
    }
  }

  // Confirm order (customer confirms after review)
  static Future<void> confirmOrder(String orderId) async {
    try {
      final order = await _firestore.collection('orders').doc(orderId).get();
      if (!order.exists) throw Exception('Order not found');

      final orderData = Order.fromMap(order.data() as Map<String, dynamic>);

      await _firestore.collection('orders').doc(orderId).update({
        'status': 'confirmed',
      });

      await _logOrderEvent(
        orderId: orderId,
        userId: orderData.userId,
        eventType: 'order_confirmed',
        status: 'confirmed',
        details: 'Customer confirmed order',
      );
    } catch (e) {
      throw Exception('Failed to confirm order: $e');
    }
  }

  // Assign partner to order
  static Future<void> assignPartnerToOrder(
    String orderId,
    String partnerId,
  ) async {
    try {
      final order = await _firestore.collection('orders').doc(orderId).get();
      if (!order.exists) throw Exception('Order not found');

      final orderData = Order.fromMap(order.data() as Map<String, dynamic>);

      await _firestore.collection('orders').doc(orderId).update({
        'assignedPartnerId': partnerId,
      });

      // Create intake task for partner
      await PartnerTaskWorkflowService.createIntakeTask(
        partnerId: partnerId,
        orderId: orderId,
        itemCount: orderData.items.length,
      );

      await _logOrderEvent(
        orderId: orderId,
        userId: orderData.userId,
        eventType: 'partner_assigned',
        status: 'confirmed',
        details: 'Partner $partnerId assigned to order',
      );
    } catch (e) {
      throw Exception('Failed to assign partner: $e');
    }
  }

  // Mark order as picked up
  static Future<void> markOrderPickedUp(String orderId) async {
    try {
      final order = await _firestore.collection('orders').doc(orderId).get();
      if (!order.exists) throw Exception('Order not found');

      final orderData = Order.fromMap(order.data() as Map<String, dynamic>);

      await _firestore.collection('orders').doc(orderId).update({
        'status': 'in_progress',
      });

      await _logOrderEvent(
        orderId: orderId,
        userId: orderData.userId,
        eventType: 'order_pickup_completed',
        status: 'in_progress',
        details: 'Order picked up by partner',
      );
    } catch (e) {
      throw Exception('Failed to mark order as picked up: $e');
    }
  }

  // Mark order as processing complete
  static Future<void> markOrderProcessingComplete(String orderId) async {
    try {
      final order = await _firestore.collection('orders').doc(orderId).get();
      if (!order.exists) throw Exception('Order not found');

      final orderData = Order.fromMap(order.data() as Map<String, dynamic>);

      await _firestore.collection('orders').doc(orderId).update({
        'status': 'ready',
      });

      await _logOrderEvent(
        orderId: orderId,
        userId: orderData.userId,
        eventType: 'processing_complete',
        status: 'ready',
        details: 'Order processing complete and ready for pickup',
      );
    } catch (e) {
      throw Exception('Failed to mark order as ready: $e');
    }
  }

  // Deliver order
  static Future<void> deliverOrder(String orderId) async {
    try {
      final order = await _firestore.collection('orders').doc(orderId).get();
      if (!order.exists) throw Exception('Order not found');

      final orderData = Order.fromMap(order.data() as Map<String, dynamic>);

      await _firestore.collection('orders').doc(orderId).update({
        'status': 'completed',
        'deliveryDate': DateTime.now(),
      });

      await _logOrderEvent(
        orderId: orderId,
        userId: orderData.userId,
        eventType: 'order_delivered',
        status: 'completed',
        details: 'Order delivered successfully',
      );
    } catch (e) {
      throw Exception('Failed to deliver order: $e');
    }
  }

  // Cancel order
  static Future<void> cancelOrder(String orderId, String reason) async {
    try {
      final order = await _firestore.collection('orders').doc(orderId).get();
      if (!order.exists) throw Exception('Order not found');

      final orderData = Order.fromMap(order.data() as Map<String, dynamic>);

      await _firestore.collection('orders').doc(orderId).update({
        'status': 'cancelled',
      });

      await _logOrderEvent(
        orderId: orderId,
        userId: orderData.userId,
        eventType: 'order_cancelled',
        status: 'cancelled',
        details: 'Order cancelled: $reason',
      );
    } catch (e) {
      throw Exception('Failed to cancel order: $e');
    }
  }

  // Rate completed order
  static Future<void> rateOrder(
    String orderId,
    double rating,
    String review,
  ) async {
    try {
      final order = await _firestore.collection('orders').doc(orderId).get();
      if (!order.exists) throw Exception('Order not found');

      final orderData = Order.fromMap(order.data() as Map<String, dynamic>);

      await _firestore.collection('orders').doc(orderId).update({
        'rating': rating,
        'review': review,
      });

      // Update partner rating if order has assigned partner
      if (orderData.assignedPartnerId != null) {
        await _updatePartnerRating(
          partnerId: orderData.assignedPartnerId!,
          newRating: rating,
        );
      }

      await _logOrderEvent(
        orderId: orderId,
        userId: orderData.userId,
        eventType: 'order_rated',
        status: 'completed',
        details: 'Order rated $rating stars',
      );
    } catch (e) {
      throw Exception('Failed to rate order: $e');
    }
  }

  // Get order timeline (workflow history)
  static Stream<List<OrderEvent>> getOrderTimeline(String orderId) {
    return _firestore
        .collection('order_events')
        .where('orderId', isEqualTo: orderId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => OrderEvent.fromMap(doc.data()))
          .toList();
    });
  }

  // Private helper: log order event
  static Future<void> _logOrderEvent({
    required String orderId,
    required String userId,
    required String eventType,
    required String status,
    required String details,
  }) async {
    try {
      await _firestore.collection('order_events').add({
        'orderId': orderId,
        'userId': userId,
        'eventType': eventType,
        'status': status,
        'details': details,
        'timestamp': DateTime.now(),
      });
    } catch (e) {
      print('Error logging order event: $e');
    }
  }

  // Private helper: update partner rating
  static Future<void> _updatePartnerRating({
    required String partnerId,
    required double newRating,
  }) async {
    try {
      final partnerEarnings = await _firestore
          .collection('partner_earnings')
          .doc(partnerId)
          .get();

      if (partnerEarnings.exists) {
        final current = PartnerEarnings.fromMap(
          partnerEarnings.data() as Map<String, dynamic>,
        );

        final newAvgRating = (current.averageRating * current.completedTasks +
                newRating) /
            (current.completedTasks + 1);

        await _firestore
            .collection('partner_earnings')
            .doc(partnerId)
            .update({
          'averageRating': newAvgRating,
        });
      }
    } catch (e) {
      print('Error updating partner rating: $e');
    }
  }
}

class PartnerTaskWorkflowService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create intake task when order is assigned
  static Future<PartnerTask> createIntakeTask({
    required String partnerId,
    required String orderId,
    required int itemCount,
  }) async {
    try {
      final taskId = _firestore.collection('partner_tasks').doc().id;
      final now = DateTime.now();

      final task = PartnerTask(
        id: taskId,
        partnerId: partnerId,
        orderId: orderId,
        taskType: 'intake',
        status: 'open',
        createdAt: now,
        notes: 'Receive and verify $itemCount items',
        estimatedDuration: 15.0,
      );

      await _firestore.collection('partner_tasks').doc(taskId).set(task.toMap());

      return task;
    } catch (e) {
      throw Exception('Failed to create intake task: $e');
    }
  }

  // Mark intake complete and create processing task
  static Future<void> completeIntakeAndCreateProcessing(
    String intakeTaskId,
    String orderId,
    String partnerId,
  ) async {
    try {
      // Mark intake as complete
      await _firestore.collection('partner_tasks').doc(intakeTaskId).update({
        'status': 'completed',
        'completedAt': DateTime.now(),
      });

      // Create processing task
      final processingTaskId =
          _firestore.collection('partner_tasks').doc().id;
      final now = DateTime.now();

      final processingTask = PartnerTask(
        id: processingTaskId,
        partnerId: partnerId,
        orderId: orderId,
        taskType: 'processing',
        status: 'open',
        createdAt: now,
        notes: 'Process and finish garments',
        estimatedDuration: 120.0,
      );

      await _firestore
          .collection('partner_tasks')
          .doc(processingTaskId)
          .set(processingTask.toMap());
    } catch (e) {
      throw Exception('Failed to complete intake: $e');
    }
  }

  // Complete processing and create quality check task
  static Future<void> completeProcessingAndCreateQualityCheck(
    String processingTaskId,
    String orderId,
    String partnerId,
  ) async {
    try {
      // Mark processing as complete
      await _firestore.collection('partner_tasks').doc(processingTaskId).update(
        {
          'status': 'completed',
          'completedAt': DateTime.now(),
        },
      );

      // Create quality check task
      final qcTaskId = _firestore.collection('partner_tasks').doc().id;
      final now = DateTime.now();

      final qcTask = PartnerTask(
        id: qcTaskId,
        partnerId: partnerId,
        orderId: orderId,
        taskType: 'quality_check',
        status: 'open',
        createdAt: now,
        notes: 'Final quality check and seal confirmation',
        estimatedDuration: 20.0,
      );

      await _firestore.collection('partner_tasks').doc(qcTaskId).set(qcTask.toMap());
    } catch (e) {
      throw Exception('Failed to complete processing: $e');
    }
  }

  // Complete quality check and mark order as ready
  static Future<void> completeQualityCheckAndMarkReady(
    String qcTaskId,
    String orderId,
  ) async {
    try {
      // Mark QC as complete
      await _firestore.collection('partner_tasks').doc(qcTaskId).update({
        'status': 'completed',
        'completedAt': DateTime.now(),
      });

      // Update order status to ready
      await OrderWorkflowService.markOrderProcessingComplete(orderId);
    } catch (e) {
      throw Exception('Failed to complete quality check: $e');
    }
  }

  // Scan barcode for item
  static Future<void> scanItemBarcode(
    String taskId,
    String barcode,
  ) async {
    try {
      await _firestore.collection('partner_tasks').doc(taskId).update({
        'itemBarcodes': FieldValue.arrayUnion([barcode]),
      });
    } catch (e) {
      throw Exception('Failed to scan barcode: $e');
    }
  }

  // Get active task for partner
  static Stream<PartnerTask?> getActiveTaskForPartner(String partnerId) {
    return _firestore
        .collection('partner_tasks')
        .where('partnerId', isEqualTo: partnerId)
        .where('status', isEqualTo: 'open')
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      return PartnerTask.fromMap(
        snapshot.docs.first.data() as Map<String, dynamic>,
      );
    });
  }
}

class OrderEvent {
  final String orderId;
  final String userId;
  final String eventType;
  final String status;
  final String details;
  final DateTime timestamp;

  OrderEvent({
    required this.orderId,
    required this.userId,
    required this.eventType,
    required this.status,
    required this.details,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'userId': userId,
      'eventType': eventType,
      'status': status,
      'details': details,
      'timestamp': timestamp,
    };
  }

  factory OrderEvent.fromMap(Map<String, dynamic> map) {
    return OrderEvent(
      orderId: map['orderId'] ?? '',
      userId: map['userId'] ?? '',
      eventType: map['eventType'] ?? '',
      status: map['status'] ?? '',
      details: map['details'] ?? '',
      timestamp:
          (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
