import 'anggota.dart';

/// Backend role enums — mirrors types.ts BackendRole
enum BackendRole {
  adminKoperasi('ADMIN_KOPERASI'),
  pimpinan('PIMPINAN'),
  keprim('KEPRIM'),
  kaprim('KAPRIM'),
  bendahara('BENDAHARA'),
  pengawas('PENGAWAS'),
  anggota('ANGGOTA'),
  juruBayar('JURU_BAYAR'),
  kasirToko('KASIR_TOKO');

  const BackendRole(this.value);
  final String value;

  static BackendRole fromString(String s) {
    final clean = s.trim().toUpperCase();
    return BackendRole.values.firstWhere(
      (e) => e.value == clean || e.name.toUpperCase() == clean,
      orElse: () => BackendRole.adminKoperasi,
    );
  }
}

/// Frontend role display names
enum Role {
  adminKoperasi('Admin Koperasi', 'Admin', 'ADMIN_KOPERASI'),
  pimpinan('Pimpinan / Dan / Ka', 'Dan/Ka', 'PIMPINAN'),
  keprim('Keprim', 'Keprim', 'KEPRIM'),
  bendahara('Bendahara', 'Bendahara', 'BENDAHARA'),
  juruBayar('Juru Bayar', 'Juyar', 'JURU_BAYAR'),
  kasirToko('Kasir Toko', 'Kasir', 'KASIR_TOKO'),
  anggota('Anggota', 'Anggota', 'ANGGOTA'),
  pengawas('Pengawas Koperasi', 'Pengawas', 'PENGAWAS');

  const Role(this.label, this.shortLabel, this.value);
  final String label;
  final String shortLabel;
  final String value;

  static Role fromString(String s) {
    final clean = s.trim().toUpperCase();
    for (final r in Role.values) {
      if (r.name.toUpperCase() == clean ||
          r.label.toUpperCase() == clean ||
          r.shortLabel.toUpperCase() == clean ||
          r.value.toUpperCase() == clean) {
        return r;
      }
    }
    return Role.adminKoperasi;
  }
}

/// Login request DTO
class LoginDto {
  final String username;
  final String? password;

  LoginDto({required this.username, this.password});

  Map<String, dynamic> toJson() => {
        'username': username,
        if (password != null) 'password': password,
      };
}

/// Login response from POST /auth/login
class LoginResponse {
  final String message;
  final String accessToken;
  final LoginUser user;

  LoginResponse({
    required this.message,
    required this.accessToken,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        message: json['message'] as String? ?? '',
        accessToken: json['accessToken'] as String? ?? json['token'] as String? ?? '',
        user: LoginUser.fromJson(json['user'] as Map<String, dynamic>),
      );
}

class LoginUser {
  final String id;
  final String namaLengkap;
  final String role;
  final String? kotama;
  final String? satminkal;

  LoginUser({
    required this.id,
    required this.namaLengkap,
    required this.role,
    this.kotama,
    this.satminkal,
  });

  factory LoginUser.fromJson(Map<String, dynamic> json) => LoginUser(
        id: json['id'] as String? ?? '',
        namaLengkap: json['namaLengkap'] as String? ?? json['username'] as String? ?? '',
        role: json['role'] as String? ?? 'ADMIN_KOPERASI',
        kotama: json['kotama'] as String?,
        satminkal: json['satminkal'] as String?,
      );
}

/// User profile from GET /auth/profile
class UserProfile {
  final String? id;
  final String? sub;
  final String username;
  final String? namaLengkap;
  final String role;
  final String? kotamaId;
  final String? satminkalId;
  final String? kotama;
  final String? satminkal;

  UserProfile({
    this.id,
    this.sub,
    required this.username,
    this.namaLengkap,
    required this.role,
    this.kotamaId,
    this.satminkalId,
    this.kotama,
    this.satminkal,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: json['id'] as String?,
        sub: json['sub'] as String?,
        username: json['username'] as String? ?? '',
        namaLengkap: json['namaLengkap'] as String?,
        role: json['role'] as String? ?? 'ANGGOTA',
        kotamaId: json['kotamaId'] as String?,
        satminkalId: json['satminkalId'] as String?,
        kotama: json['kotama'] as String?,
        satminkal: json['satminkal'] as String?,
      );
}

/// Local session data stored in device storage
class UserSessionData {
  final String id;
  final String namaLengkap;
  final String username;
  final Role role;
  final Role? originalRole;
  final BackendRole? backendRole;
  final Satminkal? satminkal;
  final Kotama? kotama;
  final bool isActive;
  final String? token;
  final Anggota? anggota;

  const UserSessionData({
    required this.id,
    required this.namaLengkap,
    required this.username,
    required this.role,
    this.originalRole,
    this.backendRole,
    this.satminkal,
    this.kotama,
    this.isActive = true,
    this.token,
    this.anggota,
  });

  UserSessionData copyWith({
    String? id,
    String? namaLengkap,
    String? username,
    Role? role,
    Role? originalRole,
    BackendRole? backendRole,
    Satminkal? satminkal,
    Kotama? kotama,
    bool? isActive,
    String? token,
    Anggota? anggota,
  }) {
    return UserSessionData(
      id: id ?? this.id,
      namaLengkap: namaLengkap ?? this.namaLengkap,
      username: username ?? this.username,
      role: role ?? this.role,
      originalRole: originalRole ?? this.originalRole,
      backendRole: backendRole ?? this.backendRole,
      satminkal: satminkal ?? this.satminkal,
      kotama: kotama ?? this.kotama,
      isActive: isActive ?? this.isActive,
      token: token ?? this.token,
      anggota: anggota ?? this.anggota,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'namaLengkap': namaLengkap,
        'username': username,
        'role': role.value,
        'originalRole': originalRole?.value,
        'backendRole': backendRole?.value,
        'satminkal': satminkal?.toJson(),
        'kotama': kotama?.toJson(),
        'isActive': isActive,
        'token': token,
        'anggota': anggota?.toJson(),
      };

  factory UserSessionData.fromJson(Map<String, dynamic> json) {
    Satminkal? parseSatminkal(dynamic s) {
      if (s == null) return null;
      if (s is Map<String, dynamic>) return Satminkal.fromJson(s);
      if (s is String) return Satminkal(id: 'SAT-01', kode: s, nama: s);
      return null;
    }

    Kotama? parseKotama(dynamic k) {
      if (k == null) return null;
      if (k is Map<String, dynamic>) return Kotama.fromJson(k);
      if (k is String) return Kotama(id: 'KOT-01', kode: k, nama: k);
      return null;
    }

    Anggota? parseAnggota(dynamic a) {
      if (a == null) return null;
      if (a is Map<String, dynamic>) return Anggota.fromJson(a);
      return null;
    }

    final roleStr = json['role'] as String? ?? 'ADMIN_KOPERASI';
    final origRoleStr = json['originalRole'] as String?;

    return UserSessionData(
      id: json['id'] as String? ?? '',
      namaLengkap: json['namaLengkap'] as String? ?? json['username'] as String? ?? '',
      username: json['username'] as String? ?? '',
      role: Role.fromString(roleStr),
      originalRole: origRoleStr != null ? Role.fromString(origRoleStr) : null,
      backendRole: json['backendRole'] != null
          ? BackendRole.fromString(json['backendRole'] as String)
          : null,
      satminkal: parseSatminkal(json['satminkal']),
      kotama: parseKotama(json['kotama']),
      isActive: json['isActive'] as bool? ?? json['isAktif'] as bool? ?? true,
      token: json['token'] as String?,
      anggota: parseAnggota(json['anggota']),
    );
  }
}

/// User item (from /users list)
class UserItem {
  final String id;
  final String username;
  final String? namaLengkap;
  final String role;
  final bool isActive;
  final String? email;
  final String? phone;
  final String? createdAt;
  final String? lastActiveAt;
  final String? kotamaId;
  final String? satminkalId;

  UserItem({
    required this.id,
    required this.username,
    this.namaLengkap,
    required this.role,
    this.isActive = true,
    this.email,
    this.phone,
    this.createdAt,
    this.lastActiveAt,
    this.kotamaId,
    this.satminkalId,
  });

  factory UserItem.fromJson(Map<String, dynamic> json) => UserItem(
        id: json['id'] as String? ?? '',
        username: json['username'] as String? ?? '',
        namaLengkap: json['namaLengkap'] as String?,
        role: json['role'] as String? ?? 'ANGGOTA',
        isActive: json['isActive'] as bool? ?? json['isAktif'] as bool? ?? true,
        email: json['email'] as String?,
        phone: json['phone'] as String?,
        createdAt: json['createdAt'] as String?,
        lastActiveAt: json['lastActiveAt'] as String?,
        kotamaId: json['kotamaId'] as String?,
        satminkalId: json['satminkalId'] as String?,
      );
}
