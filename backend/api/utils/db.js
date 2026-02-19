// backend/services/moversService.js
import { queryItems } from "../../shared/dbClient.js";
import { getLastNTradingDays } from "../../shared/helpers.js";

export const getLastNDaysMovers = async (n = 7) => {

  let daysToRetrive = n + 1; // +1 to include the inclusivity of the last day
  let winners = [];

  while (winners.length < n) {
    const tradingDates = getLastNTradingDays(daysToRetrive);
  
    const startDate = tradingDates[tradingDates.length - 1]; 
    const endDate = tradingDates[0];

    winners = await queryItems({
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
    daysToRetrive++;
  }

  return winners.map(({ PK, Open, Close, ...rest }) => {
    //  convert cents → dollars
    return {
      ...rest,
      Open: Open / 1000,
      Close: Close / 1000,
    };
  });

};

