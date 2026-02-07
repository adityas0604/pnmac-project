import { ingestWinner } from './utils/ingestWinner.js';


export const ingestDailyWinnerCron = async () => {
    try {
        const result = await ingestWinner();
        console.log(result);
    } catch (e) {
        console.error('An error happened:', e);
        throw e;
    }
}


