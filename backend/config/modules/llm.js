/**
 * 大语言模型(LLM)配置
 * 定义LLM提供商和参数设置
 */

require('dotenv').config();

const llmConfig = {
  // LLM提供商，例如：'openai'、'azure'、'huggingface'
  vendor: process.env.LLM_VENDOR || 'openai',
  
  // 生成的随机性程度（0-1）
  temperature: parseFloat(process.env.LLM_TEMPERATURE || '0.7'),
  
  // 生成时的最大令牌数
  maxTokens: parseInt(process.env.LLM_MAX_TOKENS || '1024'),
  
  // 模型设置
  models: {
    // 默认模型
    default: process.env.LLM_DEFAULT_MODEL || 'gpt-3.5-turbo',
    // 用于高级功能的模型
    advanced: process.env.LLM_ADVANCED_MODEL || 'gpt-4',
    // 用于嵌入的模型
    embedding: process.env.LLM_EMBEDDING_MODEL || 'text-embedding-ada-002'
  },
  
  // 请求设置
  request: {
    timeout: parseInt(process.env.LLM_REQUEST_TIMEOUT || '30000'),
    retries: parseInt(process.env.LLM_REQUEST_RETRIES || '3'),
    concurrencyLimit: parseInt(process.env.LLM_CONCURRENCY_LIMIT || '10')
  },
  
  // 提供商特定配置
  providers: {
    openai: {
      apiKey: process.env.OPENAI_API_KEY,
      organization: process.env.OPENAI_ORGANIZATION,
      apiBaseUrl: process.env.OPENAI_API_BASE_URL || 'https://api.openai.com/v1'
    },
    azure: {
      apiKey: process.env.AZURE_OPENAI_API_KEY,
      endpoint: process.env.AZURE_OPENAI_ENDPOINT,
      deploymentName: process.env.AZURE_OPENAI_DEPLOYMENT_NAME,
      apiVersion: process.env.AZURE_OPENAI_API_VERSION || '2023-05-15'
    },
    huggingface: {
      apiKey: process.env.HUGGINGFACE_API_KEY,
      model: process.env.HUGGINGFACE_MODEL,
      apiBaseUrl: process.env.HUGGINGFACE_API_BASE_URL || 'https://api-inference.huggingface.co/models'
    },
    anthropic: {
      apiKey: process.env.ANTHROPIC_API_KEY,
      model: process.env.ANTHROPIC_MODEL || 'claude-2'
    },
    mock: {
      // 模拟LLM设置，用于测试
      useFixedResponses: process.env.LLM_MOCK_FIXED_RESPONSES === 'true',
      responsesFile: process.env.LLM_MOCK_RESPONSES_FILE || 'mocks/llm-responses.json'
    }
  },
  
  // 缓存设置
  cache: {
    enabled: process.env.LLM_CACHE_ENABLED === 'true',
    ttl: parseInt(process.env.LLM_CACHE_TTL || '3600'), // 默认1小时
    maxSize: parseInt(process.env.LLM_CACHE_MAX_SIZE || '1000') // 最大缓存条目数
  },
  
  // 提示词设置
  prompts: {
    // 系统提示词路径
    systemPromptPath: process.env.LLM_SYSTEM_PROMPT_PATH || 'prompts/system',
    // 专业领域提示词路径
    domainPromptPath: process.env.LLM_DOMAIN_PROMPT_PATH || 'prompts/domain'
  },
  
  // 安全设置
  safety: {
    contentFiltering: process.env.LLM_CONTENT_FILTERING !== 'false',
    maxOutputLength: parseInt(process.env.LLM_MAX_OUTPUT_LENGTH || '4096'),
    blockedTopics: (process.env.LLM_BLOCKED_TOPICS || '').split(',').filter(Boolean)
  },
  
  // 日志设置
  logging: {
    logPrompts: process.env.LLM_LOG_PROMPTS === 'true',
    logResponses: process.env.LLM_LOG_RESPONSES === 'true',
    logTokenUsage: process.env.LLM_LOG_TOKEN_USAGE !== 'false'
  }
};

module.exports = llmConfig; 