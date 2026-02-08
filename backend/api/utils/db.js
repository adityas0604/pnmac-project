// backend/services/moversService.js
import { queryItems } from "../../shared/dbClient.js";
import { getLastNTradingDays } from "../../shared/helpers.js";

export const getLastNDaysMovers = async (n = 7) => {
  const tradingDates = getLastNTradingDays(n);
 
  const startDate = tradingDates[tradingDates.length - 1]; 
  const endDate = tradingDates[0];

  const winners = await queryItems({
    table: "ticker-winner",
    condition: "#PK = :pk AND #d BETWEEN :start AND :end",
    attributeNames: {
      "#d": "Date",
      "#PK": "PK",
    },
    attributeValues: {
      ":start": startDate,
      ":end": endDate,
      ":pk": "WINNER",
    },
    order: "desc", // newest first
  });

  return winners.map(item => {
    delete item.PK;
    return item;
  });

};

