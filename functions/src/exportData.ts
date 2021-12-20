//import * as functions from 'firebase-functions'

// Google Sheet
import { google } from 'googleapis'
const sheets = google.sheets('v4')

//load account information
const serviceAccount = require('../sheets_updater_service_account.json')

//google auth for google spreadsheet
const jwtClient = new google.auth.JWT({
    email: serviceAccount.client_email,
    key: serviceAccount.private_key,
    scopes: ['https://www.googleapis.com/auth/spreadsheets']
})

const jwtAuthPromise = jwtClient.authorize()

//exportData async func
export async function exportData(
    posttime: string,
    schoolid: number,
    studentid: number, 
    username: string,
    bodytemp: number,
    symptom: boolean,
    mail: string
) {
    const domain = mail.substr(mail.indexOf('@') + 1);
    if(domain == "marianna-u.ac.jp" ) {
        const finalData: Array<Array<any>> = []
        
        var answer = "いいえ"
        if(symptom == true) {
            answer = "はい"
        } else {
            answer = "いいえ"
        }
        
        finalData.push([posttime, schoolid, studentid, username, bodytemp, answer])

        await jwtAuthPromise
        await sheets.spreadsheets.values.append({
        auth: jwtClient,
        spreadsheetId: "1_a2psW-rvFeg17peFbqGWRk3bqdhstV0rsJulorxKBk",
        range: `シート1!A2:E2`,
        valueInputOption: 'RAW',
        requestBody: { values: finalData, majorDimension: "ROWS" }
        }, {})
    } else {
        console.log("unauthorised domain")
    }
}