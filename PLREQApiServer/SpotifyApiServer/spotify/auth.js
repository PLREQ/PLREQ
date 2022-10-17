const fetch = require('node-fetch');
const { URLSearchParams } = require('url');

const { spotifyKeys } = require('./credentials');
const { client_id, client_secret } = spotifyKeys;

const authURL = 'https://accounts.spotify.com/api/token';


const ClientCredentials = (async () => {

    try {

        // Forms Parameters
        const params = new URLSearchParams();
        params.append('grant_type', 'client_credentials');

        var authOptions = {
            method: 'POST',
            headers: {
                'Authorization': ('Basic ' + (new Buffer(client_id + ':' + client_secret).toString('base64')))
            },
            body: params
        };


        const respuesta = await fetch(authURL, authOptions);
        const token = await respuesta.json();

        return token;

    } catch (error) {

        return {
            error
        }
    }

});

const validateToken = (token) => {
    if(!token){
        return false;
    }
    const { access_token, token_type } = token;
    return (access_token && token_type);
}

module.exports = {
    ClientCredentials,
    validateToken
}