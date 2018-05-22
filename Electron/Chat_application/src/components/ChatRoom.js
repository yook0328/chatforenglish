import React from 'react';
import { Link, hashHistory } from 'react-router-dom';

import path from 'path'
import Loading from "./Loading"
import { ipcRenderer } from 'electron';
import * as firebase from "firebase";
import ChatMessage from './ChatMessage';
import EditTextModal from './EditMessageModal';
import DescriptionModal from './DescriptionModal'
import ExitRoomModal from './ExitRoomModal'

export default class ChatRoom extends React.Component{
    constructor(props){
        super(props);
        this.checkedList = new Set()

        this.state = {
            input_message: '',
            messages: [],
            isEdit : false,
            isPresentedModal : false
        };
        this.onAddChildChatLog = (snapshot)=>{
            let ref = firebase.database().ref().child('messages').child(snapshot.key);
                ref.once('value', (_snapshot)=>{
                    var tmp = _snapshot.val();
                    tmp['uid'] = _snapshot.key
                    this.state.id != tmp.fromId ? tmp['checked'] = false : null
                    this.setState({
                        messages: [...this.state.messages, tmp]
                    })
                    console.log(this.state.messages);
                }, (error) => {
                    console.log(error);
                })
        }


        ipcRenderer.once(
            "onResultMakeChatRoom",(event, arg)=>{
                var edit_option_list = ["Tenses", "Singular/Plural", "Subject Verb Agreement",
            "Vocab", "Sentence Structure", "Awkward Phrasing", "Prepositions", "'Be' Verb", "Articles"]
                this.state = {
                    input_message: '',
                    messages: [],
                    isEdit : false,
                    isPresentedModal : false,
                    id: arg.id,
                    username: arg.username,
                    profileImageUrl: arg.profileImageUrl,
                    toId: arg.user_id,
                    roomId: arg.room_id,
                    edit_option_list : edit_option_list,
                    isDescriptionModal: false,
                    description: '',
                    isExitModal: false
                }
                this.observeChatLog()
                firebase.database().ref().child('user-rooms').child(this.state.id).child(this.state.roomId)
                .once('value',(snapshot)=>{
                    console.log(snapshot.val())
                    this.setState({
                        description: snapshot.val().description
                    })
                })

            }
        )
    }
    onChangeStudentCheckBox = (target, item) => {

        var tmp = this.state.messages.slice()
        tmp[item.index].checked = !tmp[item.index].checked
        
        
        if(tmp[item.index].checked == true){
            
            !this.checkedList.has(item.index) ? this.checkedList.add(item.index) : null
        }else{
            this.checkedList.has(item.index) ? this.checkedList.delete(item.index) : null    
        }
        
        this.setState(prevState => ({
            messages : tmp,
            isEdit : this.checkedList.size > 0
        }))
    }
    componentDidMount() {
        var data = document.getElementsByClassName("chat_message_input_container");
        var img = document.getElementsByClassName("chat_message_send_button_container");
        var input = document.getElementsByClassName("chat_message_input_text_container")
        


        let space = 5;
        let height = data[0].clientHeight;
        let width = data[0].clientWidth;

        img[0].style.height =  height - 2*space +"px";
        img[0].style.width = height - 2*space +"px";
        
        input[0].style.height = height - 2*space+"px";
        input[0].style.width = width - height - 2*space + "px";


        var back = document.getElementsByClassName("chat_room_header_back_button_container");
        back[0].style.height = height - 2*space + "px";
        back[0].style.width = height - 2*space + "px";

        var memo = document.getElementsByClassName("chat_room_header_memo_button_container")
        memo[0].style.height = height - 2*space + "px";
        memo[0].style.width = height - 2*space + "px";

        var exit = document.getElementsByClassName("chat_room_header_exit_button_container")
        exit[0].style.height = height - 2*space + "px";
        exit[0].style.width = height - 2*space + "px";
        //////////
        //this.setInitValues();

    }

    getEditText = () => {
        var index = []
        for(let item of this.checkedList.values()){
            index.push(item)
        }
        index.sort()
        var msg = ""
        for(let i = 0; i < index.length; i++){
           msg += this.state.messages[index[i]].text.trim() + " " 
        }
        return msg.trim()
    }
    resetEditTexts = () => {
        var index = []
        for(let item of this.checkedList.values()){
            index.push(item)
        }
        index.sort()
        var msgs = this.state.messages.slice();
        for(let i =0; i<index.length; i++){
            msgs[index[i]]['checked'] = false
        }
        this.checkedList.clear()
        this.setState({
            messages: msgs,
            isPresentedModal: false,
            editTextMessage: '',
            isEdit: false

        })
    }
    autoResizeTextarea = (event) => {
        event.target.style.height = "5px";
        event.target.style.height = event.target.scrollHeight + "px";
        // var dom = document.getElementsByClassName("edit_text_modal_container")
        // console.log(dom[0])
        // dom[0].scrollTop = dom[0].scrollHeight
    }
    observeChatLog = () => {
        let userChatRef = firebase.database().ref().child('user-messages').child(this.state.id).child(this.state.roomId);

        userChatRef.on('child_added',this.onAddChildChatLog,(error)=>{
            console.log(error);
        })
    }
    onHandleClickEditBtn = () => {
        if(!this.state.isEdit)
        {
            return
        }

        this.setState({
            isPresentedModal : true,
            editTextMessage : this.getEditText()
        })
    }
    onHandleClickModalCloseBtn = () =>{
        
        if(this.state.isPresentedModal){
            this.resetEditTexts()
        }
        if(this.state.isExitModal || this.state.isDescriptionModal){
            this.updateDescription()
        }
        this.setState({
            isPresentedModal: false,
            isDescriptionModal: false,
            isExitModal: false
        })
    }
    
    updateDescription = () => {
        firebase.database().ref().child('user-rooms').child(this.state.id).child(this.state.roomId)
        .update({
            description: this.state.description
        },(error)=>{
            firebase.database().ref().child('user-rooms').child(this.state.toId).child(this.state.roomId)
            .update({
                description: this.state.description
            },(error) => {

            })
        })
    }

    onHandleSubmitEditMessage = (result) => {

        let msgRef = firebase.database().ref().child('messages').push()
        var timestamp = firebase.database.ServerValue.TIMESTAMP
        msgRef.update({
            fromId: this.state.id,
            text: result.result,
            original_text: this.state.editTextMessage,
            timestamp: timestamp,
            toId: this.state.toId,
            type: 2,
            description: result.description,
            options: result.options

        },(error)=>{
            if(error != null){
                console.log(error)
                return
            }

            firebase.database().ref().child('user-messages').child(this.state.id).child(this.state.roomId)
            .child(msgRef.key).update({
                read:1,
                type:2,
                timestamp: timestamp
            },(error)=>{
                if(error != null){
                    console.log(error)
                    return
                }
                firebase.database().ref().child('user-messages').child( this.state.toId).child(this.state.roomId)
                .child(msgRef.key).update({
                    read:1,
                    type:2,
                    timestamp: timestamp
                },(error)=>{
                    if(error != null){
                        console.log(error)
                        return
                    }

                    this.resetEditTexts();
                })
            })
        })
    }
    onHandleDescription = (e) => {

        
        this.setState({
            description: e.target.value.trim()
        })
    }
    onHandleExitRoom = () => {
        let msgRef = firebase.database().ref().child('messages').push()
        var timestamp = firebase.database.ServerValue.TIMESTAMP
        let finishDataSet = this.state.description == null ? {
            isFinish: true
        }: {
            description: this.state.description,
            isFinish: true
        }

        msgRef.update({
            fromId: this.state.id,
            text: "채팅이 종료되었습니다.",
            timestamp: timestamp,
            toId: this.state.toId,
            type: 3
        },(error)=>{
            if(error != null){
                console.log(error)
                return
            }

            firebase.database().ref().child('user-messages').child(this.state.id).child(this.state.roomId)
            .child(msgRef.key).update({
                read:1,
                timestamp: timestamp
            },(error)=>{
                if(error != null){
                    console.log(error)
                    return
                }
                firebase.database().ref().child('user-messages').child( this.state.toId).child(this.state.roomId)
                .child(msgRef.key).update({
                    read:1,
                    timestamp: timestamp
                },(error)=>{
                    if(error != null){
                        console.log(error)
                        return
                    }
                    firebase.database().ref().child('user-rooms').child(this.state.id).child(this.state.roomId)
                    .update(finishDataSet,(error)=>{
                        if(error != null) {
                            console.log(error)
                        }
                        firebase.database().ref().child('user-rooms').child(this.state.toId).child(this.state.roomId)
                        .update(finishDataSet,(error) => {
                            if(error != null){
                                console.log(error)
                            }
                            ipcRenderer.send("onFinishChatRoom", {
                                roomId : this.state.roomId
                            })
                            let userChatRef = firebase.database().ref().child('user-messages').child(this.state.id).child(this.state.roomId);

                            userChatRef.off()
                        })
                    })

                })
            })
        })
    }
    onHandleSubmitMessage = () =>{
        console.log('submit ' + this.state.input_message)
        if(this.state.input_message ==''){
            return
        }
        let text = this.state.input_message;
        this.setState({
            input_message:''
        });
        // let userChatRef = firebase.database().ref().child('user-messages').child(this.state.id).child(this.state.toId);

        // userChatRef.update()
        let msgRef = firebase.database().ref().child('messages').push()
        var timestamp = firebase.database.ServerValue.TIMESTAMP
        msgRef.update({
            fromId: this.state.id,
            text: text,
            timestamp: timestamp,
            toId: this.state.toId,
            type: 1
        },(error)=>{
            if(error != null){
                console.log(error)
                return
            }

            firebase.database().ref().child('user-messages').child(this.state.id).child(this.state.roomId)
            .child(msgRef.key).update({
                read:1,
                timestamp: timestamp
            },(error)=>{
                if(error != null){
                    console.log(error)
                    return
                }
                firebase.database().ref().child('user-messages').child( this.state.toId).child(this.state.roomId)
                .child(msgRef.key).update({
                    read:1,
                    timestamp: timestamp
                },(error)=>{
                    if(error != null){
                        console.log(error)
                        return
                    }
                })
            })
        })
        
    }
    render(){
        return(
            <div className="chat_room_main_container">
                {this.state.isPresentedModal ? <EditTextModal isPresentedModal = {this.state.isPresentedModal} 
                onHandleClickModalCloseBtn = {this.onHandleClickModalCloseBtn} 
                EditText = {this.state.editTextMessage}
                autoResizeTextarea = {this.autoResizeTextarea}
                edit_option_list = {this.state.edit_option_list}
                onHandleSubmitEditMessage = {this.onHandleSubmitEditMessage}
                /> : null}
                {this.state.isDescriptionModal ? <DescriptionModal 
                     onHandleClickModalCloseBtn = {this.onHandleClickModalCloseBtn} 
                     description = {this.state.description}
                     onHandleDescription = {this.onHandleDescription}
                />: null}
                {this.state.isExitModal ? <ExitRoomModal 
                     onHandleClickModalCloseBtn = {this.onHandleClickModalCloseBtn} 
                     description = {this.state.description}
                     onHandleDescription = {this.onHandleDescription}
                     onHandleExitRoom = {this.onHandleExitRoom}
                />: null}
                <div className="chat_room_header">
                    <div className="chat_room_header_back_button_container" onClick={() => {
                        this.props.history.goBack()
                    }}>
                        <img src='../src/img/icon_back.png' className="chat_message_send_icon"></img>
                    </div>
                    <div className="chat_room_header_memo_button_container" onClick={()=>{
                        this.setState({
                            isDescriptionModal: true
                        })
                    }}>
                        <img src='../src/img/icon_memo.png' ></img>
                    </div>
                    <div className="chat_room_header_exit_button_container" onClick={()=>{
                        this.setState({
                            isExitModal: true
                        })
                    }}>
                        <img src='../src/img/icon_exit.png' ></img>
                    </div>
                    
                </div>
                <ChatMessage messages = {this.state.messages} id = {this.state.id} onChangeStudentCheckBox={this.onChangeStudentCheckBox}/>
                <div className="chat_room_footer">
                    <div className="chat_room_edit_btn" style={{
                        backgroundColor : this.state.isEdit ? "#29B6F6" : "#607D8B"
                    }
                    } 
                    onClick={() => {this.onHandleClickEditBtn()}}
                    >
                        <span className="chat_room_edit_btn_label" style={{
                        color : this.state.isEdit ? "white" : "#B0BEC5"
                    }
                    }>Edit</span>
                    </div>
                    <div className="chat_message_input_container">
                        <div className="chat_message_input_text_container">
                            <input type="text" className="chat_message_input" value={this.state.input_message} onChange={(e)=>{
                                //console.log(e.target);
                                this.setState({input_message: e.target.value});
                            }} onKeyUp={(e)=>{
                                if(e.key =='Enter'){
                                    this.onHandleSubmitMessage();
                                }
                            }} ></input>  
                        </div>
                        
                        <div className="chat_message_send_button_container" onClick={()=>{this.onHandleSubmitMessage()}}>
                            <img src='../src/img/icon_send.png' className="chat_message_send_icon"></img>
                        </div>
                        
                    </div>
                </div>
                
            </div>
        );
    }
}

