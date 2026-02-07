import { WATCHLIST } from "../../shared/variables.js";
import { getStocksOpenClose } from "./massiveService.js";
import { insertWinnerData } from "./db.js";

const ONE_DAY_MS = 24 * 60 * 60 * 1000;

export const ingestWinner = async () => {
    const completeStocksData = []

    const dateString = getPreviousETDate();
    
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
                Open: stockData.open,
                Close: stockData.close,
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

const getPreviousETDate = () => {

    const date = new Intl.DateTimeFormat("en-US", {
        timeZone: "America/New_York",
        year: "numeric",
        month: "2-digit",
        day: "2-digit",
    }).format(new Date() - ONE_DAY_MS );
      
    //CONVERT TO YYYY-MM-DD
    const dateArray = date.split("/")
    const dateString = dateArray[2] + "-" + dateArray[0] + "-" + dateArray[1];
    
    return dateString;
}


  
  




    // Calculate the winner based on the percentage change
    






