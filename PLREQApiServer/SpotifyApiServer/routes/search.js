const { Router } = require('express');
const router = Router();

const { getTracks } = require('../spotify/endpoints/search');

router.get('/tracks/', async (req, res) => {

  const { track, album, artist, limit } = req.query;
  const params = {
    track,
    album,
    artist,
    limit
  };

  const { token } = req.body;
  console.log(token);
  const data = await getTracks(params, token);
  
  let statusCode = !data.error ? 200 : 400;
  res.status(statusCode).json(data);
});

module.exports = router;