import React from "react";
import ChatListCell from './ChatListCell'


export default function ChatList(props) {
    
    return (
        <div className="chat_list_container">
            <div className="chat_list_tagline">
                <span className="chat_list_tag">Chat Room List</span>
            </div>
            {props.rooms.map((value, index, arr)=>{
                console.log(value)
                return (<ChatListCell studentProfileImageUrl = {value.studentProfileImageUrl} userId = {value.userId}
                    roomId = {value.roomId} text = {value.text} studentUsername = {value.studentUsername}
                    timestamp = {value.timestamp} onHandleClickChatListCell={props.onHandleClickChatListCell} key={index}/>);
            })}
            
        </div>
        );
  }