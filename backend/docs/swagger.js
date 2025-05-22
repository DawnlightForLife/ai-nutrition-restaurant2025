const swaggerJSDoc = require('swagger-jsdoc');
const path = require('path');

const options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'Smart Nutrition Restaurant API',
      version: '1.0.0',
    },
  },
  apis: [path.join(__dirname, '../routes/**/*.js'), path.join(__dirname, '../models/**/*.js')],
};

const swaggerSpec = swaggerJSDoc(options);
module.exports = swaggerSpec; 