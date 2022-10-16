const fetch = require('node-fetch');
const colors = require('colors/safe');
const { stringify } = require('querystring');

const { ClientCredentials, validateToken } = require('../auth');


const doFetch = async (endpointURL, queryParams, token) => {

    const { token_type, access_token } = token;

    try {
        const Options = {
            headers: {
                'Authorization': `${token_type} ${access_token}`
            }
        };

        // Query Params
        let queryString = '';
        if (queryParams) {
            queryString = '?' + stringify(queryParams);
        }

        // Construye la URL
        const fetchURL = endpointURL + queryString;

        // fetch a la API
        const respuesta = await fetch(fetchURL, Options);
        const data = await respuesta.json();

        return data;

    } catch (error) {
        return {
            error
        }
    }

};

const fetchEndpoint = (async (endpointURL, queryParams, lastToken) => {

    let token = lastToken;
    if (!validateToken(token)) {
        token = await ClientCredentials();
    }

    let { error, access_token, token_type } = token;

    if (error) return {
        error
    }

    let data = await doFetch(endpointURL, queryParams, token);

    error = data.error;
    if (error) {
        if (error.status == 401) {
            token = await ClientCredentials();

            ({ error, access_token, token_type } = token);
            if (error) return {
                error
            }

            data = await doFetch(endpointURL, queryParams, token);
        }
    }

    return {
        ...data,
        token
    }

});


module.exports = {
    fetchEndpoint
}