# 插件系统结构冻结说明 (PLUGINS_FREEZE.md)

**版本:** 1.0  
**状态:** 已冻结  
**更新日期:** 2025-05-17  
**编制人:** 系统架构组

## 📑 目录

- [1. 概述](#1-概述)
- [2. 设计原则](#2-设计原则)
- [3. 目录结构](#3-目录结构)
- [4. 插件模块详情](#4-插件模块详情)
  - [4.1 短信服务插件 (sms/)](#41-短信服务插件-sms)
  - [4.2 支付系统插件 (payment/)](#42-支付系统插件-payment)
  - [4.3 邮件系统插件 (email/)](#43-邮件系统插件-email)
  - [4.4 文件存储插件 (storage/)](#44-文件存储插件-storage)
  - [4.5 数据导出插件 (export/)](#45-数据导出插件-export)
  - [4.6 AI大模型插件 (llm/)](#46-ai大模型插件-llm)
  - [4.7 第三方平台集成插件 (platform/)](#47-第三方平台集成插件-platform)
- [5. 插件注册与调用机制](#5-插件注册与调用机制)
- [6. 冻结范围](#6-冻结范围)
- [7. 更新与维护](#7-更新与维护)

## 1. 概述

本文档定义了智能营养餐厅系统的插件(Plugins)结构，插件系统基于工厂模式和适配器模式设计，通过统一接口封装不同第三方服务，实现系统功能的模块化和可替换性。插件系统支持在不修改核心代码的情况下，灵活切换服务提供商或扩展新功能。

插件层作为系统与外部服务交互的桥梁，其结构冻结对保障系统稳定性和可维护性至关重要。本文档详细说明了各个插件模块的用途、组成和扩展方式，为开发团队提供统一的外部服务对接规范。

## 2. 设计原则

- **统一接口原则**: 每类插件提供统一的接口，隐藏不同服务商的实现差异
- **工厂/适配器模式**: 使用工厂或适配器模式实现插件的动态选择和加载
- **配置驱动原则**: 通过配置文件控制插件的选择和参数，无需修改代码
- **单一职责原则**: 每个插件专注于特定功能领域，功能内聚、边界清晰
- **可替换原则**: 同类插件可以无缝替换，不影响业务逻辑
- **可扩展原则**: 支持方便地添加新的插件实现，而不需修改现有代码
- **错误隔离原则**: 插件的错误不应影响核心系统，应做好异常捕获和处理

## 3. 目录结构

插件系统采用以下目录结构：

```
/backend/plugins/
├── sms/                            # 短信服务插件（用户注册、登录、验证码发送）
│   ├── aliSmsPlugin.js             # 阿里云短信发送封装
│   ├── tencentSmsPlugin.js         # 腾讯云短信封装
│   └── smsFactory.js               # 根据配置选择短信服务提供商统一导出
│
├── payment/                        # 支付系统插件（订单支付、订阅续费）
│   ├── wechatPayPlugin.js          # 微信支付封装
│   ├── alipayPlugin.js             # 支付宝支付封装
│   ├── stripePlugin.js             # Stripe 国际支付插件（如面向海外用户）
│   └── paymentGateway.js           # 根据订单来源调用统一支付处理器
│
├── email/                          # 邮件系统插件（注册成功、系统通知、反馈答复等）
│   ├── smtpMailer.js               # 使用 SMTP 发送邮件（基于 nodemailer）
│   └── emailService.js             # 邮件统一发送服务封装（模板、队列）
│
├── storage/                        # 文件上传服务（商家菜品图、用户头像等）
│   ├── aliyunOssPlugin.js          # 阿里云 OSS 上传封装
│   └── storageAdapter.js           # 支持统一调用本地/OSS/七牛等适配器
│
├── export/                         # 数据导出功能插件（营养推荐计划、订单导出等）
│   ├── pdfExporter.js              # 导出 PDF 格式（推荐计划）
│   ├── excelExporter.js            # 导出 Excel 表格（订单、档案等）
│   └── exportAdapter.js            # 统一导出接口封装（调用不同导出模块）
│
├── llm/                            # AI大模型插件（推荐生成、对话、评分等）
│   ├── openaiPlugin.js             # OpenAI 调用封装（推荐/对话/评分）
│   └── modelAdapter.js             # 多模型适配器封装（支持未来 DeepSeek、百度千帆等）
│
├── platform/                       # 第三方平台集成（对接企业微信、钉钉、三方登录等）
│   ├── wecomAdapter.js             # 企业微信机器人消息推送
│   ├── dingTalkAdapter.js          # 钉钉通知接口封装（如后台预警）
│   └── oauthAdapter.js             # 微信 / Apple ID / 支付宝 第三方登录封装
│
└── index.js                        # 所有插件模块的统一导出聚合
```

## 4. 插件模块详情

### 4.1 短信服务插件 (sms/)

**用途**: 提供短信发送服务，用于用户注册、登录验证码、安全提醒等场景。支持多个短信服务提供商，可通过配置动态切换。

| 文件名 | 功能说明 | 设计模式 | 配置项 | 冻结状态 |
|-------|---------|---------|-------|---------|
| **aliSmsPlugin.js** | 阿里云短信服务封装，实现验证码、通知类短信发送 | 具体实现类 | `accessKeyId`、`accessKeySecret`、`signName` | ✅ 已冻结 |
| **tencentSmsPlugin.js** | 腾讯云短信服务封装，提供与阿里云相同的接口 | 具体实现类 | `secretId`、`secretKey`、`appId`、`sign` | ✅ 已冻结 |
| **smsFactory.js** | 短信服务工厂类，根据配置动态选择短信提供商 | 工厂模式 | `config.sms.vendor` 控制使用哪个服务商 | ✅ 已冻结 |

**调用方式**:
- 业务层通过统一接口调用短信服务，无需关心具体实现
- 支持的方法包括：`sendVerificationCode`、`sendNotification`、`sendMarketingMessage`等

**冻结说明**: 插件结构已冻结，后续扩展应新增具体实现类文件并在工厂模块中注册，不改变接口定义。

### 4.2 支付系统插件 (payment/)

**用途**: 提供多种支付方式集成，用于订单支付、会员订阅、充值等场景。支持国内外多种支付渠道，可根据用户选择或地域自动切换。

| 文件名 | 功能说明 | 设计模式 | 配置项 | 冻结状态 |
|-------|---------|---------|-------|---------|
| **wechatPayPlugin.js** | 微信支付封装，支持小程序、公众号、APP支付 | 具体实现类 | `appId`、`mchId`、`apiKey`、`certPath` | ✅ 已冻结 |
| **alipayPlugin.js** | 支付宝支付封装，支持网页、APP、当面付 | 具体实现类 | `appId`、`privateKey`、`alipayPublicKey` | ✅ 已冻结 |
| **stripePlugin.js** | Stripe国际支付封装，支持信用卡支付 | 具体实现类 | `apiKey`、`webhookSecret` | ✅ 已冻结 |
| **paymentGateway.js** | 支付网关，根据订单信息和用户偏好选择支付方式 | 适配器模式 | `config.payment.defaultGateway` | ✅ 已冻结 |

**调用方式**:
- 业务层通过统一接口创建支付订单，获取支付链接或参数
- 支持的方法包括：`createOrder`、`queryOrderStatus`、`refund`、`createSubscription`等

**冻结说明**: 插件结构已冻结，后续扩展应新增具体实现类文件并在网关中注册，不改变接口定义。

### 4.3 邮件系统插件 (email/)

**用途**: 提供邮件发送服务，用于系统通知、账号激活、营养方案推送等场景。支持模板渲染、附件发送和发送队列。

| 文件名 | 功能说明 | 设计模式 | 配置项 | 冻结状态 |
|-------|---------|---------|-------|---------|
| **smtpMailer.js** | 基于nodemailer的SMTP邮件发送实现 | 具体实现类 | `host`、`port`、`secure`、`auth` | ✅ 已冻结 |
| **emailService.js** | 邮件服务封装，提供模板渲染、发送队列管理 | 服务封装 | `config.email.templates`、`config.email.from` | ✅ 已冻结 |

**调用方式**:
- 业务层通过服务接口发送邮件，支持模板和直接内容
- 支持的方法包括：`sendWithTemplate`、`sendRawEmail`、`addToQueue`、`attachFile`等

**冻结说明**: 插件结构已冻结，后续可扩展其他邮件服务提供商或增强模板功能，不改变接口定义。

### 4.4 文件存储插件 (storage/)

**用途**: 提供文件上传和存储服务，用于用户头像、商家菜品图片、营养方案附件等场景。支持本地存储和云存储。

| 文件名 | 功能说明 | 设计模式 | 配置项 | 冻结状态 |
|-------|---------|---------|-------|---------|
| **aliyunOssPlugin.js** | 阿里云对象存储服务封装 | 具体实现类 | `accessKeyId`、`accessKeySecret`、`bucket`、`region` | ✅ 已冻结 |
| **storageAdapter.js** | 存储适配器，统一不同存储服务的接口 | 适配器模式 | `config.storage.provider`、`config.storage.options` | ✅ 已冻结 |

**调用方式**:
- 业务层通过统一接口上传和管理文件，无需关心底层存储
- 支持的方法包括：`upload`、`download`、`delete`、`getPublicUrl`、`generateSignedUrl`等

**冻结说明**: 插件结构已冻结，后续扩展应新增具体实现类文件并在适配器中注册，不改变接口定义。

### 4.5 数据导出插件 (export/)

**用途**: 提供数据导出功能，用于营养推荐计划导出、订单记录导出、用户数据导出等场景。支持多种导出格式。

| 文件名 | 功能说明 | 设计模式 | 配置项 | 冻结状态 |
|-------|---------|---------|-------|---------|
| **pdfExporter.js** | PDF格式导出工具，适用于营养推荐计划等 | 具体实现类 | `config.export.pdf.template`、`config.export.pdf.options` | ✅ 已冻结 |
| **excelExporter.js** | Excel表格导出工具，适用于数据列表导出 | 具体实现类 | `config.export.excel.template`、`config.export.excel.options` | ✅ 已冻结 |
| **exportAdapter.js** | 导出适配器，根据需求选择合适的导出格式 | 适配器模式 | `config.export.defaultFormat` | ✅ 已冻结 |

**调用方式**:
- 业务层通过统一接口进行数据导出，指定数据和格式
- 支持的方法包括：`exportData`、`generateFile`、`streamToClient`、`saveToStorage`等

**冻结说明**: 插件结构已冻结，后续扩展应新增具体实现类文件并在适配器中注册，不改变接口定义。

### 4.6 AI大模型插件 (llm/)

**用途**: 提供AI大模型集成，用于营养推荐生成、智能对话、内容评分等场景。支持多种AI模型，可配置切换。

| 文件名 | 功能说明 | 设计模式 | 配置项 | 冻结状态 |
|-------|---------|---------|-------|---------|
| **openaiPlugin.js** | OpenAI模型调用封装，支持不同功能场景 | 具体实现类 | `apiKey`、`organization`、`model`、`temperature` | ✅ 已冻结 |
| **modelAdapter.js** | 模型适配器，统一不同模型的调用接口 | 适配器模式 | `config.llm.provider`、`config.llm.options` | ✅ 已冻结 |

**调用方式**:
- 业务层通过统一接口调用AI能力，无需关心具体模型实现
- 支持的方法包括：`generateRecommendation`、`chat`、`scoreContent`、`summarize`等

**冻结说明**: 插件结构已冻结，后续扩展应新增具体实现类文件，如百度千帆API、DeepSeek等，并在适配器中注册，不改变接口定义。

### 4.7 第三方平台集成插件 (platform/)

**用途**: 提供与第三方平台集成的能力，用于企业通知、第三方登录、外部系统对接等场景。

| 文件名 | 功能说明 | 设计模式 | 配置项 | 冻结状态 |
|-------|---------|---------|-------|---------|
| **wecomAdapter.js** | 企业微信机器人推送封装，用于系统通知和预警 | 具体实现类 | `webhookUrl`、`secret`、`corpId`、`agentId` | ✅ 已冻结 |
| **dingTalkAdapter.js** | 钉钉通知封装，用于系统预警和运营通知 | 具体实现类 | `accessToken`、`secret` | ✅ 已冻结 |
| **oauthAdapter.js** | 第三方登录适配器，支持微信、支付宝、Apple ID等 | 适配器模式 | `config.oauth.providers` | ✅ 已冻结 |

**调用方式**:
- 业务层通过统一接口与第三方平台交互，无需关心平台差异
- 支持的方法包括：`sendNotification`、`authorize`、`getToken`、`getUserInfo`等

**冻结说明**: 插件结构已冻结，后续扩展应新增具体实现类文件并在适配器中注册，不改变接口定义。

## 5. 插件注册与调用机制

插件系统提供以下注册和调用机制：

### 5.1 统一导出入口

**index.js** 文件是插件系统的统一导出入口，它聚合所有插件模块并提供给业务层使用。

```javascript
// 统一导出示例（在 index.js 中）
const smsFactory = require('./sms/smsFactory');
const paymentGateway = require('./payment/paymentGateway');
const emailService = require('./email/emailService');
// ... 其他插件导入

module.exports = {
  sms: smsFactory.createSmsService(),
  payment: paymentGateway,
  email: emailService,
  // ... 其他插件导出
};
```

### 5.2 工厂模式注册

对于支持多个服务提供商的插件，通过工厂模式实现动态选择。

```javascript
// 工厂模式示例（smsFactory.js 中）
const aliSmsPlugin = require('./aliSmsPlugin');
const tencentSmsPlugin = require('./tencentSmsPlugin');
const config = require('../../config');

const smsProviders = {
  'aliyun': aliSmsPlugin,
  'tencent': tencentSmsPlugin
};

exports.createSmsService = () => {
  const provider = config.sms.vendor || 'aliyun';
  return new smsProviders[provider](config.sms.options);
};
```

### 5.3 适配器模式注册

对于需要统一不同接口的插件，通过适配器模式实现统一调用。

```javascript
// 适配器模式示例（modelAdapter.js 中）
const openaiPlugin = require('./openaiPlugin');
const config = require('../../config');

class ModelAdapter {
  constructor() {
    this.provider = this._initProvider();
  }

  _initProvider() {
    const providerName = config.llm.provider || 'openai';
    const options = config.llm.options || {};
    
    switch(providerName) {
      case 'openai':
        return new openaiPlugin(options);
      // 未来可以扩展其他模型提供商
      default:
        return new openaiPlugin(options);
    }
  }

  // 提供统一的接口方法
  async generateRecommendation(userProfile) {
    return this.provider.generateRecommendation(userProfile);
  }
  
  // 其他接口方法...
}

module.exports = new ModelAdapter();
```

### 5.4 配置驱动选择

插件的选择和参数通过配置文件控制，实现无代码修改的服务切换。

```javascript
// 配置示例（config/modules/plugins.js 中）
module.exports = {
  sms: {
    vendor: process.env.SMS_VENDOR || 'aliyun',
    options: {
      // 服务商特定配置
    }
  },
  payment: {
    defaultGateway: process.env.DEFAULT_PAYMENT || 'wechat',
    options: {
      // 支付网关特定配置
    }
  },
  // 其他插件配置...
};
```

## 6. 冻结范围

以下插件系统内容被定义为冻结状态：

1. **目录结构**
   - 顶级目录的组织方式和分类逻辑
   - 各插件模块的命名和分组规则

2. **接口定义**
   - 各类插件对外提供的接口方法和参数
   - 返回数据的结构和格式

3. **设计模式**
   - 工厂模式和适配器模式的使用方式
   - 插件注册和实例化的机制

4. **导出方式**
   - index.js 中统一导出的机制
   - 各插件模块的封装和暴露方式

5. **配置结构**
   - 插件配置的组织方式和关键参数名称
   - 配置驱动的实现机制

## 7. 更新与维护

尽管插件系统结构已冻结，但以下内容需要持续更新：

1. **增加新的服务提供商**
   - 可以为现有插件类型添加新的服务提供商实现
   - 需遵循已有的接口定义和注册机制

2. **扩展现有接口能力**
   - 可以在保持向后兼容的前提下扩展接口能力
   - 需同步更新所有服务提供商的实现

3. **优化适配器和工厂实现**
   - 可以优化内部实现以提高性能和可靠性
   - 可以增强错误处理和日志记录功能

4. **更新配置参数**
   - 可以根据新的服务提供商需求更新配置参数
   - 需保持配置结构的一致性和兼容性

---
⚠️ **注意**: 本文档定义的插件系统结构已冻结，未经架构委员会批准，不得更改插件的目录结构、接口定义和注册机制。所有扩展应在现有结构框架内进行。 