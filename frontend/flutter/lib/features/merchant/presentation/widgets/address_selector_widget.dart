import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 三级地址选择器组件
class AddressSelectorWidget extends StatefulWidget {
  final Function(String province, String city, String district) onAddressSelected;
  final String? initialProvince;
  final String? initialCity;
  final String? initialDistrict;

  const AddressSelectorWidget({
    super.key,
    required this.onAddressSelected,
    this.initialProvince,
    this.initialCity,
    this.initialDistrict,
  });

  @override
  State<AddressSelectorWidget> createState() => _AddressSelectorWidgetState();
}

class _AddressSelectorWidgetState extends State<AddressSelectorWidget> {
  String? _selectedProvince;
  String? _selectedCity;
  String? _selectedDistrict;
  
  @override
  void initState() {
    super.initState();
    _initializeAddress();
  }

  /// 初始化地址数据，确保数据的一致性
  void _initializeAddress() {
    // 验证并设置省份
    if (widget.initialProvince != null && 
        _provinces.contains(widget.initialProvince)) {
      _selectedProvince = widget.initialProvince;
    }

    // 验证并设置城市
    if (_selectedProvince != null && 
        widget.initialCity != null &&
        _cities.contains(widget.initialCity)) {
      _selectedCity = widget.initialCity;
    } else {
      _selectedCity = null; // 重置城市选择
    }

    // 验证并设置区县
    if (_selectedCity != null && 
        widget.initialDistrict != null &&
        _districts.contains(widget.initialDistrict)) {
      _selectedDistrict = widget.initialDistrict;
    } else {
      _selectedDistrict = null; // 重置区县选择
    }

    // 如果地址数据被重置，通知父组件
    if (_selectedProvince != widget.initialProvince ||
        _selectedCity != widget.initialCity ||
        _selectedDistrict != widget.initialDistrict) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _notifyAddressChange();
      });
    }
  }

  // 简化的地址数据（实际项目中应该从API获取）
  final Map<String, Map<String, List<String>>> _addressData = {
    '北京市': {
      '北京市': ['东城区', '西城区', '朝阳区', '丰台区', '石景山区', '海淀区', '门头沟区', '房山区', '通州区', '顺义区', '昌平区', '大兴区', '怀柔区', '平谷区', '密云区', '延庆区']
    },
    '上海市': {
      '上海市': ['黄浦区', '徐汇区', '长宁区', '静安区', '普陀区', '虹口区', '杨浦区', '闵行区', '宝山区', '嘉定区', '浦东新区', '金山区', '松江区', '青浦区', '奉贤区', '崇明区']
    },
    '广东省': {
      '广州市': ['荔湾区', '越秀区', '海珠区', '天河区', '白云区', '黄埔区', '番禺区', '花都区', '南沙区', '从化区', '增城区'],
      '深圳市': ['罗湖区', '福田区', '南山区', '宝安区', '龙岗区', '盐田区', '龙华区', '坪山区', '光明区', '大鹏新区'],
      '珠海市': ['香洲区', '斗门区', '金湾区'],
      '汕头市': ['龙湖区', '金平区', '濠江区', '潮阳区', '潮南区', '澄海区', '南澳县'],
      '佛山市': ['禅城区', '南海区', '顺德区', '三水区', '高明区'],
      '韶关市': ['武江区', '浈江区', '曲江区', '始兴县', '仁化县', '翁源县', '乳源瑶族自治县', '新丰县', '乐昌市', '南雄市'],
    },
    '江苏省': {
      '南京市': ['玄武区', '秦淮区', '建邺区', '鼓楼区', '浦口区', '栖霞区', '雨花台区', '江宁区', '六合区', '溧水区', '高淳区'],
      '苏州市': ['虎丘区', '吴中区', '相城区', '姑苏区', '吴江区', '常熟市', '张家港市', '昆山市', '太仓市'],
      '无锡市': ['锡山区', '惠山区', '滨湖区', '梁溪区', '新吴区', '江阴市', '宜兴市'],
    },
    '浙江省': {
      '杭州市': ['上城区', '拱墅区', '西湖区', '滨江区', '萧山区', '余杭区', '临平区', '钱塘区', '富阳区', '临安区', '桐庐县', '淳安县', '建德市'],
      '宁波市': ['海曙区', '江北区', '北仑区', '镇海区', '鄞州区', '奉化区', '象山县', '宁海县', '余姚市', '慈溪市'],
      '温州市': ['鹿城区', '龙湾区', '瓯海区', '洞头区', '永嘉县', '平阳县', '苍南县', '文成县', '泰顺县', '瑞安市', '乐清市'],
    }
  };

  List<String> get _provinces => _addressData.keys.toList();

  List<String> get _cities {
    if (_selectedProvince == null) return [];
    return _addressData[_selectedProvince]?.keys.toList() ?? [];
  }

  List<String> get _districts {
    if (_selectedProvince == null || _selectedCity == null) return [];
    return _addressData[_selectedProvince]?[_selectedCity] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '所在地区 *',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: _buildDropdown(
                hint: '选择省份',
                value: _selectedProvince,
                items: _provinces,
                onChanged: (value) {
                  setState(() {
                    _selectedProvince = value;
                    _selectedCity = null;
                    _selectedDistrict = null;
                  });
                  _notifyAddressChange();
                },
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _buildDropdown(
                hint: '选择城市',
                value: _selectedCity,
                items: _cities,
                onChanged: _selectedProvince == null ? null : (value) {
                  setState(() {
                    _selectedCity = value;
                    _selectedDistrict = null;
                  });
                  _notifyAddressChange();
                },
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _buildDropdown(
                hint: '选择区县',
                value: _selectedDistrict,
                items: _districts,
                onChanged: _selectedCity == null ? null : (value) {
                  setState(() {
                    _selectedDistrict = value;
                  });
                  _notifyAddressChange();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?>? onChanged,
  }) {
    // 验证value是否在items中，如果不在则设置为null
    final validValue = (value != null && items.contains(value)) ? value : null;
    final bool isEnabled = onChanged != null && items.isNotEmpty;
    
    return DropdownButtonFormField<String>(
      hint: Text(
        hint,
        style: TextStyle(
          fontSize: 14.sp,
          color: isEnabled ? null : Colors.grey[400],
        ),
      ),
      value: validValue,
      items: items.isEmpty 
        ? null 
        : items.map((item) => DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: TextStyle(fontSize: 14.sp),
              overflow: TextOverflow.ellipsis,
            ),
          )).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        enabled: isEnabled,
        suffixIcon: !isEnabled && items.isEmpty
          ? Icon(Icons.block, color: Colors.grey[400], size: 16)
          : null,
        helperText: _getHelperText(hint, items.length),
        helperStyle: TextStyle(fontSize: 11.sp, color: Colors.grey[600]),
      ),
      isExpanded: true,
      validator: (value) {
        if (!isEnabled) return null; // 禁用状态不验证
        
        if (hint.contains('省份') && value == null) {
          return '请选择省份';
        }
        if (hint.contains('城市') && value == null) {
          return '请选择城市';
        }
        if (hint.contains('区县') && value == null) {
          return '请选择区县';
        }
        return null;
      },
    );
  }

  /// 获取下拉框的帮助文本
  String? _getHelperText(String hint, int itemCount) {
    if (hint.contains('省份')) {
      return itemCount > 0 ? '支持${itemCount}个省份' : null;
    } else if (hint.contains('城市')) {
      if (_selectedProvince == null) {
        return '请先选择省份';
      }
      return itemCount > 0 ? '${_selectedProvince}有${itemCount}个城市' : '该省份暂无城市数据';
    } else if (hint.contains('区县')) {
      if (_selectedCity == null) {
        return '请先选择城市';
      }
      return itemCount > 0 ? '${_selectedCity}有${itemCount}个区县' : '该城市暂无区县数据';
    }
    return null;
  }

  void _notifyAddressChange() {
    widget.onAddressSelected(
      _selectedProvince ?? '',
      _selectedCity ?? '',
      _selectedDistrict ?? '',
    );
  }
}