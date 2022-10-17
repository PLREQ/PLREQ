const express = require('express');
const morgan = require('morgan');
require('dotenv').config();

const app = express();

// settings
app.set('port', process.env.PORT || 3000);

// middlewares
app.use(morgan('dev'));
app.use(express.json());
app.use(express.urlencoded({extended: false}));

// Routes
app.use('/', require('./routes/index'));

// Server
app.listen(app.get('port'), () => {
    console.log(`Server on port ${app.get('port')}`);
});