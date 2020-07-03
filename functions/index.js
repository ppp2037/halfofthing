

const functions = require('firebase-functions')
const admin = require('firebase-admin')
admin.initializeApp()

exports.sendNotification = functions
  .region('asia-northeast1')
  .firestore
  .document('board/{notice_board}/{messages}/{message}')
  .onCreate((snap, context) => {
    console.log('----------------start function--------------------')

    const doc = snap.data()
    console.log(doc)

    const idFrom = doc.idFrom
    const idTo = doc.idTo
    const contentMessage = doc.text

    // Get push token user to (receive)
    admin
      .firestore()
      .collection('users')
      .where('id', '==', idTo)
      .get()
      .then(querySnapshot => {
        return querySnapshot.forEach(userTo => {
          console.log(`Found user to: ${userTo.data().nickname}`)
          if (userTo.data().pushToken && userTo.data().chattingWith !== idFrom) {
            // Get info user from (sent)
            admin
              .firestore()
              .collection('users')
              .where('id', '==', idFrom)
              .get()
              .then(querySnapshot2 => {
                return querySnapshot2.forEach(userFrom => {
                  console.log(`Found user from: ${userFrom.data().nickname}`)
                  const payload = {
                    notification: {
                      title: `${userFrom.data().nickname}`,
                      body: contentMessage,
                      badge: '1',
                      sound: 'default'
                    }
                  }
                  // Let push to the target device
                  admin
                    .messaging()
                    .sendToDevice(userTo.data().pushToken, payload)
                    .then(response => {
                      return console.log('Successfully sent message:', response)
                    })
                    .catch(error => {
                      console.log('Error sending message:', error)
                    })
                })
              }).catch(() => null)
          } else {
            console.log('Can not find pushToken target user')
          }
        })
      }).catch(() => null)
    return null
  })