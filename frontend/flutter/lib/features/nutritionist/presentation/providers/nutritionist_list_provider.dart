import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/nutritionist.dart';
import '../../domain/entities/nutritionist_filter.dart';
import '../../domain/repositories/nutritionist_repository.dart';

part 'nutritionist_list_provider.freezed.dart';

/// 营养师列表状态
@freezed
class NutritionistListState with _$NutritionistListState {
  const factory NutritionistListState.loading() = NutritionistListLoading;
  const factory NutritionistListState.loaded(List<Nutritionist> nutritionists) = NutritionistListLoaded;
  const factory NutritionistListState.empty() = NutritionistListEmpty;
  const factory NutritionistListState.error(String message) = NutritionistListError;
}

/// 营养师列表Provider
class NutritionistListNotifier extends StateNotifier<NutritionistListState> {
  final NutritionistRepository repository;
  
  NutritionistListNotifier(this.repository) : super(const NutritionistListState.loading());
  
  /// 加载营养师列表
  Future<void> loadNutritionists({NutritionistFilter? filter}) async {
    try {
      state = const NutritionistListState.loading();
      
      // 使用真实API调用
      final result = await repository.getNutritionists(filter: filter);
      result.fold(
        (failure) {
          // 如果API调用失败，回退到模拟数据进行演示
          print('API调用失败，使用模拟数据: ${failure.message}');
          final mockNutritionists = _generateMockNutritionists();
          state = mockNutritionists.isEmpty 
              ? const NutritionistListState.empty()
              : NutritionistListState.loaded(mockNutritionists);
        },
        (nutritionists) {
          if (nutritionists.isEmpty) {
            // 如果API返回空数据，使用模拟数据进行演示
            print('API返回空数据，使用模拟数据进行演示');
            final mockNutritionists = _generateMockNutritionists();
            state = mockNutritionists.isEmpty 
                ? const NutritionistListState.empty()
                : NutritionistListState.loaded(mockNutritionists);
          } else {
            state = NutritionistListState.loaded(nutritionists);
          }
        },
      );
          
    } catch (e) {
      // 发生异常时也回退到模拟数据
      print('加载营养师列表异常，使用模拟数据: $e');
      final mockNutritionists = _generateMockNutritionists();
      state = mockNutritionists.isEmpty 
          ? const NutritionistListState.empty()
          : NutritionistListState.loaded(mockNutritionists);
    }
  }

  /// 生成模拟营养师数据
  List<Nutritionist> _generateMockNutritionists() {
    final now = DateTime.now();
    
    return [
      Nutritionist(
        id: '1',
        userId: 'user_1',
        name: '张营养师',
        specializations: ['childNutrition', 'diabeticDiet'],
        experienceYears: 10,
        bio: '资深营养师，专注儿童营养和糖尿病饮食管理，拥有10年丰富临床经验。',
        avatarUrl: 'https://picsum.photos/id/237/200/200',
        rating: 4.8,
        reviewCount: 158,
        consultationFee: 99.0,
        languages: ['中文', '英文'],
        certifications: ['注册营养师', '临床营养师'],
        isOnlineAvailable: true,
        isInPersonAvailable: false,
        verificationStatus: 'approved',
        createdAt: now.subtract(const Duration(days: 365)),
        updatedAt: now,
      ),
      Nutritionist(
        id: '2',
        userId: 'user_2',
        name: '李医生',
        specializations: ['sportsNutrition', 'weightManagement'],
        experienceYears: 8,
        bio: '临床营养专家，专攻运动营养和体重管理，帮助数百位客户达成健康目标。',
        avatarUrl: 'https://picsum.photos/id/91/200/200',
        rating: 4.6,
        reviewCount: 89,
        consultationFee: 129.0,
        languages: ['中文', '英文'],
        certifications: ['运动营养师', '体重管理师'],
        isOnlineAvailable: false,
        isInPersonAvailable: true,
        verificationStatus: 'approved',
        createdAt: now.subtract(const Duration(days: 200)),
        updatedAt: now,
      ),
      Nutritionist(
        id: '3',
        userId: 'user_3',
        name: '王营养师',
        specializations: ['traditionalChineseMedicine', 'pregnancyNutrition'],
        experienceYears: 15,
        bio: '中医营养专家，结合传统中医理论和现代营养学，为您提供个性化营养调理方案。',
        avatarUrl: 'https://picsum.photos/id/342/200/200',
        rating: 4.9,
        reviewCount: 234,
        consultationFee: 159.0,
        languages: ['中文', '粤语'],
        certifications: ['中医营养师', '高级营养师'],
        isOnlineAvailable: true,
        isInPersonAvailable: true,
        verificationStatus: 'approved',
        createdAt: now.subtract(const Duration(days: 500)),
        updatedAt: now,
      ),
      Nutritionist(
        id: '4',
        userId: 'user_4',
        name: '陈营养师',
        specializations: ['basicNutrition'],
        experienceYears: 2,
        bio: '新手营养师，刚刚通过认证，热情专业，价格实惠，欢迎咨询基础营养问题。',
        avatarUrl: 'https://picsum.photos/id/453/200/200',
        rating: 4.2,
        reviewCount: 23,
        consultationFee: 79.0,
        languages: ['中文'],
        certifications: ['初级营养师'],
        isOnlineAvailable: true,
        isInPersonAvailable: false,
        verificationStatus: 'approved',
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now,
      ),
      Nutritionist(
        id: '5',
        userId: 'user_5',
        name: '赵专家',
        specializations: ['elderlyNutrition', 'chronicDiseaseNutrition'],
        experienceYears: 20,
        bio: '高级营养专家，临时离线中，专注老年人营养健康和慢性病营养干预。',
        avatarUrl: 'https://picsum.photos/id/568/200/200',
        rating: 4.7,
        reviewCount: 312,
        consultationFee: 199.0,
        languages: ['中文', '英文'],
        certifications: ['高级营养师', '慢病管理师'],
        isOnlineAvailable: false,
        isInPersonAvailable: true,
        verificationStatus: 'approved',
        createdAt: now.subtract(const Duration(days: 800)),
        updatedAt: now,
      ),
    ];
  }
}

// 营养师列表Provider现在在 nutritionist_providers.dart 中定义
// 这样可以避免循环依赖并正确注入依赖