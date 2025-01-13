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
    const order = {
        id: '12345',
        email: 'clerk.outward296@simplelogin.com',
        products: [
            { id: 'prod-1', quantity: 2, price: 29.99 },
            { id: 'prod-2', quantity: 1, price: 49.99 }
        ]
    };

    res.json(order);
});

const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Backend server running on http://localhost:${PORT}`);
});
