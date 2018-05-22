import React from 'react';
import { Link, hashHistory } from 'react-router-dom';
import * as firebase from "firebase";
import path from 'path'
import Loading from "./Loading"
import SideTap from "./SideTab"
import { ipcRenderer } from 'electron';
import StudentList from './Student_List'
import ChatList from './ChatList'
import SettingList from "./SettingList"
import 'firebase/messaging';

export default class Main extends React.Component{
    
    constructor(props){
        super(props);
        this.state = {
            id : "",
            username: localStorage.username || "",
            isLoading: false,
            errors: [],
            students: [],
            selectedTab : 'list',
            rooms: []
        };
        this.observer = []
        //this.handleOnRecieveData()
    }
    componentDidMount(){
        ipcRenderer.send('onRequestMyInfo')
        ipcRenderer.once('onSendMyInfo', (event, arg) => {
            
            
            this.setState({
                id: arg.id,
                username: arg.username,
                email: arg.email,
                profileImageUrl: arg.profileImageUrl,
                type: arg.type
            })
            ipcRenderer.send('onRequestStudentsList', 'request list');
        })

        ipcRenderer.once("onResultSignOut", (evnet, arg) => {
            this.observer.forEach((e)=>{
                e.off()
            })
            this.props.history.push('/login')
        })

        ipcRenderer.once('onSendStudentsList', (event, arg) => {
            
            
            this.setState({
                students: arg
            })

            this.observeChatList()
        })

        
    }


    observeLastChat = (roomKey, studentKey, timestamp) => {
        var ref = firebase.database().ref('/user-messages').child(this.state.id).child(roomKey)
        .limitToLast(1)
        this.observer.push(ref)
        ref.on('child_added',(snapshot, error)=>{
            firebase.database().ref('/messages').child(snapshot.key).once('value',(childsnapshot,error)=>{
                
                var rooms = this.state.rooms.slice()
                var index = rooms.findIndex((e)=>{
                    return e.roomId == roomKey
                })
                var student = this.state.students.find((e)=>{
                    return e.id == studentKey
                })
                if(index < 0 ){
                    this.setState({
                        rooms: [ ...this.state.rooms, {
                            roomId : roomKey,
                            text : childsnapshot.val().text,
                            userId : student.id,
                            studentUsername : student.username,
                            studentProfileImageUrl: student.profileImageUrl,
                            timestamp : timestamp
                        }]
                    })
                }else{
                    rooms.splice(index, 1, {
                        roomId : roomKey,
                        text : childsnapshot.val().text,
                        userId : student.id,
                        studentUsername : student.username,
                        studentProfileImageUrl: student.profileImageUrl,
                        timestamp: timestamp
                    })

                    this.setState({
                        rooms: rooms
                    })
                }
                
            })
        })
    }
    observeChatList = () => {
        var query = firebase.database().ref('/user-rooms').child(this.state.id).orderByChild('isFinish').equalTo(false);
        this.observer.push(query)

        query.on("value",(snapshot, error)=>{
            snapshot.forEach((childsnapshot)=>{
                let tmp = childsnapshot.val() // 종료 안된 방 목록
                this.observeLastChat(childsnapshot.key, tmp.student, tmp.timestamp)
            })
        })

        var query2 = firebase.database().ref('/user-rooms').child(this.state.id)
        this.observer.push(query2);
        query2.on("child_changed",(snapshot, error)=>{
            console.log('child_changed_snapshot')
            console.log(snapshot.val())
            let tmp = snapshot.val()
            if(tmp.isFinish){
                var rooms = this.state.rooms.slice()
                var index = rooms.findIndex((e)=>{
                    return e.roomId == snapshot.key
                })
                rooms.splice(index,1)
                this.setState({
                    rooms: rooms
                })
                console.log('child_changed_snapshot!!!!!')
                console.log(this.state.rooms)
            }
        })
    }

    onHandleClickListTab = () => {
        this.setState({
            selectedTab : 'list'
        })
    }
    onHandleClickChatTab = () => {
        this.setState({
            selectedTab : 'chat'
        })
    }
    onHandleClickSettingTab = () => {
        this.setState({
            selectedTab : 'setting'
        })
    }
    
    onHandleClickStudentCell = (params) => {

        //this.props.history.push('/chatroom/'+params.id);
        this.props.history.push({
            pathname: '/userprofile',
            state: {
                id: this.state.id,
                user_id: params.id,
                profileImageUrl: params.profileImageUrl,
                username: params.username

            }
        })
    }
    onHandleClickChatListCell = (params) => {
        ipcRenderer.send("onRequestMakeChatRoom", {
            user_id: params.userId,
            id: this.state.id,
            timestamp: params.timestamp,
            profileImageUrl: params.studentProfileImageUrl,
            username: params.studentUsername,
            room_id: params.roomId
        })
    }
    onHandleClickSignout = () => {
        console.log("click sign out!!!")
        ipcRenderer.send("onHandleSignOut",[])
    }

    ////////////Render
    render(){
        return(
            <div className="main_page_container">
                <SideTap selectedTab = {this.state.selectedTab}
                 onHandleClickListTab = {()=> this.onHandleClickListTab()}
                 onHandleClickChatTab = {()=> this.onHandleClickChatTab()}
                 onHandleClickSettingTab = { ()=> this.onHandleClickSettingTab()}
                 />
                {this.state.selectedTab == 'list' ?<StudentList students= {this.state.students} profileImageUrl={this.state.profileImageUrl} 
                id={this.state.id} username={this.state.username} 
                onHandleClickStudentCell={this.onHandleClickStudentCell}
                /> : null } 
                
                {this.state.selectedTab == 'chat' ? <ChatList rooms = {this.state.rooms} onHandleClickChatListCell = {this.onHandleClickChatListCell}/>: null}
                {this.state.selectedTab == 'setting' ? <SettingList email = {this.state.email} onHandleClickSignout = {this.onHandleClickSignout}/> : null }
            </div>
        );
    }
}

