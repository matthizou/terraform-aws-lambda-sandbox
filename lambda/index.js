var AWS = require('aws-sdk')
const reverse = require('lodash/reverse')
var dynamo = new AWS.DynamoDB.DocumentClient()

exports.handler = function (event, context, callback) {
  var operation = event.operation

  if (event.tableName) {
    event.payload.TableName = event.tableName
  }

  console.log('Using lodash 1')
  console.log(
    "reverse(['🐞', '🐁', '🐈', '🐕', '🦬']) ==>",
    reverse(['🐞', '🐁', '🐈', '🐕', '🦬']),
  )

  switch (operation) {
    case 'create':
      dynamo.put(event.payload, callback)
      break
    case 'read':
      dynamo.get(event.payload, callback)
      break
    default:
      callback('Unknown operation: ${operation}')
  }
}
