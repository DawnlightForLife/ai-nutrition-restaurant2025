import 'package:flutter/material.dart';

/// 评分星级组件
class RatingStarWidget extends StatelessWidget {
  final double rating;
  final int maxRating;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool allowHalf;
  final ValueChanged<double>? onRatingChanged;
  final bool showNumber;
  
  const RatingStarWidget({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.size = 24,
    this.activeColor,
    this.inactiveColor,
    this.allowHalf = true,
    this.onRatingChanged,
    this.showNumber = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final starColor = activeColor ?? theme.colorScheme.primary;
    final emptyColor = inactiveColor ?? theme.disabledColor.withOpacity(0.3);
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(maxRating, (index) {
          final starValue = index + 1;
          final filled = rating >= starValue;
          final halfFilled = allowHalf && 
              rating > index && 
              rating < starValue &&
              rating - index >= 0.5;
          
          return GestureDetector(
            onTap: onRatingChanged != null
                ? () {
                    if (allowHalf) {
                      // 如果点击的是当前评分的星星，切换半星/满星
                      if (rating == starValue) {
                        onRatingChanged!(starValue - 0.5);
                      } else if (rating == starValue - 0.5) {
                        onRatingChanged!(starValue.toDouble());
                      } else {
                        onRatingChanged!(starValue.toDouble());
                      }
                    } else {
                      onRatingChanged!(starValue.toDouble());
                    }
                  }
                : null,
            child: Icon(
              halfFilled ? Icons.star_half : Icons.star,
              size: size,
              color: filled || halfFilled ? starColor : emptyColor,
            ),
          );
        }),
        if (showNumber) ...[
          const SizedBox(width: 8),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: size * 0.7,
              fontWeight: FontWeight.bold,
              color: starColor,
            ),
          ),
        ],
      ],
    );
  }
}

/// 可交互的评分组件
class InteractiveRatingWidget extends StatefulWidget {
  final double initialRating;
  final int maxRating;
  final double size;
  final ValueChanged<double> onRatingChanged;
  final bool allowHalf;
  
  const InteractiveRatingWidget({
    super.key,
    this.initialRating = 0,
    this.maxRating = 5,
    this.size = 32,
    required this.onRatingChanged,
    this.allowHalf = true,
  });

  @override
  State<InteractiveRatingWidget> createState() => _InteractiveRatingWidgetState();
}

class _InteractiveRatingWidgetState extends State<InteractiveRatingWidget> {
  late double _rating;
  
  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RatingStarWidget(
          rating: _rating,
          maxRating: widget.maxRating,
          size: widget.size,
          allowHalf: widget.allowHalf,
          onRatingChanged: (rating) {
            setState(() {
              _rating = rating;
            });
            widget.onRatingChanged(rating);
          },
        ),
        const SizedBox(height: 8),
        Text(
          _getRatingText(_rating),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
  
  String _getRatingText(double rating) {
    if (rating <= 1) return '非常差';
    if (rating <= 2) return '较差';
    if (rating <= 3) return '一般';
    if (rating <= 4) return '较好';
    return '非常好';
  }
}