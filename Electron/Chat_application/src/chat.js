import React from 'react';
import ReactDOM from 'react-dom';
import {Route, Switch, BrowserRouter, Redirect, MemoryRouter} from 'react-router-dom'
import 'normalize.css/normalize.css';
import './styles/styles.scss';

import * as firebase from "firebase";
import createBrowserHistory from 'history/createBrowserHistory';

import ChatRoom from "./components/ChatRoom"
import { ipcRenderer, ipcMain } from 'electron';



  var config = {
    apiKey: "AIzaSyDCxZHbRWDm4bqXc3x7trSXQcnqsl0rWJk",
    authDomain: "chat-for-english.firebaseapp.com",
    databaseURL: "https://chat-for-english.firebaseio.com",
    projectId: "chat-for-english",
    storageBucket: "chat-for-english.appspot.com",
    messagingSenderId: "940911766248"
  };
  firebase.initializeApp(config);
  


ReactDOM.render(<ChatRoom />, document.getElementById('app'))

