export const hello = async (event) => {
    console.log(event);
    const watchlist = process.env.WATCHLIST;
    return {
        statusCode: 200,
        body: JSON.stringify({
            message: "Hello, World!",
            watchlist: watchlist
        })
    }
}