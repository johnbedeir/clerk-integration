require('dotenv').config();
const express = require('express');
const axios = require('axios');
const path = require('path');
const bodyParser = require('body-parser');
const app = express();
app.use(bodyParser.json());

// Serve static files from the public directory
app.use(express.static(path.join(__dirname, 'public')));

// Clerk.io API keys (fetched from the .env file)
const CLERK_PUBLIC_KEY = process.env.CLERK_PUBLIC_KEY;
const CLERK_PRIVATE_KEY = process.env.CLERK_PRIVATE_KEY;
const BASE_URL = process.env.BASE_URL || 'http://localhost:3000';
const CLERK_API_URL = process.env.CLERK_API_URL
const clerkFeed = require('./clerk.json');
const orderData = require('./order.json'); 

app.get('/api/products', async (req, res) => {
    try {
        const url = `${CLERK_API_URL}${CLERK_PUBLIC_KEY}`;

        const response = await axios.get(url, {
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${CLERK_PRIVATE_KEY}`
            }
        });

        res.json(response.data);
    } catch (error) {
        console.error('Error fetching products:', error.response ? error.response.data : error.message);
        res.status(500).json({ error: 'Failed to fetch products' });
    }
});

app.get('/feeds/clerk.json', (req, res) => {
    res.json(clerkFeed);
});

app.get('/api/order-confirmation', (req, res) => {
    res.json(orderData);
});

const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Backend server running on http://localhost:${PORT}`);
});
