import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';


admin.initializeApp(functions.config().functions);

// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript

export const helloWorld = functions.https.onRequest((request, response) => {
    response.send("Hello from Firebase!");
});

export const addStudent = functions.firestore.document('School/{SchoolId}/Student/{StudentId}').onCreate(async (snap, context) => {
    const paths = snap.ref.path.split('/');
    let count;
    await admin.firestore().doc(paths[0] + '/' + paths[1]).get().then((doc) => { count = doc.data(); });
    if (count) {
        if (!count['numberofstudents'])
            count = { 'numberofstudents': 0 };
    }
    else count = { 'numberofstudents': 0 };
    return admin.firestore().doc(paths[0] + '/' + paths[1]).set({ 'numberofstudents': (count.numberofstudents + 1) }, { merge: true });
});

export const addTeachers = functions.firestore.document('School/{SchoolId}/Teachers/{TeachersId}').onCreate(async (snap, context) => {
    const paths = snap.ref.path.split('/');
    let count;
    await admin.firestore().doc(paths[0] + '/' + paths[1]).get().then((doc) => { count = doc.data(); });
    if (count) {
        if (!count['numberofteachers'])
            count = { 'numberofteachers': 0 };
    }
    else count = { 'numberofteachers': 0 };
    return admin.firestore().doc(paths[0] + '/' + paths[1]).set({ 'numberofteachers': (count.numberofteachers + 1) }, { merge: true });
});


export const SchoolLoginVerification = functions.https.onCall((data, context) => {

    admin.firestore().collection('School').where('schoolemail', '==', data.email).where('password', '==', data.password).get()
        .then((doc) => {
            if (doc.empty)
                return { "Verified": "false" };
            else
                return { "Verified": "true" };
        })
        .catch(e => {
            console.log('ERROR In SchoolLoginVerification : ', e);
            return { "Verified": "false" };
        })

});

export const ChatMessageNotificationTeachers = functions.firestore.document('School/{schoolCode}/Teachers/{teachersId}/recentChats/{chatWithId}').onWrite(async (change, context) => {
    const snapshot = change.after;
    if (snapshot.exists) {
        const newData = snapshot.data();
        const paths = snapshot.ref.path.split('/');
        let token;

        let t = await admin.firestore().doc(paths[0] + '/' + paths[1] + '/' + paths[2] + '/' + paths[3]).get().then((doc) => {
            return doc.data();
        });
        if (t)
            token = t['deviceToken'];
        else
            console.log('t is empty');

        let payload = {
            notification: { title: newData ? newData.name : 'Title', body: newData ? newData.text : 'Body', tag: newData ? newData.name : 'Title', sound: 'enable' }, data: { click_action: 'FLUTTER_NOTIFICATION_CLICK', message: 'THe message' }

        };
        try {
            if (newData)
                if (newData.fromId != paths[3]) {
                    await admin.messaging().sendToDevice([token], payload);
                    console.log('****NOTIFICATION SEND****');
                }
        } catch (error) {
            console.log(error);

        }

    } else {
        console.log('Data Deleted');
    }

});


export const ChatMessageNotificationStudent = functions.firestore.document('School/{schoolCode}/Student/{studentId}/recentChats/{chatWithId}').onWrite(async (change, context) => {
    const snapshot = change.after;
    if (snapshot.exists) {
        const newData = snapshot.data();
        const paths = snapshot.ref.path.split('/');
        let token;

        let t = await admin.firestore().doc(paths[0] + '/' + paths[1] + '/' + paths[2] + '/' + paths[3]).get().then((doc) => {
            return doc.data();
        });
        if (t)
            token = t['deviceToken'];
        else
            console.log('t is empty');

        let payload = {
            notification: { title: newData ? newData.name : 'Title', body: newData ? newData.text : 'Cody', tag: newData ? newData.name : 'Title', sound: 'enable' }, data: { click_action: 'FLUTTER_NOTIFICATION_CLICK', message: 'THe message' }

        };
        try {
            const response = await admin.messaging().sendToDevice([token], payload);
            console.log(response);
            console.log('****NOTIFICATION SEND****');

        } catch (error) {
            console.log(error);

        }

    } else {
        console.log('Data Deleted');
    }

});