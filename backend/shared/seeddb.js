// seed the database wiht the stock data of last seven trading days

import { ingestWinner } from '../cron/utils/ingestWinner.js';

const ONE_DAY_MS = 24 * 60 * 60 * 1000;

const seedDb = async() => {
    const tradingDates = getLastSevenTradingDays();
    for (const date of tradingDates) {
        await ingestWinner(date);
    }
}


const getLastSevenTradingDays = () => {

    const tradingDates = [];

    let i = 1;

    while (tradingDates.length < 7) {
        const date = new Intl.DateTimeFormat("en-US", {
            timeZone: "America/New_York",
            dateStyle: "full"
        }).format(new Date() - i * ONE_DAY_MS );

        const day = date.split(",")[0];

        if (day !== "Saturday" && day !== "Sunday") {
            const date = new Intl.DateTimeFormat("en-US", {
                timeZone: "America/New_York",
                year: "numeric",
                month: "2-digit",
                day: "2-digit",
            }).format(new Date() - i * ONE_DAY_MS );
              
            //CONVERT TO YYYY-MM-DD
            const dateArray = date.split("/")
            const dateString = dateArray[2] + "-" + dateArray[0] + "-" + dateArray[1];

            tradingDates.push(dateString);
            console.log(dateString);

        }
        i++;
    }
    return tradingDates;
}

seedDb();


       


