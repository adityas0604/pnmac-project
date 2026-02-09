import { WATCHLIST } from "../../shared/variables.js";
import { getStocksOpenClose } from "./massiveService.js";
import { insertWinnerData } from "./db.js";
import { getLastNTradingDays } from "../../shared/helpers.js";

const ONE_DAY_MS = 24 * 60 * 60 * 1000;

export const ingestWinner = async (dateString = null) => {

    if (!dateString) {
        dateString = getLastNTradingDays(1)[0];
    }
    
    let percentageChange = 0;
    let winner = { PercentageChange: 0 };
    let stockData = null;
    for (const ticker of WATCHLIST) {
        try {
        stockData = await getStocksOpenClose(ticker, dateString);
        } catch (e) {
            console.error('An error happened:', e);
            throw e;
        }
        percentageChange = computerPercentageChange(stockData.close, stockData.open);
        if (Math.abs(percentageChange) > Math.abs(winner.PercentageChange)) {
            winner = {
                Ticker: ticker,
                PercentageChange: percentageChange,
                Open: stockData.open * 1000,
                Close: stockData.close * 1000,
            };
        }
    }
    winner.Date = dateString;

    await insertWinnerData(winner);

    return true;

}

const computerPercentageChange = (close, open) => {
    return ((close - open) / open) * 100;
}

    






