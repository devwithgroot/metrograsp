class AppUser {
  final String id;
  final String email;
  final String? name;
  final int? age;
  final int? cycleLength;
  final DateTime? firstPeriodDate;

  AppUser({
    required this.id,
    required this.email,
    this.name,
    this.age,
    this.cycleLength,
    this.firstPeriodDate,
  });

  factory AppUser.fromFirestore(Map<String, dynamic> data) {
    return AppUser(
      id: data['id'],
      email: data['email'],
      name: data['name'],
      age: data['age'],
      cycleLength: data['cycleLength'],
      firstPeriodDate: data['firstPeriodDate']?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'age': age,
      'cycleLength': cycleLength,
      'firstPeriodDate': firstPeriodDate,
    };
  }
}