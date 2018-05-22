import React from 'react';
import { Link, hashHistory } from 'react-router-dom';

import path from 'path'
import Loading from "./Loading"
import { ipcRenderer } from 'electron';
import * as firebase from "firebase";

const selectedNav = {
    backgroundColor: "#0277BD",
    color: "#ffffff"
};
const deselectedNav = {
    backgroundColor: "white",
    color: "#0277BD"
};

const loginInputStyle = {
    paddingBottom: '4px',
    paddingTop: '4px',
    paddingLeft: '15px',
    borderBottom: '1px solid #c9c9c9',
    height: '100%'
}
const loginInputHiddenStyle = {
    padding: 0,
    height : 0,
    border : 'none'
}

export default class LoginRegister extends React.Component{
    constructor(props){
        super(props);
        this.state = {
            email: localStorage.email || "",
            username: localStorage.username || "",
            password: localStorage.password || "",
            loginOrReg: true,
            isLoading: false,
            errors: [],
            id: "",
            profileImageUrl:"",
            type: ""
        };

        this.handleOnRegister = this.handleOnRegister.bind();

        ipcRenderer.on('onHandleLoadMyInfo', (event, arg)=>{
            this.handleLoadMyInfo()
        })

        ipcRenderer.on('onHandleLoadStudentsList', (event, arg) => {
            this.handleLoadStudentsList()
        })
        ipcRenderer.on('onHandleMoveMainPage', (event, arg)=>{
            firebase.database().ref().off()
            this.props.history.push('/main')
        })
        ipcRenderer.on('onHandleUpdateMyInfo',(evnet, arg) => {
            this.handleOnUpdateMyInfo()
        })



    }
    handleOnLoginOrRegisterNav(item, e){
        this.setState({
            loginOrReg : (item == 'Login') ? true : false 
        });
    }
    
    handleOnChangeEmail(e){
        
        this.setState({email: e.target.value});
    }
    handleOnChangeUsername(e){
        
        this.setState({username: e.target.value});
    }
    handleOnChangePassword(e){

        this.setState({password: e.target.value});
    }
    handleOnEnterPw(e){
        // console.log(e.key + ' event!!');
        // console.log(this.state)
        if(e.key =='Enter'){

            if(!this.state.loginOrReg){
                this.handleOnRegister(this.state);
            }else{
                this.handleOnLogin(this.state);
            }
            
        }
    }
    handleOnSubmit(e){
        if(!this.state.loginOrReg){
            this.handleOnRegister(this.state);
        }else{
            this.handleOnLogin(this.state);
        }
    }
    handleLoadStudentsList = () => {
        var query = firebase.database().ref('/Users').orderByChild('type').equalTo('student');

        query.once('value',(snapshot, error)=>{


            var data = [] 
            snapshot.forEach((childsnapshot)=>{
                let tmp = childsnapshot.val()
                data.push({
                    id: tmp.id,
                    username: tmp.username,
                    profileImageUrl: tmp.profileImageUrl,
                    type: tmp.type
                })
            })

            ipcRenderer.send('onResultLoadStudentsList', data)
        })
    }
    handleLoadMyInfo = () => {
        firebase.database().ref().child('Users').child(this.state.id).once('value',(snapshot)=>{
            var result = snapshot.val()
            this.setState({
                profileImageUrl: result.profileImageUrl,
                type : result.type
            })
            ipcRenderer.send('onResultLoadMyInfo',this.state)

        },(error)=>{
            console.log(error)
            this.setState({isLoading: false})
        })
    }
    handleOnLogin = (state) =>{
        if(state.email == '' || state.password == ''){
            return
        }
        firebase.database().ref().child('notifications').set({
            test : "key"
        }, (error)=>{
            
        })
        const {email, password } = state
        this.setState({isLoading: true})
        
        localStorage.email = email;
        localStorage.password = password;
        firebase.auth().signInWithEmailAndPassword(email, password).then((user)=>{

            this.setState({
                id : user.uid,
                email: email,
                password: password
            })
            //this.props.history.push("/main")
                ipcRenderer.send('onResultLogin')
            }).catch((error)=>{
                this.setState({isLoading: false})
                console.log(error)
        })
    }
    handleOnRegister = (state) => {
        if(state.email == '' || state.password == '' || state.username == ''){
            return
        }
        this.setState({isLoading: true})
        const {email, password } = state
        firebase.auth().createUserWithEmailAndPassword(email, password).then((user)=>{
            let uid = user.uid
            this.setState({
                id: uid
            })
            localStorage.email = email
            localStorage.password = password            
            ipcRenderer.send('onResultSignUp')
        })
        .catch((error) => {
            // Handle Errors here.
            console.log(error)
            this.setState({
                isLoading: false
            })
        });

    }
    handleOnUpdateMyInfo = () => {
        firebase.database().ref().child('Users').child(this.state.id).update({
            id: this.state.id,
            username: this.state.username,
            email: this.state.email,
            profileImageUrl: 'default',
            type: 'Mentor'
        },(error) => {
            if(error != ''){
                console.log(error)
                this.setState({
                    isLoading : false
                })
            }

            ipcRenderer.send('onResultUpdateMyInfo')
        })
    }
    render(){
        return(
            <div className="login_register_main_container">
                <Loading isLoading={this.state.isLoading}/>
                
                <div className="login_register_nav_container">
                    <span className="login_nav" style={this.state.loginOrReg? selectedNav : deselectedNav} onClick = {this.handleOnLoginOrRegisterNav.bind(this, 'Login')}>Login</span>
                    <span className="reg_nav" style={this.state.loginOrReg? deselectedNav : selectedNav} onClick = {this.handleOnLoginOrRegisterNav.bind(this, 'Register')}>Register</span>
                </div>
                <form className="login_register_form_container">
                    <input
                        type="email"
                        className="login_form_control_email"
                        placeholder="email"
                        onChange={this.handleOnChangeEmail.bind(this)}
                        value={this.state.email}
                    />
                    <input
                        type="text"
                        className="login_form_control_username"
                        placeholder="username"
                        disabled={this.state.loginOrReg}
                        onChange={this.handleOnChangeUsername.bind(this)}
                        style={this.state.loginOrReg ? loginInputHiddenStyle : loginInputStyle}
                        value={this.state.username}
                    />
                    <input
                        type="password"
                        className="login_form_control_password"
                        placeholder="password"
                        onChange={this.handleOnChangePassword.bind(this)}
                        value={this.state.password}
                        onKeyUp={this.handleOnEnterPw.bind(this)}
                    />
                    
                </form>
                <button className="submit_btn" onClick={this.handleOnSubmit.bind(this)}>{this.state.loginOrReg ? 'Login':'Register'}</button>
            </div>
        );
    }
}

