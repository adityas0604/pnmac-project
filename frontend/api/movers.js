import { VITE_BASE_URL } from "../config.js";

export async function fetchMovers() {
  const res = await fetch(`${VITE_BASE_URL}/movers`, {
    method: "GET"
  });

  if (!res.ok) {
    const text = await res.text().catch(() => "");
    throw new Error(`API error ${res.status}: ${text || res.statusText}`);
  }

  const data = await res.json();

  if (!Array.isArray(data)) {
    throw new Error("Unexpected response: expected an array");
  }

  console.log(data);

  return data;
}


