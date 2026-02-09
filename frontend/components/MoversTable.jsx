// src/components/MoversTable.jsx

export default function MoversTable({ rows }) {
    const fmtPct = (n) => {
      const x = Number(n);
      if (Number.isNaN(x)) return "";
      const sign = x > 0 ? "+" : "";
      return `${sign}${x.toFixed(2)}%`;
    };
  
    const fmtMoney = (n) => {
      const x = Number(n);
      if (Number.isNaN(x)) return "";
      return `$${x.toFixed(2)}`;
    };
  
    return (
      <div className="overflow-hidden rounded-xl border border-white/10 bg-slate-900/40">
        <div className="overflow-auto">
          <table className="min-w-[720px] w-full">
            <thead className="bg-slate-900">
              <tr className="text-left text-xs uppercase tracking-wide text-slate-400">
                <th className="px-4 py-3">Date</th>
                <th className="px-4 py-3">Ticker</th>
                <th className="px-4 py-3 text-right">% Change</th>
                <th className="px-4 py-3 text-right">Close</th>
              </tr>
            </thead>
  
            <tbody className="divide-y divide-white/10">
              {rows.length === 0 ? (
                <tr>
                  <td className="px-4 py-6 text-sm text-slate-400" colSpan={4}>
                    No data.
                  </td>
                </tr>
              ) : (
                rows.map((r) => {
                  const pct = Number(r.PercentageChange);
                  const pctClass =
                    Number.isNaN(pct)
                      ? "text-slate-300"
                      : pct > 0
                      ? "text-emerald-400"
                      : pct < 0
                      ? "text-rose-400"
                      : "text-slate-300";
  
                  return (
                    <tr key={`${r.Date}-${r.Ticker}`} className="hover:bg-white/5">
                      <td className="px-4 py-3 text-sm text-slate-200">{r.Date}</td>
                      <td className="px-4 py-3 text-sm font-mono text-slate-200">
                        {r.Ticker}
                      </td>
                      <td
                        className={`px-4 py-3 text-right text-sm font-mono ${pctClass}`}
                      >
                        {fmtPct(r.PercentageChange)}
                      </td>
                      <td className="px-4 py-3 text-right text-sm font-mono text-slate-200">
                        {fmtMoney(r.Close)}
                      </td>
                    </tr>
                  );
                })
              )}
            </tbody>
          </table>
        </div>
      </div>
    );
  }
  