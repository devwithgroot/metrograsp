import 'package:flutter/foundation.dart';
import '../models/cycle_model.dart';
import '../repositories/cycle_repository.dart';

class CycleProvider with ChangeNotifier {
  final CycleRepository _repository;
  List<Cycle> _cycles = [];
  DateTime? _predictedNextPeriod;

  CycleProvider(this._repository);

  List<Cycle> get cycles => _cycles;
  DateTime? get predictedNextPeriod => _predictedNextPeriod;

  // Load cycles from Firestore
  Future<void> loadCycles(String userId) async {
    _cycles = await _repository.getCycles(userId).first;
    _predictedNextPeriod = _repository.predictNextPeriod(_cycles);
    notifyListeners();
  }

  // Add new cycle
  Future<void> addCycle(Cycle cycle) async {
    await _repository.addCycle(cycle);
    await loadCycles(cycle.userId); // Refresh data
  }
}