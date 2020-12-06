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

        let payload : admin.messaging.MessagingPayload = {
            notification: {
                "title": " ",
            },
            data: {
                
                "content": JSON.stringify({
                    "id": 100,
                    "channelKey": "basic_channel",
                    "title": newData ? newData.name : "Title",
                    "body": newData ? newData.text : "Body",
                    "notificationLayout": "Default",
                    "showWhen": true,
                    "autoCancel": true,
                    "privacy": "Private",
                    "payload": {
                        "senderId":paths[3],
                        "receiverId": paths[5],
                        "isTeacher": newData ? newData.isTeacher : true,
                        "type": "PersonalChatMessage",
                        "receiverName": newData?newData.name:" ",
                        "senderName": t ? t["first name"] + " " + t["last name"] : " ",
                        "senderUrl": t ? t['url'] : "",
                        "receiverUrl":newData?newData.url:" ",
                    },
                }),
                "actionButtons": JSON.stringify([
                    {
                        "key": "REPLY",
                        "label": "Reply",
                        "autoCancel": true,
                        "buttonType":  "InputField",
                    },
                    {
                        "key": "ARCHIVE",
                        "label": "Archive",
                        "autoCancel": true,
                    },
                ]),
                "schedule": JSON.stringify({
                    "initialDateTime": "2020-08-30 11:00:00",
                    "crontabSchedule": "5 38 20 ? * MON-FRI *",
                    "allowWhileIdle": true,
                    "preciseSchedules": [],
                }),
    },
           
        };
        try {
            if (newData) {
                if (newData.fromId != paths[3]) {
                    await admin.messaging().sendToDevice([token], payload);
                    console.log(payload);
                    console.log('****NOTIFICATION SEND****');
                }
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
        let payload: admin.messaging.MessagingPayload = {
            notification: {
                "title": " ",
            },
            data: {
                
                "content": JSON.stringify({
                    "id": 101,
                    "channelKey": "basic_channel",
                    "title": newData ? newData.name : "Title",
                    "body": newData ? newData.text : "Body",
                    "notificationLayout": "Default",
                    "showWhen": true,
                    "autoCancel": true,
                    "privacy": "Private",
                    "payload": {
                        "senderId":paths[3],
                        "receiverId": paths[5],
                        "isTeacher": newData ? newData.isTeacher : true,
                        "type": "PersonalChatMessage",
                        "receiverName": newData?newData.name:"",
                        "senderName": t ? t["first name"] + " " + t["last name"] : "",
                        "senderUrl": t ? t['url'] : "",
                        "receiverUrl":newData?newData.url:"",
                        },
                }),
                "actionButtons": JSON.stringify([
                    {
                        "key": "REPLY",
                        "label": "Reply",
                        "autoCancel": true,
                        "buttonType":  "InputField",
                    },
                    {
                        "key": "ARCHIVE",
                        "label": "Archive",
                        "autoCancel": true,
                    },
                ]),
                "schedule": JSON.stringify({
                    "initialDateTime": "2020-08-30 11:00:00",
                    "crontabSchedule": "5 38 20 ? * MON-FRI *",
                    "allowWhileIdle": true,
                    "preciseSchedules": [],
                }),
    },
           
        };
        try {
            if (newData) {
                if (newData.fromId!=paths[3]) {
                    const response = await admin.messaging().sendToDevice([token], payload);
                    console.log(payload);
                    console.log(response);
                    console.log('****NOTIFICATION SEND****');
                }
            }

        } catch (error) {
            console.log("error $error");
            console.log(error);
        }

    } else {
        console.log('Data Deleted');
    }

});

export const GroupChatMessageNotification = functions.firestore.document('School/{schoolCode}/GroupChats/{groupId}/ChatMessages/{messageDocId}').onWrite(async (change, context) => {
    const snapshot = change.after;
    if (snapshot) {
        const newData = snapshot.data();
        const paths = snapshot.ref.path.split('/');
        let t = await admin.firestore().doc(paths[0] + '/' + paths[1] + '/' + paths[2] + '/' + paths[3]).get().then((d)=>d.data());
            let payload: admin.messaging.MessagingPayload = {
                notification: {
                    "title": " ",
                },
                data: {
                
                    "content": JSON.stringify({
                        "id": 102,
                        "channelKey": "basic_channel",
                        "title": t ? (newData?newData.name+' @ '+t['Name']:'') : "",
                        "body": newData ? newData.text : "Body",
                        "notificationLayout": "Default",
                        "showWhen": true,
                        "autoCancel": true,
                        "privacy": "Private",
                        "payload": {
                            "collectionId": snapshot.ref.parent.path,
                            "senderId": newData ? newData.fromId:"",
                            "isTeacher":newData?newData.isTeacher:"",
                            "type":"GroupChatMessage",
                        },
                        
                    }),
                    "actionButtons": JSON.stringify([
                        {
                            "key": "REPLY",
                            "label": "Reply",
                            "autoCancel": true,
                            "buttonType": "InputField",
                        },
                        {
                            "key": "ARCHIVE",
                            "label": "Archive",
                            "autoCancel": true,
                        },
                    ]),
                    "schedule": JSON.stringify({
                        "initialDateTime": "2020-08-30 11:00:00",
                        "crontabSchedule": "5 38 20 ? * MON-FRI *",
                        "allowWhileIdle": true,
                        "preciseSchedules": [],
                    }),
                },
           
            };
            try {
                if (newData) {
                    if (newData.type == "text") {
                        await admin.messaging().sendToTopic(paths[3], payload);
                        console.log('****NOTIFICATION SEND****');
                    }
                }
            } catch (error) {
                console.log(error);
            }

        } else {
            console.log('Data Deleted');
        }

});

export const DiscussionsNotifications = functions.firestore
    .document('School/{schoolCode}/Classes/{csecsub}/Discussions/{doc}').onWrite(async (change, context)=>{
    
        const snapshot = change.after;
        if (snapshot) {
            const newData = snapshot.data();
            const paths = snapshot.ref.path.split('/');
            const cssId = paths[3].split('_');
                let payload: admin.messaging.MessagingPayload = {
                    notification: {
                        "title": " ",
                    },
                    data: {
                    
                        "content": JSON.stringify({
                            "id": 103,
                            "channelKey": "basic_channel",
                            "title": cssId[0]+" "+cssId[1]+" "+cssId[2]+" Discussion",
                            "body": newData ? newData.text : "Body",
                            "notificationLayout": "Default",
                            "showWhen": true,
                            "autoCancel": true,
                            "privacy": "Private",
                            "payload": {
                                "collectionId": snapshot.ref.parent.path,
                                "senderId": newData ? newData.fromId:"",
                                "isTeacher":newData?newData.isTeacher:"",
                                "type":"DiscussionChatMessage",
                            },
                            
                        }),
                        "actionButtons": JSON.stringify([
                            {
                                "key": "REPLY",
                                "label": "Reply",
                                "autoCancel": true,
                                "buttonType": "InputField",
                            },
                            {
                                "key": "ARCHIVE",
                                "label": "Archive",
                                "autoCancel": true,
                            },
                        ]),
                        "schedule": JSON.stringify({
                            "initialDateTime": "2020-08-30 11:00:00",
                            "crontabSchedule": "5 38 20 ? * MON-FRI *",
                            "allowWhileIdle": true,
                            "preciseSchedules": [],
                        }),
                    },
            
                };
                try {
                    if (newData) {
                        await admin.messaging().sendToTopic(paths[1]+'_'+paths[3], payload);
                        console.log('****NOTIFICATION SEND****');
                    }
                } catch (error) {
                    console.log(error);
                }

        } else {
            console.log('Data Deleted');
        }
});