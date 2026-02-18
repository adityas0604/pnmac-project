import { getLastNDaysMovers } from "./utils/db.js";

export const getTopMovers = async (event) => {
    try{
        // 8 days to include the 7th day, 8th is ignored
        const topMovers = await getLastNDaysMovers(8);
        return {
            statusCode: 200,
            headers: {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*"
            },
            body: JSON.stringify(topMovers)
        }
    } catch (error) {
        console.error(error);
        return {
            statusCode: 500,
            headers: {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*"
            },
            body: JSON.stringify({ message: "Internal server error" })
        }
    }
}

