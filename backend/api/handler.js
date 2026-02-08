import { getLastNDaysMovers } from "./utils/db.js";

export const getTopMovers = async (event) => {
    try{
        const topMovers = await getLastNDaysMovers(7);
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

