
// backend/db/winnerRepo.js
import { addItem } from "../../shared/dbClient.js";
import { WINNER_TABLE } from "../../shared/variables.js";


export async function insertWinnerData(winner) {
  if (!winner?.Date) {
    throw new Error("winner.date is required");
  }

  const item = {
    PK: "WINNER",
    ...winner
  };

  await addItem({
    tableName: WINNER_TABLE,
    item: item,
  });

  return item;
}

