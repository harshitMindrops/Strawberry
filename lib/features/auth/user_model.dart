class UserModel {
  final int id;
  final String name;
  final String role;
  final String status;

  UserModel({required this.id, required this.name, required this.role, required this.status});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'], name: json['name'], role: json['role'], status: json['status'],
  );
}