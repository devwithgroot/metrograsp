import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cycle_model.dart';

class CycleRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new cycle
  Future<void> addCycle(Cycle cycle) async {
    await _firestore.collection('cycles').add(cycle.toFirestore());
  }

  // Get all cycles for a user
  Stream<List<Cycle>> getCycles(String userId) {
    return _firestore
        .collection('cycles')
        .where('userId', isEqualTo: userId)
        .orderBy('startDate', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Cycle.fromFirestore(doc)).toList());
  }

  // Predict next period (simplified logic)
  DateTime predictNextPeriod(List<Cycle> cycles) {
    if (cycles.isEmpty) return DateTime.now().add(const Duration(days: 28));
    final avgCycleLength = cycles
        .map((c) => c.endDate.difference(c.startDate).inDays)
        .reduce((a, b) => a + b) /
        cycles.length;
    return cycles.last.endDate.add(Duration(days: avgCycleLength.round()));
  }
}