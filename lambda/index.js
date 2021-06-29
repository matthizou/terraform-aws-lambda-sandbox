var AWS = require('aws-sdk')
const reverse = require('lodash/reverse')
var dynamo = new AWS.DynamoDB.DocumentClient()

const TABLE_NAME = 'Articles'

exports.handler = async function (event) {
  const { payload } = event

  console.log('🐼 ', { event })
  // A small random block, to demonstrate use of 3rd party library - lodash in this case
  console.log('Using lodash')
  console.log('🐞', 'reverse([1,2,3,4,5,6]) ==>', reverse([1, 2, 3, 4, 5, 6]))

  // Display table data
  return dynamo
    .scan({
      TableName: TABLE_NAME,
    })
    .promise()
}
