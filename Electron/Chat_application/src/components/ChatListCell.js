import React from 'react';


export default function ChatListCell(props) {
    
    return (
        <div className="chat_list_cell" onClick = {()=>{
            props.onHandleClickChatListCell(props)
        }} >
            <div className="chat_list_cell_profileImage">
                <img src={props.studentProfileImageUrl == 'default'? '../src/img/default_avatar.png': props.profileImageUrl }/>
            </div>
            <div className="chat_list_cell_text">
                <h1>{props.studentUsername}</h1>
                <span>{props.text}</span>
            </div>
            
            
        </div>
    );
  }