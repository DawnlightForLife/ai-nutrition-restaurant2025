import 'package:flutter/material.dart';

/// 地址选择器组件
/// 支持省市区三级联动选择和详细地址输入
class AddressSelector extends StatefulWidget {
  final Map<String, dynamic> initialAddress;
  final void Function(Map<String, dynamic> address) onAddressChanged;

  const AddressSelector({
    Key? key,
    required this.initialAddress,
    required this.onAddressChanged,
  }) : super(key: key);

  @override
  State<AddressSelector> createState() => _AddressSelectorState();
}

class _AddressSelectorState extends State<AddressSelector> {
  late TextEditingController _detailedController;
  
  String? _selectedProvince;
  String? _selectedCity;
  String? _selectedDistrict;

  // 简化的省市区数据（实际项目中应该从服务器获取）
  static const Map<String, Map<String, List<String>>> _addressData = {
    '北京市': {
      '北京市': [
        '东城区', '西城区', '朝阳区', '丰台区', '石景山区', 
        '海淀区', '门头沟区', '房山区', '通州区', '顺义区',
        '昌平区', '大兴区', '怀柔区', '平谷区', '密云区', '延庆区'
      ],
    },
    '上海市': {
      '上海市': [
        '黄浦区', '徐汇区', '长宁区', '静安区', '普陀区', 
        '虹口区', '杨浦区', '闵行区', '宝山区', '嘉定区',
        '浦东新区', '金山区', '松江区', '青浦区', '奉贤区', '崇明区'
      ],
    },
    '广东省': {
      '广州市': [
        '荔湾区', '越秀区', '海珠区', '天河区', '白云区',
        '黄埔区', '番禺区', '花都区', '南沙区', '从化区', '增城区'
      ],
      '深圳市': [
        '罗湖区', '福田区', '南山区', '宝安区', '龙岗区',
        '盐田区', '龙华区', '坪山区', '光明区', '大鹏新区'
      ],
      '珠海市': ['香洲区', '斗门区', '金湾区'],
      '东莞市': ['东莞市'],
      '佛山市': ['禅城区', '南海区', '顺德区', '高明区', '三水区'],
    },
    '江苏省': {
      '南京市': [
        '玄武区', '秦淮区', '建邺区', '鼓楼区', '浦口区',
        '栖霞区', '雨花台区', '江宁区', '六合区', '溧水区', '高淳区'
      ],
      '苏州市': [
        '虎丘区', '吴中区', '相城区', '姑苏区', '吴江区',
        '常熟市', '张家港市', '昆山市', '太仓市'
      ],
      '无锡市': ['锡山区', '惠山区', '滨湖区', '梁溪区', '新吴区', '江阴市', '宜兴市'],
    },
    '浙江省': {
      '杭州市': [
        '上城区', '下城区', '江干区', '拱墅区', '西湖区',
        '滨江区', '萧山区', '余杭区', '富阳区', '临安区',
        '桐庐县', '淳安县', '建德市'
      ],
      '宁波市': [
        '海曙区', '江北区', '北仑区', '镇海区', '鄞州区',
        '奉化区', '慈溪市', '余姚市', '象山县', '宁海县'
      ],
    },
  };

  @override
  void initState() {
    super.initState();
    _initializeFromInitialData();
    _detailedController = TextEditingController(
      text: widget.initialAddress['detailed'] as String? ?? '',
    );
    _detailedController.addListener(_onDetailedAddressChanged);
  }

  @override
  void dispose() {
    _detailedController.dispose();
    super.dispose();
  }

  void _initializeFromInitialData() {
    final initial = widget.initialAddress;
    final province = initial['province'] as String?;
    final city = initial['city'] as String?;
    final district = initial['district'] as String?;
    
    // 只有在值非空且存在于选项中时才设置
    _selectedProvince = (province != null && province.isNotEmpty && _addressData.containsKey(province)) 
        ? province : null;
    _selectedCity = (city != null && city.isNotEmpty && _selectedProvince != null && 
        _addressData[_selectedProvince]?.containsKey(city) == true) 
        ? city : null;
    _selectedDistrict = (district != null && district.isNotEmpty && _selectedProvince != null && 
        _selectedCity != null && _addressData[_selectedProvince]?[_selectedCity]?.contains(district) == true) 
        ? district : null;
  }

  void _onDetailedAddressChanged() {
    _notifyAddressChanged();
  }

  void _notifyAddressChanged() {
    final address = {
      'province': _selectedProvince,
      'city': _selectedCity,
      'district': _selectedDistrict,
      'detailed': _detailedController.text.trim().isEmpty ? null : _detailedController.text.trim(),
    };
    widget.onAddressChanged(address);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 省市区选择行
        Row(
          children: [
            // 省份选择
            Expanded(
              child: _buildDropdown(
                label: '省份 *',
                value: _selectedProvince,
                items: _addressData.keys.toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedProvince = value;
                    _selectedCity = null;
                    _selectedDistrict = null;
                  });
                  _notifyAddressChanged();
                },
                hint: '请选择省份',
              ),
            ),
            const SizedBox(width: 12),

            // 城市选择
            Expanded(
              child: _buildDropdown(
                label: '城市 *',
                value: _selectedCity,
                items: _selectedProvince != null
                    ? _addressData[_selectedProvince]?.keys.toList() ?? []
                    : [],
                onChanged: (value) {
                  setState(() {
                    _selectedCity = value;
                    _selectedDistrict = null;
                  });
                  _notifyAddressChanged();
                },
                hint: '请选择城市',
                enabled: _selectedProvince != null,
              ),
            ),
            const SizedBox(width: 12),

            // 区县选择
            Expanded(
              child: _buildDropdown(
                label: '区县 *',
                value: _selectedDistrict,
                items: _selectedProvince != null && _selectedCity != null
                    ? (_addressData[_selectedProvince]?[_selectedCity] ?? <String>[])
                    : <String>[],
                onChanged: (value) {
                  setState(() {
                    _selectedDistrict = value;
                  });
                  _notifyAddressChanged();
                },
                hint: '请选择区县',
                enabled: _selectedCity != null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // 详细地址输入
        TextFormField(
          controller: _detailedController,
          decoration: InputDecoration(
            labelText: '详细地址 *',
            hintText: '请输入详细地址（街道、门牌号等）',
            prefixIcon: const Icon(Icons.location_on_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: colorScheme.surface,
          ),
          maxLines: 2,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '请输入详细地址';
            }
            if (value.trim().length < 5) {
              return '详细地址至少需要5个字符';
            }
            return null;
          },
        ),

        // 地址预览
        if (_hasCompleteAddress()) ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colorScheme.secondary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: colorScheme.secondary,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getFullAddress(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    required String hint,
    bool enabled = true,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge,
        ),
        const SizedBox(height: 8),
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: enabled ? colorScheme.surface : colorScheme.surface.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: colorScheme.outline.withOpacity(0.5),
            ),
          ),
          child: DropdownButtonFormField<String>(
            value: (value != null && value.isNotEmpty && items.contains(value)) ? value : null,
            onChanged: enabled ? onChanged : null,
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: theme.textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 16,
              ),
            ),
            style: theme.textTheme.bodyMedium,
            dropdownColor: colorScheme.surface,
            icon: Icon(
              Icons.arrow_drop_down,
              color: enabled 
                  ? colorScheme.onSurface.withOpacity(0.6)
                  : colorScheme.onSurface.withOpacity(0.3),
            ),
            isExpanded: true,
          ),
        ),
      ],
    );
  }

  bool _hasCompleteAddress() {
    return _selectedProvince != null &&
           _selectedCity != null &&
           _selectedDistrict != null &&
           _detailedController.text.trim().isNotEmpty;
  }

  String _getFullAddress() {
    final parts = <String>[];
    if (_selectedProvince != null) parts.add(_selectedProvince!);
    if (_selectedCity != null) parts.add(_selectedCity!);
    if (_selectedDistrict != null) parts.add(_selectedDistrict!);
    if (_detailedController.text.trim().isNotEmpty) {
      parts.add(_detailedController.text.trim());
    }
    return parts.join(' ');
  }
}