enum StopStatus { pending, delivering, delivered }

class DeliveryStop {
  final String id;
  final String address;
  final String name;
  final List<String> items;
  final int orderIndex;
  final StopStatus status;
  final String? recipientName;
  final DateTime? deliveredAt;

  DeliveryStop({
    required this.id,
    required this.address,
    required this.name,
    this.items = const [],
    required this.orderIndex,
    this.status = StopStatus.pending,
    this.recipientName,
    this.deliveredAt,
  });

  bool get isDelivered => status == StopStatus.delivered;
  bool get isDelivering => status == StopStatus.delivering;
  bool get isPending => status == StopStatus.pending;

  Map<String, dynamic> toMap() => {
        'id': id,
        'address': address,
        'name': name,
        'items': items,
        'orderIndex': orderIndex,
        'status': status.name,
        'recipientName': recipientName,
        'deliveredAt': deliveredAt?.toIso8601String(),
      };

  factory DeliveryStop.fromMap(Map<String, dynamic> map) => DeliveryStop(
        id: map['id'] ?? '',
        address: map['address'] ?? '',
        name: map['name'] ?? '',
        items: (map['items'] as List?)?.cast<String>() ?? [],
        orderIndex: map['orderIndex'] ?? 0,
        status: StopStatus.values.firstWhere(
          (s) => s.name == map['status'],
          orElse: () => StopStatus.pending,
        ),
        recipientName: map['recipientName'],
        deliveredAt: map['deliveredAt'] != null
            ? DateTime.parse(map['deliveredAt'])
            : null,
      );

  DeliveryStop copyWith({
    String? id,
    String? address,
    String? name,
    List<String>? items,
    int? orderIndex,
    StopStatus? status,
    String? recipientName,
    DateTime? deliveredAt,
  }) {
    return DeliveryStop(
      id: id ?? this.id,
      address: address ?? this.address,
      name: name ?? this.name,
      items: items ?? this.items,
      orderIndex: orderIndex ?? this.orderIndex,
      status: status ?? this.status,
      recipientName: recipientName ?? this.recipientName,
      deliveredAt: deliveredAt ?? this.deliveredAt,
    );
  }
}
