import { useEffect, useState } from "react";
import { getMoversMock } from "../api/movers.js";
import MoversTable from "../components/MoversTable";

function App() {
  const [rows, setRows] = useState([]);
  const [status, setStatus] = useState("loading"); // loading | success | error
  const [error, setError] = useState("");

  useEffect(() => {
    let alive = true;

    (async () => {
      try {
        setStatus("loading");
        setError("");
        const data = await getMoversMock();
        if (!alive) return;
        setRows(data);
        setStatus("success");
      } catch (e) {
        if (!alive) return;
        setError(e?.message ?? "Unknown error");
        setStatus("error");
      }
    })();

    return () => {
      alive = false;
    };
  }, []);

  return (
    <div className="min-h-screen bg-slate-950 text-slate-100">
      <div className="w-full px-6 py-10">   
        <div className="mb-6">
          <h1 className="text-2xl font-semibold tracking-tight">
            Stock Winners (Last 7 Days)
          </h1>
        </div>
  
        {status === "loading" && (
          <div className="rounded-xl border border-white/10 bg-slate-900/40 p-4 text-slate-300">
            Loading…
          </div>
        )}
  
        {status === "error" && (
          <div className="rounded-xl border border-red-500/30 bg-red-950/20 p-4">
            <div className="font-semibold text-red-200">Couldn’t load movers</div>
            <div className="mt-1 text-sm text-red-200/80">{error}</div>
          </div>
        )}
  
        {status === "success" && <MoversTable rows={rows} />}
      </div>
    </div>
  );
  
}

export default App;
