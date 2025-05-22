const fs = require('fs');
const path = require('path');
const swaggerSpec = require('./swagger');

fs.writeFileSync(
  path.join(__dirname, './integrations/swagger-openapi.yaml'),
  JSON.stringify(swaggerSpec, null, 2)
);
console.log('✅ OpenAPI 文档生成成功：docs/integrations/swagger-openapi.yaml'); 