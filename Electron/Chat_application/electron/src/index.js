const {app, BrowserWindow, ipcMain, protocol} = require('electron')
const path = require('path')
const url = require('url')


////////////
// import * as firebase from "firebase";
// import 'firebase/messaging';
// var config = {
//   apiKey: "AIzaSyDCxZHbRWDm4bqXc3x7trSXQcnqsl0rWJk",
//   authDomain: "chat-for-english.firebaseapp.com",
//   databaseURL: "https://chat-for-english.firebaseio.com",
//   projectId: "chat-for-english",
//   storageBucket: "chat-for-english.appspot.com",
//   messagingSenderId: "940911766248"
// };
// firebase.initializeApp(config);

///////

//const setAppMenu = require("./src/setAppMenu");


// Keep a global reference of the window object, if you don't, the window will
// be closed automatically when the JavaScript object is garbage collected.
let win
var win_quit = false
let child_win = {
  chat_room : []
};
let user
let students
let messagesCount

var shouldQuit = app.makeSingleInstance((commandLine, workingDirectory)=>{
  if(win){
    if(win.isMinimized()) win.restore();
    win.focus();
  }
});

if(shouldQuit){
  app.quit();
  
}

function createWindow () {
  // Create the browser window.

  console.log("check point");
  win = new BrowserWindow({width: 450, height: 800,resizable: false, 
     webPreferences: {backgroundThrottling: true}})

  // and load the index.html of the app.
  win.loadURL(url.format({
    pathname: path.join(__dirname, '../public/index.html'),
    protocol: 'file:',
    slashes: true
  }))
  
  // Open the DevTools.
  //win.webContents.openDevTools()

  // Emitted when the window is closed.
  win.on('close', (event) => {
    // Dereference the window object, usually you would store windows
    // in an array if your app supports multi windows, this is the time
    // when you should delete the corresponding element.
    if(process.platform === 'darwin'){
      if(win_quit){
        child_win.chat_room.forEach((e)=>{
          e.close()
        })
        win = null
      }else{
        event.preventDefault()
        win.hide()
      }
    }else{
      child_win.chat_room.forEach((e)=>{
        e.close()
      })
      win = null
    }
    
    
  })
}

// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
// Some APIs can only be used after this event occurs.
app.on('ready', ()=>{
  //setAppMenu();
  // firebase.messaging().requestPermission()
  //   .then(()=>{
  //     console.log('Notification granted')
  //     firebase.messaging().getToken().then((token)=>{
  //       console.log(token)
  //       console.log('토큰 받음')
  //     }).catch((err)=>{
  //       console.log('토큰 없음')
  //     })
  //   })
  //   .catch((err)=>{
  //     console.log('permission error')
  //     console.log(err)
  //   })
  
  createWindow();

})

// Quit when all windows are closed.
app.on('window-all-closed', () => {
  // On macOS it is common for applications and their menu bar
  // to stay active until the user quits explicitly with Cmd + Q

  if (process.platform !== 'darwin') {
    app.quit()
  }
});

app.on('before-quit', ()=>{

  if(process.platform === 'darwin'){
    win_quit = true
  }
  
})
app.on('activate', () => {
  // On macOS it's common to re-create a window in the app when the
  // dock icon is clicked and there are no other windows open.
  if (win === null) {
    createWindow()
  }else{
    win.show()
  }
  
});

/////////////// server //



ipcMain.on('test01', (event, arg)=>{
  event.sender.send('test02', 'powpow');
})
/////////////////////
ipcMain.on('onResultLogin',(event, arg) =>{
  event.sender.send('onHandleLoadMyInfo')
})

ipcMain.on('onResultLoadMyInfo',(event, arg) =>{
  user = {
    id : arg.id,
    email : arg.email,
    username : arg.username,
    password : arg.password,
    type : arg.type,
    profileImageUrl : arg.profileImageUrl
  }
  
  event.sender.send('onHandleLoadStudentsList') 
})


ipcMain.on('onResultLoadStudentsList',(event, arg) =>{

  students = []

  
  arg.forEach((value, index, array)=>{

    students.push({
      id: value.id,
      username: value.username,
      type: value.type,
      profileImageUrl: value.profileImageUrl
    })
  })

  event.sender.send('onHandleMoveMainPage') 
})

ipcMain.on('onResultLoadMyInfo',(event, arg) =>{
  user = {
    id : arg.id,
    email : arg.email,
    username : arg.username,
    password : arg.password,
    type : arg.type,
    profileImageUrl : arg.profileImageUrl
  }
  
  event.sender.send('onHandleLoadStudentsList') 
})
ipcMain.on('onResultSignUp', (event, arg) => {
  event.sender.send('onHandleUpdateMyInfo')
  
})
ipcMain.on('onResultUpdateMyInfo', (event, arg) => {
  event.sender.send('onHandleLoadStudentsList')
})
///////////////////////////

ipcMain.on('onRequestStudentsList', (event,arg) => {

  event.sender.send('onSendStudentsList', students)
})

ipcMain.on('onRequestMyInfo', (event, arg) => {
  event.sender.send('onSendMyInfo', user)
})

ipcMain.on('onHandleSignOut', (event, arg) => {
  child_win.chat_room.forEach((e)=>{
    e.close()
  })
  event.sender.send('onResultSignOut')
})
/////////
////// Chat Room Message
ipcMain.on('sendMessagesCount', (event, arg) =>{
  messagesCount = arg;
  console.log("msg Count " + messagesCount);
})
ipcMain.on('receiveOneMessage',(event, arg)=>{
  messagesCount -= 1;
  if(messagesCount == 0){
    event.sender.send('onFinishReceiveMessages');
  }
})

ipcMain.on('onRequestMakeChatRoom', (event, arg) => {
  let index = child_win.chat_room.findIndex((e)=>{
    return e.tag == arg.room_id
  })
  if(index < 0){
    var chatwin  = new BrowserWindow({
      width: 450, height: 800, 
      show: false,
      resizable: false,
      webPreferences: {backgroundThrottling: true}})
  
    // and load the index.html of the app.
    chatwin.loadURL(url.format({
      pathname: path.join(__dirname, '../public/chat.html'),
      protocol: 'file:',
      slashes: true
    }))
  
    // Open the DevTools.
    //chatwin.webContents.openDevTools()
    
    // Emitted when the window is closed.
    chatwin.on('close', () => {
      // Dereference the window object, usually you would store windows
      // in an array if your app supports multi windows, this is the time
      // when you should delete the corresponding element.
      child_win.chat_room.splice(child_win.chat_room.findIndex((e)=>{
        return e.tag == chatwin.tag
      }),1)
      chatwin = null
    })
  
    chatwin.once('ready-to-show',()=>{
      chatwin.show();
      chatwin.webContents.send('onResultMakeChatRoom',arg)
    })
  
    chatwin.tag = arg.room_id
  
    child_win.chat_room.push(chatwin)
  }else{
    child_win.chat_room[index].focus()
  }
  
  
  console.log(child_win.chat_room)
})
ipcMain.on('onFinishChatRoom',(event,arg)=>{
  
  var chatroom = child_win.chat_room.find((e)=>{
    return e.tag == arg.roomId
  })
  chatroom.close()

})
export default createWindow;
//module.exports = createWindow;