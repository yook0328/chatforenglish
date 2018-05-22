/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, {
/******/ 				configurable: false,
/******/ 				enumerable: true,
/******/ 				get: getter
/******/ 			});
/******/ 		}
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = 0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _require = __webpack_require__(1),
    app = _require.app,
    BrowserWindow = _require.BrowserWindow,
    ipcMain = _require.ipcMain,
    protocol = _require.protocol;

var path = __webpack_require__(2);
var url = __webpack_require__(3);

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
var win = void 0;
var win_quit = false;
var child_win = {
  chat_room: []
};
var user = void 0;
var students = void 0;
var messagesCount = void 0;

var shouldQuit = app.makeSingleInstance(function (commandLine, workingDirectory) {
  if (win) {
    if (win.isMinimized()) win.restore();
    win.focus();
  }
});

if (shouldQuit) {
  app.quit();
}

function createWindow() {
  // Create the browser window.

  console.log("check point");
  win = new BrowserWindow({ width: 450, height: 800, resizable: false,
    webPreferences: { backgroundThrottling: true } });

  // and load the index.html of the app.
  win.loadURL(url.format({
    pathname: path.join(__dirname, '../public/index.html'),
    protocol: 'file:',
    slashes: true
  }));

  // Open the DevTools.
  //win.webContents.openDevTools()

  // Emitted when the window is closed.
  win.on('close', function (event) {
    // Dereference the window object, usually you would store windows
    // in an array if your app supports multi windows, this is the time
    // when you should delete the corresponding element.
    if (process.platform === 'darwin') {
      if (win_quit) {
        child_win.chat_room.forEach(function (e) {
          e.close();
        });
        win = null;
      } else {
        event.preventDefault();
        win.hide();
      }
    } else {
      child_win.chat_room.forEach(function (e) {
        e.close();
      });
      win = null;
    }
  });
}

// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
// Some APIs can only be used after this event occurs.
app.on('ready', function () {
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
});

// Quit when all windows are closed.
app.on('window-all-closed', function () {
  // On macOS it is common for applications and their menu bar
  // to stay active until the user quits explicitly with Cmd + Q

  if (process.platform !== 'darwin') {
    app.quit();
  }
});

app.on('before-quit', function () {

  if (process.platform === 'darwin') {
    win_quit = true;
  }
});
app.on('activate', function () {
  // On macOS it's common to re-create a window in the app when the
  // dock icon is clicked and there are no other windows open.
  if (win === null) {
    createWindow();
  } else {
    win.show();
  }
});

/////////////// server //


ipcMain.on('test01', function (event, arg) {
  event.sender.send('test02', 'powpow');
});
/////////////////////
ipcMain.on('onResultLogin', function (event, arg) {
  event.sender.send('onHandleLoadMyInfo');
});

ipcMain.on('onResultLoadMyInfo', function (event, arg) {
  user = {
    id: arg.id,
    email: arg.email,
    username: arg.username,
    password: arg.password,
    type: arg.type,
    profileImageUrl: arg.profileImageUrl
  };

  event.sender.send('onHandleLoadStudentsList');
});

ipcMain.on('onResultLoadStudentsList', function (event, arg) {

  students = [];

  arg.forEach(function (value, index, array) {

    students.push({
      id: value.id,
      username: value.username,
      type: value.type,
      profileImageUrl: value.profileImageUrl
    });
  });

  event.sender.send('onHandleMoveMainPage');
});

ipcMain.on('onResultLoadMyInfo', function (event, arg) {
  user = {
    id: arg.id,
    email: arg.email,
    username: arg.username,
    password: arg.password,
    type: arg.type,
    profileImageUrl: arg.profileImageUrl
  };

  event.sender.send('onHandleLoadStudentsList');
});
ipcMain.on('onResultSignUp', function (event, arg) {
  event.sender.send('onHandleUpdateMyInfo');
});
ipcMain.on('onResultUpdateMyInfo', function (event, arg) {
  event.sender.send('onHandleLoadStudentsList');
});
///////////////////////////

ipcMain.on('onRequestStudentsList', function (event, arg) {

  event.sender.send('onSendStudentsList', students);
});

ipcMain.on('onRequestMyInfo', function (event, arg) {
  event.sender.send('onSendMyInfo', user);
});

ipcMain.on('onHandleSignOut', function (event, arg) {
  child_win.chat_room.forEach(function (e) {
    e.close();
  });
  event.sender.send('onResultSignOut');
});
/////////
////// Chat Room Message
ipcMain.on('sendMessagesCount', function (event, arg) {
  messagesCount = arg;
  console.log("msg Count " + messagesCount);
});
ipcMain.on('receiveOneMessage', function (event, arg) {
  messagesCount -= 1;
  if (messagesCount == 0) {
    event.sender.send('onFinishReceiveMessages');
  }
});

ipcMain.on('onRequestMakeChatRoom', function (event, arg) {
  var index = child_win.chat_room.findIndex(function (e) {
    return e.tag == arg.room_id;
  });
  if (index < 0) {
    var chatwin = new BrowserWindow({
      width: 450, height: 800,
      show: false,
      resizable: false,
      webPreferences: { backgroundThrottling: true } });

    // and load the index.html of the app.
    chatwin.loadURL(url.format({
      pathname: path.join(__dirname, '../public/chat.html'),
      protocol: 'file:',
      slashes: true
    }));

    // Open the DevTools.
    //chatwin.webContents.openDevTools()

    // Emitted when the window is closed.
    chatwin.on('close', function () {
      // Dereference the window object, usually you would store windows
      // in an array if your app supports multi windows, this is the time
      // when you should delete the corresponding element.
      child_win.chat_room.splice(child_win.chat_room.findIndex(function (e) {
        return e.tag == chatwin.tag;
      }), 1);
      chatwin = null;
    });

    chatwin.once('ready-to-show', function () {
      chatwin.show();
      chatwin.webContents.send('onResultMakeChatRoom', arg);
    });

    chatwin.tag = arg.room_id;

    child_win.chat_room.push(chatwin);
  } else {
    child_win.chat_room[index].focus();
  }

  console.log(child_win.chat_room);
});
ipcMain.on('onFinishChatRoom', function (event, arg) {

  var chatroom = child_win.chat_room.find(function (e) {
    return e.tag == arg.roomId;
  });
  chatroom.close();
});
exports.default = createWindow;
//module.exports = createWindow;

/***/ }),
/* 1 */
/***/ (function(module, exports) {

module.exports = require("electron");

/***/ }),
/* 2 */
/***/ (function(module, exports) {

module.exports = require("path");

/***/ }),
/* 3 */
/***/ (function(module, exports) {

module.exports = require("url");

/***/ })
/******/ ]);