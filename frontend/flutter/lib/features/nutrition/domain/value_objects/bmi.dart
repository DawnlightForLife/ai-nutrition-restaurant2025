import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

/// BMI值对象
class BMI {
  final double value;

  const BMI._(this.value);

  static Either<Failure, BMI> create(double height, double weight) {
    if (height <= 0 || weight <= 0) {
      return Left(ValidationFailure(
        message: '身高和体重必须大于0',
      ));
    }

    final heightInMeters = height / 100;
    final bmiValue = weight / (heightInMeters * heightInMeters);

    if (bmiValue < 10 || bmiValue > 50) {
      return Left(ValidationFailure(
        message: 'BMI值异常，请检查输入',
      ));
    }

    return Right(BMI._(bmiValue));
  }

  String get category {
    if (value < 18.5) return '偏瘦';
    if (value < 24) return '正常';
    if (value < 28) return '偏胖';
    return '肥胖';
  }

  String get description {
    return '${value.toStringAsFixed(1)} ($category)';
  }
}