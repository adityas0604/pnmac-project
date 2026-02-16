// backend/db/putItem.js
import { PutCommand, QueryCommand } from "@aws-sdk/lib-dynamodb";
import { getDdb } from "./dynamoClient.js";


/**
 * Generic DynamoDB insert wrapper around PutCommand
 *
 * @param {Object} params
 * @param {string} params.tableName - DynamoDB table name
 * @param {Object} params.item - The item to insert
 * @param {string} [params.condition] - Optional ConditionExpression
 */
export async function addItem(params) {
  
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
    ...(params.condition && { ConditionExpression: params.condition }),
    ...(params.expressionAttributeNames && { ExpressionAttributeNames: params.expressionAttributeNames }),
  };

  const command = new PutCommand(params);

  return ddb.send(command);
}

export const queryItems = async (params) => {
  const ddb = getDdb();

  const makeParams = {
    TableName: params.table,
    ...(params.condition && { KeyConditionExpression: params.condition }),
    ...(params.attributeNames && { ExpressionAttributeNames: params.attributeNames }),
    ...(params.attributeValues && { ExpressionAttributeValues: params.attributeValues }),
    ScanIndexForward: params.order === "desc" ? false : true,
  };
  

  const command = new QueryCommand(makeParams);
  const result = await ddb.send(command);

  return result.Items ?? [];
};
