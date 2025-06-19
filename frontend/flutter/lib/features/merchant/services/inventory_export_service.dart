import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../domain/entities/merchant_inventory.dart';

class InventoryExportService {
  static final _dateFormat = DateFormat('yyyy-MM-dd HH:mm');
  
  /// 导出食材库存数据为CSV文件
  static Future<void> exportIngredientsToCsv({
    required List<IngredientInventoryItem> ingredients,
    String? fileName,
  }) async {
    try {
      // 准备CSV数据
      final List<List<dynamic>> csvData = [
        // 表头
        [
          '食材名称',
          '类别',
          '当前库存',
          '可用库存',
          '已预留',
          '单位',
          '单价(元)',
          '总价值(元)',
          '库存状态',
          '预警阈值',
          '最大容量',
          '保质期(天)',
          '最后入库时间',
          '供应商',
          '状态',
        ],
      ];
      
      // 添加数据行
      for (final ingredient in ingredients) {
        csvData.add([
          ingredient.name,
          ingredient.category,
          ingredient.currentStock,
          ingredient.availableStock,
          ingredient.reservedStock,
          ingredient.unit,
          ingredient.costPerUnit,
          (ingredient.currentStock * ingredient.costPerUnit).toStringAsFixed(2),
          _getStockStatus(ingredient),
          ingredient.alertThreshold,
          ingredient.maxCapacity,
          ingredient.shelfLife,
          ingredient.lastRestockDate != null 
              ? _dateFormat.format(ingredient.lastRestockDate!)
              : '-',
          ingredient.supplier ?? '-',
          ingredient.isActive ? '启用' : '停用',
        ]);
      }
      
      // 转换为CSV字符串
      final csvString = const ListToCsvConverter().convert(csvData);
      
      // 获取临时目录
      final directory = await getTemporaryDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final name = fileName ?? 'inventory_export_$timestamp.csv';
      final file = File('${directory.path}/$name');
      
      // 写入文件
      await file.writeAsString(csvString);
      
      // 分享文件
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: '食材库存导出',
        text: '食材库存数据导出 - ${DateTime.now().toString().split('.')[0]}',
      );
      
      // 清理临时文件
      await file.delete();
      
    } catch (e) {
      throw Exception('导出失败: $e');
    }
  }
  
  /// 导出库存变动记录
  static Future<void> exportTransactionsToCsv({
    required List<InventoryTransaction> transactions,
    String? fileName,
  }) async {
    try {
      // 准备CSV数据
      final List<List<dynamic>> csvData = [
        // 表头
        [
          '时间',
          '食材名称',
          '操作类型',
          '数量',
          '单位',
          '变动前库存',
          '变动后库存',
          '单价(元)',
          '总金额(元)',
          '原因',
          '操作人',
          '批次号',
        ],
      ];
      
      // 添加数据行
      for (final transaction in transactions) {
        csvData.add([
          _dateFormat.format(transaction.timestamp),
          transaction.ingredientName ?? transaction.ingredientId,
          _getTransactionTypeText(transaction.type),
          transaction.quantity,
          transaction.unit,
          transaction.stockBefore,
          transaction.stockAfter,
          transaction.costPerUnit ?? '-',
          transaction.totalCost?.toStringAsFixed(2) ?? '-',
          transaction.reason ?? '-',
          transaction.operatorName ?? transaction.operatorId,
          transaction.batchNumber ?? '-',
        ]);
      }
      
      // 转换为CSV字符串
      final csvString = const ListToCsvConverter().convert(csvData);
      
      // 获取临时目录
      final directory = await getTemporaryDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final name = fileName ?? 'inventory_transactions_$timestamp.csv';
      final file = File('${directory.path}/$name');
      
      // 写入文件
      await file.writeAsString(csvString);
      
      // 分享文件
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: '库存变动记录导出',
        text: '库存变动记录数据导出 - ${DateTime.now().toString().split('.')[0]}',
      );
      
      // 清理临时文件
      await file.delete();
      
    } catch (e) {
      throw Exception('导出失败: $e');
    }
  }
  
  /// 生成库存报表
  static Future<void> generateInventoryReport({
    required List<IngredientInventoryItem> ingredients,
    required String merchantName,
    String? fileName,
  }) async {
    try {
      // 计算统计数据
      final totalValue = ingredients.fold<double>(
        0, (sum, item) => sum + (item.currentStock * item.costPerUnit)
      );
      final lowStockCount = ingredients.where((item) => 
        item.currentStock <= item.alertThreshold
      ).length;
      final inactiveCount = ingredients.where((item) => !item.isActive).length;
      
      // 准备报表数据
      final List<List<dynamic>> reportData = [
        ['食材库存报表'],
        ['商家名称:', merchantName],
        ['生成时间:', _dateFormat.format(DateTime.now())],
        [''],
        ['统计汇总'],
        ['总食材种类:', ingredients.length],
        ['库存总价值:', '¥${totalValue.toStringAsFixed(2)}'],
        ['低库存食材:', '$lowStockCount 种'],
        ['停用食材:', '$inactiveCount 种'],
        [''],
        ['库存明细'],
      ];
      
      // 添加表头
      reportData.add([
        '食材名称',
        '类别',
        '当前库存',
        '单位',
        '单价',
        '总价值',
        '库存状态',
      ]);
      
      // 添加明细数据
      for (final ingredient in ingredients) {
        reportData.add([
          ingredient.name,
          ingredient.category,
          ingredient.currentStock,
          ingredient.unit,
          '¥${ingredient.costPerUnit}',
          '¥${(ingredient.currentStock * ingredient.costPerUnit).toStringAsFixed(2)}',
          _getStockStatus(ingredient),
        ]);
      }
      
      // 转换为CSV字符串
      final csvString = const ListToCsvConverter().convert(reportData);
      
      // 获取临时目录
      final directory = await getTemporaryDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final name = fileName ?? 'inventory_report_$timestamp.csv';
      final file = File('${directory.path}/$name');
      
      // 写入文件
      await file.writeAsString(csvString);
      
      // 分享文件
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: '食材库存报表',
        text: '食材库存报表 - $merchantName - ${DateTime.now().toString().split('.')[0]}',
      );
      
      // 清理临时文件
      await file.delete();
      
    } catch (e) {
      throw Exception('生成报表失败: $e');
    }
  }
  
  static String _getStockStatus(IngredientInventoryItem item) {
    if (item.currentStock <= 0) return '缺货';
    if (item.currentStock <= item.alertThreshold) return '库存不足';
    if (item.currentStock >= item.maxCapacity * 0.9) return '库存充足';
    return '正常';
  }
  
  static String _getTransactionTypeText(String type) {
    switch (type) {
      case 'restock':
        return '入库';
      case 'consume':
        return '消耗';
      case 'waste':
        return '损耗';
      case 'adjustment':
        return '调整';
      case 'transfer':
        return '调拨';
      default:
        return type;
    }
  }
}