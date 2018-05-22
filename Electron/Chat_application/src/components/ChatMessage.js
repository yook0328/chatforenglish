import React from "react";
import ChatMessageCell from './ChatMessageCell'


export default function ChatMessage(props) {
    
    return (
        <div className="chat_messages_container">
            {props.messages.length != 0 ?  props.messages.map((value, index, arr)=>{
                
                return (
                props.id != value.fromId ? <ChatMessageCell onChangeStudentCheckBox={props.onChangeStudentCheckBox} id={props.id} fromId={value.fromId} text={value.text} 
                timestamp = {value.timestamp} toId={value.toId} type={value.type} uid={value.uid} index={index} 
                key={index} checked={value.checked}/> :
                (value.type != 2 ? <ChatMessageCell onChangeStudentCheckBox={props.onChangeStudentCheckBox} id={props.id} fromId={value.fromId} text={value.text} 
                    timestamp = {value.timestamp} toId={value.toId} type={value.type} uid={value.uid} index={index} 
                    key={index}/>
                : <ChatMessageCell onChangeStudentCheckBox={props.onChangeStudentCheckBox} id={props.id} fromId={value.fromId} text={value.text} 
                timestamp = {value.timestamp} toId={value.toId} type={value.type} uid={value.uid} index={index} 
                original_text = {value.original_text}
                key={index}/>
                )
                
                
                );
            }) : null }
            
        </div>
        );
  }