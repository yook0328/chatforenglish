import React from 'react';
import { Link, hashHistory } from 'react-router-dom';
import * as firebase from "firebase";
import path from 'path'

import { ipcRenderer, ipcMain } from 'electron';

 
export default class UserProfile extends React.Component{
    constructor(props){
        super(props);

        console.log(this.props.location.state)

        this.state = {
            id : this.props.location.state.id,
            user_id : this.props.location.state.user_id,
            username : this.props.location.state.username,
            profileImageUrl : this.props.location.state.profileImageUrl
        }
    }
    componentDidMount(){
        var header = document.getElementsByClassName("userprofile_header");

        let height = header[0].clientHeight;
        let width = header[0].clientWidth;
        let space = 5;
        var back = document.getElementsByClassName("userprofile_back_button_container");
        back[0].style.height = height - 2*space + "px";
        back[0].style.width = height - 2*space + "px";
    }
    handleMakeRoom = () =>{

        
        let roomRef = firebase.database().ref().child('rooms').push()
        var timestamp = firebase.database.ServerValue.TIMESTAMP
        roomRef.update({
            timestamp: timestamp,
            student: this.state.user_id,
            mentor: this.state.id
        },(error)=>{
            if(error != null){
                console.log(error)
                    return
            }
            firebase.database().ref().child('user-rooms').child(this.state.user_id).child(roomRef.key).update({
                timestamp:timestamp,
                mentor: this.state.id,
                isFinish: false
            },(error)=>{
                if(error != null){
                    console.log(error)
                    return
                }
                firebase.database().ref().child('user-rooms').child(this.state.id).child(roomRef.key).update({
                    timestamp: timestamp,
                    student: this.state.user_id,
                    isFinish: false
                },(error)=>{
                    if(error != null){
                        console.log(error)
                        return;
                    }
                    var msgRef = firebase.database().ref().child('messages').push()
                    msgRef.update({
                        fromId: this.state.id,
                        toId: this.state.user_id,
                        timestamp: timestamp,
                        type: 3,
                        text: "채팅이 시작되었습니다."
                    },(error)=>{
                        firebase.database().ref().child('user-messages').child(this.state.id)
                        .child(roomRef.key)
                        .child(msgRef.key)
                        .update({
                            read: 1,
                            timestamp: timestamp
                        },(error)=>{
                            firebase.database().ref().child('user-messages').child(this.state.user_id)
                            .child(roomRef.key)
                            .child(msgRef.key)
                            .update({
                                read: 1,
                                timestamp: timestamp
                            },(error)=>{
                                ipcRenderer.send("onRequestMakeChatRoom", {
                                    user_id: this.state.user_id,
                                    id: this.state.id,
                                    timestamp: this.state.timestamp,
                                    profileImageUrl: this.state.profileImageUrl,
                                    uername: this.state.username,
                                    room_id: roomRef.key
                                })
                                this.props.history.goBack()
                            })
                        })
                    })
                    
                })
            })
        })
        

    }
    render(){
        return(
            <div className="userprofile_main_container">
                <div className="userprofile_header">
                    <div className="userprofile_back_button_container" onClick={() => {
                        this.props.history.goBack()
                    }}>
                        <img src='../src/img/icon_back.png' ></img>
                    </div>
                </div>
                <div className="userprofile_content_container">
                    <div className="userprofile_image_container">
                        <img src={this.state.profileImageUrl == 'default'? '../src/img/default_avatar.png': this.state.profileImageUrl }/>
                    </div>
                    <div className="userprofile_username_container">
                        <span>{this.state.username}</span>
                    </div>
                    <div className="userprofile_btn_container" onClick={()=>{
                        this.handleMakeRoom();
                    }}>
                        <span>방 만들기</span>
                    </div>
                </div>
            </div>
        );
    }
}

