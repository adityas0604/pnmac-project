import { restClient } from '@massive.com/client-js';
import { withRetry } from '../../shared/retry.js';
import { getSecret } from '../../shared/secrets.js';


const MASSIVE_API_KEY_NAME = process.env.MASSIVE_API_KEY_NAME;
const apiKey = getSecret(MASSIVE_API_KEY_NAME);
const rest = restClient(apiKey, 'https://api.massive.com');

const _getStocksOpenClose = async (ticker, date) => {
    try {
      const response = await rest.getStocksOpenClose(
        {
          stocksTicker: ticker,
          date: date,
          adjusted: "true"
        }
      );
      console.log('Response:', response);
      return {
          ticker: ticker,
          open: response.open,
          close: response.close
      }
    } catch (e) {
      console.log('An error happened:', e);
      throw e;
    }
  }

export const getStocksOpenClose = withRetry(_getStocksOpenClose, {
  retries: 2,
  shouldRetry: (e) => {
    if (!e?.response) return false; 
    return (e.response.statusText === 'Too Many Requests' && e.response.status === 429) ||
           (e.response.status >= 500 && e.response.status < 599);
  }
});



