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

// Example route: Fetch products
app.get('/api/products', async (req, res) => {
    try {
        // Include the public key as a query parameter
        const url = `${CLERK_API_URL}${CLERK_PUBLIC_KEY}`;

        const response = await axios.get(url, {
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${CLERK_PRIVATE_KEY}`
            }
        });

        // Return the API response to the client
        res.json(response.data);
    } catch (error) {
        console.error('Error fetching products:', error.response ? error.response.data : error.message);
        res.status(500).json({ error: 'Failed to fetch products' });
    }
});

app.get('/feeds/clerk.json', (req, res) => {
    const clerkFeed = {
        products: [
            {
                id: "product-1",
                name: "Product 1",
                description: "A sample product description.",
                price: 29.99,
                url: `http://clerk.johnydev.com/products/product-1`,  
                image: `http://clerk.johnydev.com/images/product-1.jpg`, 
                categories: ["category-1", "category-2"],
                stock: 100
            },
            {
                id: "product-2",
                name: "Product 2",
                description: "Another product description.",
                price: 49.99,
                url: `http://clerk.johnydev.com/products/product-2`,  
                image: `http://clerk.johnydev.com/images/product-2.jpg`, 
                categories: ["category-1"],
                stock: 50
            }
        ]
    };

    // Log output for debugging
    console.log('Serving clerk.json:', JSON.stringify(clerkFeed, null, 2));
    res.json(clerkFeed);
});

// Dynamic order confirmation route
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

// Start the server
const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Backend server running on http://localhost:${PORT}`);
});
