// seed the database wiht the stock data of last seven trading days

import { ingestWinner } from '../cron/utils/ingestWinner.js';
import { getLastNTradingDays } from './helpers.js';

const ONE_DAY_MS = 24 * 60 * 60 * 1000;

const seedDb = async() => {
    const tradingDates = getLastNTradingDays(7);
    for (const date of tradingDates) {
        await ingestWinner(date);
    }
}

seedDb();


       


