import 'package:json_annotation/json_annotation.dart';

enum WorkspaceType {
  @JsonValue('user')
  user,
  @JsonValue('merchant')
  merchant,
  @JsonValue('nutritionist')
  nutritionist,
}

class Workspace {
  final WorkspaceType type;
  final String title;
  final String description;
  final String iconPath;
  final bool isAvailable;
  final String? unavailableReason;

  const Workspace({
    required this.type,
    required this.title,
    required this.description,
    required this.iconPath,
    this.isAvailable = true,
    this.unavailableReason,
  });
}

extension WorkspaceTypeExtension on WorkspaceType {
  String get displayName {
    switch (this) {
      case WorkspaceType.user:
        return '用户工作台';
      case WorkspaceType.merchant:
        return '商家工作台';
      case WorkspaceType.nutritionist:
        return '营养师工作台';
    }
  }

  String get description {
    switch (this) {
      case WorkspaceType.user:
        return '浏览菜品、营养咨询、健康管理';
      case WorkspaceType.merchant:
        return '店铺管理、菜品发布、订单处理';
      case WorkspaceType.nutritionist:
        return '营养咨询、方案制定、客户管理';
    }
  }

  String get iconName {
    switch (this) {
      case WorkspaceType.user:
        return 'person';
      case WorkspaceType.merchant:
        return 'store';
      case WorkspaceType.nutritionist:
        return 'local_hospital';
    }
  }
}

class WorkspaceState {
  final WorkspaceType currentWorkspace;
  final List<Workspace> availableWorkspaces;
  final bool isLoading;
  final String? error;

  const WorkspaceState({
    required this.currentWorkspace,
    required this.availableWorkspaces,
    this.isLoading = false,
    this.error,
  });

  WorkspaceState copyWith({
    WorkspaceType? currentWorkspace,
    List<Workspace>? availableWorkspaces,
    bool? isLoading,
    String? error,
  }) {
    return WorkspaceState(
      currentWorkspace: currentWorkspace ?? this.currentWorkspace,
      availableWorkspaces: availableWorkspaces ?? this.availableWorkspaces,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  bool get hasMerchantAccess => availableWorkspaces.any(
    (w) => w.type == WorkspaceType.merchant && w.isAvailable
  );

  bool get hasNutritionistAccess => availableWorkspaces.any(
    (w) => w.type == WorkspaceType.nutritionist && w.isAvailable
  );

  bool get hasMultipleWorkspaces => availableWorkspaces.where(
    (w) => w.isAvailable
  ).length > 1;
}