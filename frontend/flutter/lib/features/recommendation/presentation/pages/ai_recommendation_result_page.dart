import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/recommendation_item.dart';

/// AI推荐结果页面
/// 
/// 显示AI生成的推荐结果列表
class AiRecommendationResultPage extends ConsumerStatefulWidget {
  /// 推荐结果列表
  final List<RecommendationItem> recommendations;
  
  const AiRecommendationResultPage({
    Key? key,
    required this.recommendations,
  }) : super(key: key);

  @override
  ConsumerState<AiRecommendationResultPage> createState() =>
      _AiRecommendationResultPageState();
}

class _AiRecommendationResultPageState 
    extends ConsumerState<AiRecommendationResultPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('推荐结果'),
        centerTitle: true,
      ),
      body: widget.recommendations.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    '暂无推荐结果',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.recommendations.length,
              itemBuilder: (context, index) {
                final recommendation = widget.recommendations[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: recommendation.imageUrl != null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(recommendation.imageUrl!),
                          )
                        : const CircleAvatar(
                            child: Icon(Icons.restaurant),
                          ),
                    title: Text(
                      recommendation.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(recommendation.description),
                        const SizedBox(height: 4),
                        Text(
                          '评分: ${recommendation.formattedScore} | ${recommendation.formattedPrice}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      recommendation.isHighRated 
                          ? Icons.star 
                          : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onTap: () {
                      // TODO: 导航到详情页面
                    },
                  ),
                );
              },
            ),
    );
  }
}