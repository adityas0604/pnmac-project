import { loadSecrets } from './secrets.js';

const secrets = await loadSecrets();

export const WATCHLIST = ["AAPL", "MSFT", "GOOGL", "AMZN", "TSLA", "NVDA"];
export const WINNER_TABLE = 'ticker-winner';

export const MASSIVE_API_KEY = secrets.MASSIVE_API_KEY;

