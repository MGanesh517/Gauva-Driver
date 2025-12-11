class GenderModel {
  final int id;
  final String? name;
  final String value;

  GenderModel({this.name, required this.value, required this.id});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is GenderModel &&
              runtimeType == other.runtimeType &&
              value == other.value;

  @override
  int get hashCode => value.hashCode;
}
