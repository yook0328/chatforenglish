import React from 'react';


export default function StudentListCell(props) {
    
    return (
        <div className="student_list_cell" onClick={() => props.onHandleClickStudentCell({
            id: props.id,
            profileImageUrl: props.profileImageUrl,
            username: props.username
        })}>
            <img src={props.profileImageUrl == 'default'? '../src/img/default_avatar.png': props.profileImageUrl }/>
            <span className="stundent_list_cell_username">{props.username}</span>
        </div>
    );
  }