const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

export const withRetry = (fn, {
  retries = 1,
  delayMs = 60_000,
  shouldRetry = () => true,
} = {}) => {
  return async (...args) => {

    let lastErr;

    for (let attempt = 0; attempt <= retries; attempt++) {
      try {
        return await fn(...args);
      } catch (err) {
        lastErr = err;

        const canRetry = attempt < retries && shouldRetry(err);

        if (!canRetry) {
          throw err;
        }

        await sleep(delayMs);
      }
    }

    throw lastErr;
  };
};
