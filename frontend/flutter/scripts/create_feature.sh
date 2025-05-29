#!/bin/bash

# 功能模块创建脚本
# 使用方法: ./scripts/create_feature.sh [feature_name]

if [ -z "$1" ]; then
  echo "❌ 请提供功能名称"
  echo "使用方法: ./scripts/create_feature.sh [feature_name]"
  echo "示例: ./scripts/create_feature.sh payment"
  exit 1
fi

FEATURE_NAME=$1
FEATURE_NAME_LOWER=$(echo "$FEATURE_NAME" | tr '[:upper:]' '[:lower:]')
FEATURE_NAME_PASCAL=$(echo "$FEATURE_NAME" | sed -r 's/(^|_)([a-z])/\U\2/g')

BASE_DIR="lib/features/$FEATURE_NAME_LOWER"

echo "🚀 创建功能模块: $FEATURE_NAME"

# 创建目录结构
echo "📁 创建目录结构..."
mkdir -p $BASE_DIR/{data/{datasources,models,repositories},domain/{entities,repositories,usecases,value_objects},presentation/{pages,widgets,providers}}

# 创建基础文件
echo "📝 创建基础文件..."

# Domain - Entity
cat > $BASE_DIR/domain/entities/${FEATURE_NAME_LOWER}.dart << EOF
import 'package:equatable/equatable.dart';

/// $FEATURE_NAME_PASCAL 实体
class $FEATURE_NAME_PASCAL extends Equatable {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const $FEATURE_NAME_PASCAL({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });
  
  @override
  List<Object?> get props => [id, createdAt, updatedAt];
}
EOF

# Domain - Repository Interface
cat > $BASE_DIR/domain/repositories/${FEATURE_NAME_LOWER}_repository.dart << EOF
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/${FEATURE_NAME_LOWER}.dart';

/// $FEATURE_NAME_PASCAL 仓储接口
abstract class ${FEATURE_NAME_PASCAL}Repository {
  Future<Either<Failure, List<$FEATURE_NAME_PASCAL>>> get${FEATURE_NAME_PASCAL}s();
  Future<Either<Failure, $FEATURE_NAME_PASCAL>> get${FEATURE_NAME_PASCAL}(String id);
  Future<Either<Failure, $FEATURE_NAME_PASCAL>> create${FEATURE_NAME_PASCAL}($FEATURE_NAME_PASCAL ${FEATURE_NAME_LOWER});
  Future<Either<Failure, $FEATURE_NAME_PASCAL>> update${FEATURE_NAME_PASCAL}($FEATURE_NAME_PASCAL ${FEATURE_NAME_LOWER});
  Future<Either<Failure, Unit>> delete${FEATURE_NAME_PASCAL}(String id);
}
EOF

# Domain - UseCase
cat > $BASE_DIR/domain/usecases/get_${FEATURE_NAME_LOWER}s_usecase.dart << EOF
import 'package:dartz/dartz.dart';
import '../../../../core/base/use_case.dart';
import '../../../../core/error/failures.dart';
import '../entities/${FEATURE_NAME_LOWER}.dart';
import '../repositories/${FEATURE_NAME_LOWER}_repository.dart';

/// 获取${FEATURE_NAME_PASCAL}列表用例
class Get${FEATURE_NAME_PASCAL}sUseCase implements UseCase<List<$FEATURE_NAME_PASCAL>, NoParams> {
  final ${FEATURE_NAME_PASCAL}Repository repository;

  Get${FEATURE_NAME_PASCAL}sUseCase(this.repository);

  @override
  Future<Either<Failure, List<$FEATURE_NAME_PASCAL>>> call(NoParams params) async {
    return await repository.get${FEATURE_NAME_PASCAL}s();
  }
}
EOF

# Data - Model
cat > $BASE_DIR/data/models/${FEATURE_NAME_LOWER}_model.dart << EOF
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/${FEATURE_NAME_LOWER}.dart';

part '${FEATURE_NAME_LOWER}_model.freezed.dart';
part '${FEATURE_NAME_LOWER}_model.g.dart';

/// $FEATURE_NAME_PASCAL 数据模型
@freezed
class ${FEATURE_NAME_PASCAL}Model with _\$${FEATURE_NAME_PASCAL}Model {
  const factory ${FEATURE_NAME_PASCAL}Model({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _${FEATURE_NAME_PASCAL}Model;

  factory ${FEATURE_NAME_PASCAL}Model.fromJson(Map<String, dynamic> json) =>
      _\$${FEATURE_NAME_PASCAL}ModelFromJson(json);
      
  const ${FEATURE_NAME_PASCAL}Model._();
  
  /// 转换为实体
  $FEATURE_NAME_PASCAL toEntity() => $FEATURE_NAME_PASCAL(
    id: id,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
  
  /// 从实体创建
  factory ${FEATURE_NAME_PASCAL}Model.fromEntity($FEATURE_NAME_PASCAL entity) => ${FEATURE_NAME_PASCAL}Model(
    id: entity.id,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
  );
}
EOF

# Data - Remote DataSource
cat > $BASE_DIR/data/datasources/${FEATURE_NAME_LOWER}_remote_datasource.dart << EOF
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/${FEATURE_NAME_LOWER}_model.dart';

part '${FEATURE_NAME_LOWER}_remote_datasource.g.dart';

@RestApi()
abstract class ${FEATURE_NAME_PASCAL}RemoteDataSource {
  factory ${FEATURE_NAME_PASCAL}RemoteDataSource(Dio dio) = _${FEATURE_NAME_PASCAL}RemoteDataSource;

  @GET('/${FEATURE_NAME_LOWER}s')
  Future<List<${FEATURE_NAME_PASCAL}Model>> get${FEATURE_NAME_PASCAL}s();

  @GET('/${FEATURE_NAME_LOWER}s/{id}')
  Future<${FEATURE_NAME_PASCAL}Model> get${FEATURE_NAME_PASCAL}(@Path('id') String id);

  @POST('/${FEATURE_NAME_LOWER}s')
  Future<${FEATURE_NAME_PASCAL}Model> create${FEATURE_NAME_PASCAL}(@Body() ${FEATURE_NAME_PASCAL}Model ${FEATURE_NAME_LOWER});

  @PUT('/${FEATURE_NAME_LOWER}s/{id}')
  Future<${FEATURE_NAME_PASCAL}Model> update${FEATURE_NAME_PASCAL}(
    @Path('id') String id,
    @Body() ${FEATURE_NAME_PASCAL}Model ${FEATURE_NAME_LOWER},
  );

  @DELETE('/${FEATURE_NAME_LOWER}s/{id}')
  Future<void> delete${FEATURE_NAME_PASCAL}(@Path('id') String id);
}
EOF

# Data - Repository Implementation
cat > $BASE_DIR/data/repositories/${FEATURE_NAME_LOWER}_repository_impl.dart << EOF
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/${FEATURE_NAME_LOWER}.dart';
import '../../domain/repositories/${FEATURE_NAME_LOWER}_repository.dart';
import '../datasources/${FEATURE_NAME_LOWER}_remote_datasource.dart';
import '../models/${FEATURE_NAME_LOWER}_model.dart';

/// ${FEATURE_NAME_PASCAL}Repository 实现
class ${FEATURE_NAME_PASCAL}RepositoryImpl implements ${FEATURE_NAME_PASCAL}Repository {
  final ${FEATURE_NAME_PASCAL}RemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ${FEATURE_NAME_PASCAL}RepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<$FEATURE_NAME_PASCAL>>> get${FEATURE_NAME_PASCAL}s() async {
    if (await networkInfo.isConnected) {
      try {
        final models = await remoteDataSource.get${FEATURE_NAME_PASCAL}s();
        final entities = models.map((model) => model.toEntity()).toList();
        return Right(entities);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, $FEATURE_NAME_PASCAL>> get${FEATURE_NAME_PASCAL}(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final model = await remoteDataSource.get${FEATURE_NAME_PASCAL}(id);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, $FEATURE_NAME_PASCAL>> create${FEATURE_NAME_PASCAL}($FEATURE_NAME_PASCAL ${FEATURE_NAME_LOWER}) async {
    if (await networkInfo.isConnected) {
      try {
        final model = ${FEATURE_NAME_PASCAL}Model.fromEntity(${FEATURE_NAME_LOWER});
        final result = await remoteDataSource.create${FEATURE_NAME_PASCAL}(model);
        return Right(result.toEntity());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, $FEATURE_NAME_PASCAL>> update${FEATURE_NAME_PASCAL}($FEATURE_NAME_PASCAL ${FEATURE_NAME_LOWER}) async {
    if (await networkInfo.isConnected) {
      try {
        final model = ${FEATURE_NAME_PASCAL}Model.fromEntity(${FEATURE_NAME_LOWER});
        final result = await remoteDataSource.update${FEATURE_NAME_PASCAL}(${FEATURE_NAME_LOWER}.id, model);
        return Right(result.toEntity());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> delete${FEATURE_NAME_PASCAL}(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.delete${FEATURE_NAME_PASCAL}(id);
        return Right(unit);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
EOF

# Presentation - Provider
cat > $BASE_DIR/presentation/providers/${FEATURE_NAME_LOWER}_provider.dart << EOF
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/${FEATURE_NAME_LOWER}.dart';
import '../../domain/usecases/get_${FEATURE_NAME_LOWER}s_usecase.dart';
import '../../../../core/base/use_case.dart';

part '${FEATURE_NAME_LOWER}_provider.freezed.dart';

/// ${FEATURE_NAME_PASCAL}状态
@freezed
class ${FEATURE_NAME_PASCAL}State with _\$${FEATURE_NAME_PASCAL}State {
  const factory ${FEATURE_NAME_PASCAL}State.initial() = _Initial;
  const factory ${FEATURE_NAME_PASCAL}State.loading() = _Loading;
  const factory ${FEATURE_NAME_PASCAL}State.loaded(List<$FEATURE_NAME_PASCAL> ${FEATURE_NAME_LOWER}s) = _Loaded;
  const factory ${FEATURE_NAME_PASCAL}State.error(String message) = _Error;
}

/// ${FEATURE_NAME_PASCAL}Provider
final ${FEATURE_NAME_LOWER}Provider = StateNotifierProvider<${FEATURE_NAME_PASCAL}Notifier, ${FEATURE_NAME_PASCAL}State>((ref) {
  final useCase = ref.watch(get${FEATURE_NAME_PASCAL}sUseCaseProvider);
  return ${FEATURE_NAME_PASCAL}Notifier(useCase);
});

/// ${FEATURE_NAME_PASCAL}Notifier
class ${FEATURE_NAME_PASCAL}Notifier extends StateNotifier<${FEATURE_NAME_PASCAL}State> {
  final Get${FEATURE_NAME_PASCAL}sUseCase _get${FEATURE_NAME_PASCAL}sUseCase;

  ${FEATURE_NAME_PASCAL}Notifier(this._get${FEATURE_NAME_PASCAL}sUseCase) : super(const ${FEATURE_NAME_PASCAL}State.initial());

  Future<void> load${FEATURE_NAME_PASCAL}s() async {
    state = const ${FEATURE_NAME_PASCAL}State.loading();
    
    final result = await _get${FEATURE_NAME_PASCAL}sUseCase(NoParams());
    
    state = result.fold(
      (failure) => ${FEATURE_NAME_PASCAL}State.error(failure.message),
      (${FEATURE_NAME_LOWER}s) => ${FEATURE_NAME_PASCAL}State.loaded(${FEATURE_NAME_LOWER}s),
    );
  }
}

/// UseCase Provider
final get${FEATURE_NAME_PASCAL}sUseCaseProvider = Provider((ref) {
  final repository = ref.watch(${FEATURE_NAME_LOWER}RepositoryProvider);
  return Get${FEATURE_NAME_PASCAL}sUseCase(repository);
});

/// Repository Provider (需要在DI中配置)
final ${FEATURE_NAME_LOWER}RepositoryProvider = Provider<${FEATURE_NAME_PASCAL}Repository>((ref) {
  throw UnimplementedError('请在DI配置中实现此Provider');
});
EOF

# Presentation - Page
cat > $BASE_DIR/presentation/pages/${FEATURE_NAME_LOWER}_list_page.dart << EOF
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import '../providers/${FEATURE_NAME_LOWER}_provider.dart';

/// ${FEATURE_NAME_PASCAL}列表页面
@RoutePage()
class ${FEATURE_NAME_PASCAL}ListPage extends ConsumerStatefulWidget {
  const ${FEATURE_NAME_PASCAL}ListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<${FEATURE_NAME_PASCAL}ListPage> createState() => _${FEATURE_NAME_PASCAL}ListPageState();
}

class _${FEATURE_NAME_PASCAL}ListPageState extends ConsumerState<${FEATURE_NAME_PASCAL}ListPage> {
  @override
  void initState() {
    super.initState();
    // 加载数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(${FEATURE_NAME_LOWER}Provider.notifier).load${FEATURE_NAME_PASCAL}s();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(${FEATURE_NAME_LOWER}Provider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('${FEATURE_NAME_PASCAL}列表'),
      ),
      body: state.when(
        initial: () => const Center(child: Text('准备加载...')),
        loading: () => const Center(child: CircularProgressIndicator()),
        loaded: (${FEATURE_NAME_LOWER}s) => ListView.builder(
          itemCount: ${FEATURE_NAME_LOWER}s.length,
          itemBuilder: (context, index) {
            final ${FEATURE_NAME_LOWER} = ${FEATURE_NAME_LOWER}s[index];
            return ListTile(
              title: Text(${FEATURE_NAME_LOWER}.id),
              subtitle: Text('创建于: \${${FEATURE_NAME_LOWER}.createdAt}'),
            );
          },
        ),
        error: (message) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('错误: \$message'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(${FEATURE_NAME_LOWER}Provider.notifier).load${FEATURE_NAME_PASCAL}s();
                },
                child: const Text('重试'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
EOF

# 创建README
cat > $BASE_DIR/README.md << EOF
# $FEATURE_NAME_PASCAL 功能模块

## 模块说明
此模块负责$FEATURE_NAME_PASCAL相关的所有功能。

## 目录结构
- \`data/\`: 数据层实现
  - \`datasources/\`: 数据源（远程API、本地缓存）
  - \`models/\`: 数据模型（DTO）
  - \`repositories/\`: 仓储实现
- \`domain/\`: 领域层
  - \`entities/\`: 业务实体
  - \`repositories/\`: 仓储接口
  - \`usecases/\`: 用例
  - \`value_objects/\`: 值对象
- \`presentation/\`: 表现层
  - \`pages/\`: 页面
  - \`widgets/\`: 组件
  - \`providers/\`: 状态管理

## 使用说明
1. 在DI中配置Repository Provider
2. 在路由中注册页面
3. 运行代码生成: \`flutter pub run build_runner build\`

## 负责人
@[团队成员]
EOF

echo "✅ 功能模块创建完成！"
echo ""
echo "下一步："
echo "1. 运行代码生成: flutter pub run build_runner build"
echo "2. 在路由中注册页面"
echo "3. 在DI中配置依赖"
echo "4. 实现具体业务逻辑"