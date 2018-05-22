import React from 'react';
import ReactDOM from 'react-dom';
import {Route, Switch, BrowserRouter, Redirect, MemoryRouter} from 'react-router-dom'
import 'normalize.css/normalize.css';
import './styles/styles.scss';
import * as firebase from "firebase";
import createBrowserHistory from 'history/createBrowserHistory';
import LoginRegister from "./components/Login_Register"
import MainPage from "./components/Main_Page"
import ChatRoom from "./components/ChatRoom"
import UserProfile from "./components/UserProfile"
import { ipcRenderer, ipcMain } from 'electron';

//history.push("/login");
const AppRouter = () => (
    <MemoryRouter initialEntries={['/login']}>
      <div>
        <Switch>
            {/* <Route path="/" exact={true} render={()=>(
                <Redirect to="/login"/>
            )}/> */}
            {/* <Route path="/" component={Login} exact={true}/> */}
            <Route path="/login" component={LoginRegister} />
            <Route path="/main" component={MainPage}/>
            <Route path="/chatroom/:id" component={ChatRoom}/>
            <Route path="/userprofile" component={UserProfile}/>
        </Switch>
      </div>
    </MemoryRouter>
  );

  var config = {
    apiKey: "AIzaSyDCxZHbRWDm4bqXc3x7trSXQcnqsl0rWJk",
    authDomain: "chat-for-english.firebaseapp.com",
    databaseURL: "https://chat-for-english.firebaseio.com",
    projectId: "chat-for-english",
    storageBucket: "chat-for-english.appspot.com",
    messagingSenderId: "940911766248"
  };
  firebase.initializeApp(config);
  
console.log("test!!!")

ReactDOM.render(<AppRouter />, document.getElementById('app'));

ipcRenderer.once("onResultMakeChatRoom",(event, arg)=>{

  console.log(arg)
  console.log("work herererer")
  ReactDOM.render(<ChatRoom />, document.getElementById('app'))
})
