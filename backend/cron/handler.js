import { ingestWinner } from './utils/ingestWinner.js';


export const ingestDailyWinnerCron = async () => {
    try {
        const completeStocksData = await ingestWinner();
        console.log(completeStocksData);
    } catch (e) {
        console.error('An error happened:', e);
        throw e;
    }

}

ingestDailyWinnerCron()

