class FamilyGroup {
  final String id;
  final String name;
  final String inviteCode;
  final String createdBy;
  final List<String> memberIds;
  final List<String> parentIds;
  final DateTime createdAt;

  FamilyGroup({
    required this.id,
    required this.name,
    required this.inviteCode,
    required this.createdBy,
    required this.memberIds,
    required this.parentIds,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'inviteCode': inviteCode,
      'createdBy': createdBy,
      'memberIds': memberIds,
      // Keep Firestore field as 'dadIds' for backward compatibility
      'dadIds': parentIds,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory FamilyGroup.fromMap(Map<String, dynamic> map) {
    return FamilyGroup(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      inviteCode: map['inviteCode'] ?? '',
      createdBy: map['createdBy'] ?? '',
      memberIds: List<String>.from(map['memberIds'] ?? []),
      // Read from Firestore field 'dadIds'
      parentIds: List<String>.from(map['dadIds'] ?? []),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }
}
