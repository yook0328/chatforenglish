import React from "react";
import StudentListCell from './Student_List_Cell'


export default function StudentList(props) {
    
    return (
        <div className="student_list_container">
            <div className="student_list_tagline">
                <span className="student_list_tag">My Profile</span>
            </div>
            
                <StudentListCell profileImageUrl = {props.profileImageUrl} id = {props.id} username = {props.username}/>
            <div className="student_list_tagline">
                <span className="student_list_tag">Students</span>
            </div>
            {props.students.map((value, index, arr)=>{
                return (<StudentListCell onHandleClickStudentCell={props.onHandleClickStudentCell} profileImageUrl = {value.profileImageUrl} id = {value.id} username = {value.username} key={index}/>);
            })}
            
        </div>
        );
  }