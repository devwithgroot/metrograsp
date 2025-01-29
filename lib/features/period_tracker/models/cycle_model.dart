import 'package:cloud_firestore/cloud_firestore.dart';

class Cycle {
  final String? id;
  final String userId;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> symptoms;
  final int flowIntensity; // 1-5 scale

  Cycle({
    this.id,
    required this.userId,
    required this.startDate,
    required this.endDate,
    this.symptoms = const [],
    this.flowIntensity = 3,
  });

  factory Cycle.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Cycle(
      id: doc.id,
      userId: data['userId'],
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      symptoms: List<String>.from(data['symptoms']),
      flowIntensity: data['flowIntensity'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'symptoms': symptoms,
      'flowIntensity': flowIntensity,
    };
  }
}