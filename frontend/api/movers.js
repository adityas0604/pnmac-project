
export async function getMoversMock() {
    // simulate network latency
    await new Promise((r) => setTimeout(r, 500));
  
   
    return [
      { date: "2026-02-09", ticker: "AAPL", percentChange: 2.31, close: 189.45 },
      { date: "2026-02-08", ticker: "NVDA", percentChange: -1.12, close: 720.12 },
      { date: "2026-02-07", ticker: "TSLA", percentChange: 3.84, close: 212.55 },
      { date: "2026-02-06", ticker: "AMZN", percentChange: -0.45, close: 168.20 },
      { date: "2026-02-05", ticker: "MSFT", percentChange: 1.07, close: 412.90 },
      { date: "2026-02-04", ticker: "GOOGL", percentChange: 0.26, close: 154.33 },
      { date: "2026-02-03", ticker: "AAPL", percentChange: -2.02, close: 185.12 },
    ];
  }
  