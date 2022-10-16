const reduceTracks = (tracks) => {

    try {
        const { href, next, items, limit, offset } = tracks;

        let lightItems = [];
        items.forEach((value) => {

            const { id, album, artists, external_urls, name, preview_url } = value;

            const lightTrack = {
                id,
                name,
                artists,
                external_urls,
                preview_url,
                album: {
                    id: album.id,
                    name: album.name,
                    external_urls: album.external_urls,
                    images: album.images
                }
            };

            lightItems.push(lightTrack)
        });

        const ligthData = {
            items: lightItems,
            href,
            next,
            limit,
            offset
        }

        return ligthData;

    }
    catch (error) {
        return tracks;
    }
};

module.exports = {
    reduceTracks
}