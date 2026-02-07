// backend/db/putItem.js
import { PutCommand } from "@aws-sdk/lib-dynamodb";
import { getDdb } from "./dynamoClient.js";

/**
 * Generic DynamoDB insert wrapper around PutCommand
 *
 * @param {Object} params
 * @param {string} params.tableName - DynamoDB table name
 * @param {Object} params.item - The item to insert
 * @param {string} [params.condition] - Optional ConditionExpression
 */
export async function addItem({ tableName, item, condition, expressionAttributeNames }) {
  if (!tableName) {
    throw new Error("tableName is required");
  }
  if (!item || typeof item !== "object") {
    throw new Error("item must be a non-null object");
  }

  const ddb = getDdb();

  const params = {
    TableName: tableName,
    Item: item,
  };

  if (condition) {
    params.ConditionExpression = condition;
  }
  
  if (expressionAttributeNames) {
    params.ExpressionAttributeNames = expressionAttributeNames;
  }

  const command = new PutCommand(params);

  return ddb.send(command);
}
