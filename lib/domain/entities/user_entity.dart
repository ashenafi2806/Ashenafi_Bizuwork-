class UserEntity {
  final String id;
  final String name;
  final String phoneNumber;
  final double balance;
  final String currency;
  final String token;

  const UserEntity({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.balance,
    required this.currency,
    required this.token,
  });
}