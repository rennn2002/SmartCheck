import * as functions from 'firebase-functions'
import { exportData } from './exportData'
const region = "asia-northeast1"

//Triggered when a group of bids is added to the bids collection.
// This will update a spreadsheet with history data in Google Drive.

// trigger when new data created function name "exportOrderData_create"
exports.exportOrderData_create = functions.region(region).firestore
    .document('data/{id}')
    .onCreate(async (snapshot, _) => {
        const healthData = snapshot.data();
        //const date = documentData.date.toDate().toLocaleString('en-US', { dateStyle: 'long', timeStyle: 'long' })
        
        const bodytemp = healthData.bodytemp.toFixed(1)
        const posttime = healthData.posttime.toDate().toLocaleString('ja-JP', { dateStyle: 'long', timeStyle: 'long' , timeZone: 'Asia/Tokyo'})
        const symptom = healthData.symptom
                
        const schoolid = healthData.schoolid
        const studentid = healthData.studentid
        const firstname = healthData.firstname
        const lastname = healthData.lastname
        
        const username = lastname + " " + firstname
        
        const mail = healthData.mail
        
        await exportData(posttime, schoolid, studentid, username, bodytemp, symptom, mail)
});

// trigger when data updated function name "exportOrderData_update"
exports.exportOrderData_update = functions.region(region).firestore
    .document('data/{id}')
    .onUpdate(async (change, _) => {
        const healthData = change.after.data();
        
        const bodytemp = healthData.bodytemp.toFixed(1)
        const posttime = healthData.posttime.toDate().toLocaleString('ja-JP', { dateStyle: 'long', timeStyle: 'long' , timeZone: 'Asia/Tokyo'})
        const symptom = healthData.symptom
                
        const schoolid = healthData.schoolid
        const studentid = healthData.studentid
        const firstname = healthData.firstname
        const lastname = healthData.lastname
        
        const username = lastname + " " + firstname
        
        const mail = healthData.mail

        await exportData(posttime, schoolid, studentid, username, bodytemp, symptom, mail)
});