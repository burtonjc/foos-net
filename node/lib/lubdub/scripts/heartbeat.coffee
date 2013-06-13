heartRate = process.env.heartrate ? 1000
setInterval ->
  process.send
    type: 'heartbeat'
    processId: process.id
    timestamp: Date.now()
, heartRate
  
