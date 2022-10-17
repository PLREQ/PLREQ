const { fetchEndpoint } = require('./fetchEndpoint');
const { reduceTracks } = require('../dataReducer');
const endpointURL = 'https://api.spotify.com/v1/search';

const getTracks = async (params, lastToken) => {

    const { track, album, artist, limit } = params || {};

    let q = track || '';
    q += album ? ` album:${album}` : '';
    q += artist ? ` artist:${artist}` : '';

    const Params = {
        q: q || '',
        type: 'track',
        limit: limit || 20
    };

    try {

        const data = await fetchEndpoint(endpointURL, Params, lastToken);
        const { error, tracks, token } = data;
        
        if (!error && tracks) {
            return {
                tracks: reduceTracks(tracks),
                token
            }
        }
        else return data;

    }
    catch (error) {
        return {
            error
        }
    }
};



module.exports = {
    getTracks
}