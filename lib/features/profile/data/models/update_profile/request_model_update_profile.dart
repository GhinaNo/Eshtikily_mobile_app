class UpdateProfileRequest {
  final String? name;
  final String? phoneNumber;
  final String? password;

  UpdateProfileRequest({this.name, this.phoneNumber, this.password});

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (phoneNumber != null) data['phone_number'] = phoneNumber;
    if (password != null) data['password'] = password;
    return data;
  }
}
