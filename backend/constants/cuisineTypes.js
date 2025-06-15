/**
 * 菜系类型常量定义
 * @module constants/cuisineTypes
 */

// 八大菜系
const MAJOR_CUISINES = {
  SICHUAN: 'sichuan',      // 川菜
  CANTONESE: 'cantonese',  // 粤菜
  SHANDONG: 'shandong',    // 鲁菜
  JIANGSU: 'jiangsu',      // 苏菜
  ZHEJIANG: 'zhejiang',    // 浙菜
  FUJIAN: 'fujian',        // 闽菜
  HUNAN: 'hunan',          // 湘菜
  ANHUI: 'anhui'           // 徽菜
};

// 地方特色菜系
const REGIONAL_CUISINES = {
  NORTHEAST: 'northeast',   // 东北菜
  NORTHWEST: 'northwest',   // 西北菜
  YUNNAN: 'yunnan',        // 云南菜
  GUIZHOU: 'guizhou',      // 贵州菜
  JIANGXI: 'jiangxi',      // 江西菜
  TAIWAN: 'taiwan',        // 台湾菜
  BEIJING: 'beijing',      // 京菜
  SHANGHAI: 'shanghai',    // 沪菜
  XINJIANG: 'xinjiang',    // 新疆菜
  TIBET: 'tibet',          // 藏菜
  INNER_MONGOLIA: 'inner_mongolia' // 内蒙菜
};

// 国际菜系
const INTERNATIONAL_CUISINES = {
  WESTERN: 'western',      // 西餐
  JAPANESE: 'japanese',    // 日本料理
  KOREAN: 'korean',        // 韩国料理
  SOUTHEAST_ASIAN: 'southeast_asian', // 东南亚菜
  ITALIAN: 'italian',      // 意大利菜
  FRENCH: 'french',        // 法国菜
  AMERICAN: 'american',    // 美式料理
  MEXICAN: 'mexican',      // 墨西哥菜
  INDIAN: 'indian',        // 印度菜
  MIDDLE_EASTERN: 'middle_eastern' // 中东菜
};

// 所有菜系
const ALL_CUISINES = {
  ...MAJOR_CUISINES,
  ...REGIONAL_CUISINES,
  ...INTERNATIONAL_CUISINES
};

// 菜系显示名称映射
const CUISINE_LABELS = {
  // 八大菜系
  [MAJOR_CUISINES.SICHUAN]: '川菜',
  [MAJOR_CUISINES.CANTONESE]: '粤菜',
  [MAJOR_CUISINES.SHANDONG]: '鲁菜',
  [MAJOR_CUISINES.JIANGSU]: '苏菜',
  [MAJOR_CUISINES.ZHEJIANG]: '浙菜',
  [MAJOR_CUISINES.FUJIAN]: '闽菜',
  [MAJOR_CUISINES.HUNAN]: '湘菜',
  [MAJOR_CUISINES.ANHUI]: '徽菜',
  // 地方特色
  [REGIONAL_CUISINES.NORTHEAST]: '东北菜',
  [REGIONAL_CUISINES.NORTHWEST]: '西北菜',
  [REGIONAL_CUISINES.YUNNAN]: '云南菜',
  [REGIONAL_CUISINES.GUIZHOU]: '贵州菜',
  [REGIONAL_CUISINES.JIANGXI]: '江西菜',
  [REGIONAL_CUISINES.TAIWAN]: '台湾菜',
  [REGIONAL_CUISINES.BEIJING]: '京菜',
  [REGIONAL_CUISINES.SHANGHAI]: '沪菜',
  [REGIONAL_CUISINES.XINJIANG]: '新疆菜',
  [REGIONAL_CUISINES.TIBET]: '藏菜',
  [REGIONAL_CUISINES.INNER_MONGOLIA]: '内蒙菜',
  // 国际菜系
  [INTERNATIONAL_CUISINES.WESTERN]: '西餐',
  [INTERNATIONAL_CUISINES.JAPANESE]: '日本料理',
  [INTERNATIONAL_CUISINES.KOREAN]: '韩国料理',
  [INTERNATIONAL_CUISINES.SOUTHEAST_ASIAN]: '东南亚菜',
  [INTERNATIONAL_CUISINES.ITALIAN]: '意大利菜',
  [INTERNATIONAL_CUISINES.FRENCH]: '法国菜',
  [INTERNATIONAL_CUISINES.AMERICAN]: '美式料理',
  [INTERNATIONAL_CUISINES.MEXICAN]: '墨西哥菜',
  [INTERNATIONAL_CUISINES.INDIAN]: '印度菜',
  [INTERNATIONAL_CUISINES.MIDDLE_EASTERN]: '中东菜'
};

// 菜系分组
const CUISINE_GROUPS = {
  major: Object.values(MAJOR_CUISINES),
  regional: Object.values(REGIONAL_CUISINES),
  international: Object.values(INTERNATIONAL_CUISINES)
};

module.exports = {
  MAJOR_CUISINES,
  REGIONAL_CUISINES,
  INTERNATIONAL_CUISINES,
  ALL_CUISINES,
  CUISINE_LABELS,
  CUISINE_GROUPS
};