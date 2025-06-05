import 'package:flutter/material.dart';

/// 用户头像组件，支持角色标识
class UserAvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double size;
  final UserRole? role;
  final bool showRoleBadge;
  final VoidCallback? onTap;
  
  const UserAvatarWidget({
    super.key,
    this.imageUrl,
    this.name,
    this.size = 40,
    this.role,
    this.showRoleBadge = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.primaryColor.withOpacity(0.1),
              border: Border.all(
                color: theme.primaryColor.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: ClipOval(
              child: imageUrl != null
                  ? Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildDefaultAvatar(theme);
                      },
                    )
                  : _buildDefaultAvatar(theme),
            ),
          ),
          if (showRoleBadge && role != null)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: size * 0.35,
                height: size * 0.35,
                decoration: BoxDecoration(
                  color: _getRoleColor(role!),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Icon(
                    _getRoleIcon(role!),
                    color: Colors.white,
                    size: size * 0.2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar(ThemeData theme) {
    final initial = name?.isNotEmpty == true ? name![0].toUpperCase() : '?';
    
    return Container(
      color: theme.primaryColor.withOpacity(0.1),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            color: theme.primaryColor,
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.nutritionist:
        return Colors.green;
      case UserRole.merchant:
        return Colors.blue;
      case UserRole.employee:
        return Colors.orange;
      case UserRole.admin:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.nutritionist:
        return Icons.medical_services;
      case UserRole.merchant:
        return Icons.store;
      case UserRole.employee:
        return Icons.badge;
      case UserRole.admin:
        return Icons.admin_panel_settings;
      default:
        return Icons.person;
    }
  }
}

/// 用户角色枚举
enum UserRole {
  user,
  nutritionist,
  merchant,
  employee,
  admin,
}