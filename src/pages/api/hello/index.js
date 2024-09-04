// src/pages/api/hello.js

const handler = async (req, res) => {
  if (req.method === 'GET') {
    res.status(200).json({ message: 'Hello!' });
  } else {
    res.status(405).json({ message: 'Method Not Allowed' });
  }
};

// Export for Next.js
if (typeof module !== 'undefined' && module.exports) {
  module.exports = handler;
}

// Export for Serverless
export default handler;