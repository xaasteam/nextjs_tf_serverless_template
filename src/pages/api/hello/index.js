// src/pages/api/hello.js
// const { APIGatewayProxyHandler } = require('aws-lambda');

const handler = async (event) => {
  if (event.httpMethod === 'GET') {
    return {
      statusCode: 200,
      body: JSON.stringify({ message: 'Hello!' }),
    };
  } else {
    return {
      statusCode: 405,
      body: JSON.stringify({ message: 'Method Not Allowed' }),
    };
  }
};

module.exports.handler = handler;