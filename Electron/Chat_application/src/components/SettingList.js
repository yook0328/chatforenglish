import React from "react";

export default function SettingList(props) {
    return (
        <div className="setting_list_container">
            <div className="setting_list_tagline">
                <span className="setting_list_tag">Setting</span>
            </div>
            <div className="email_container">
                <span className="email_text">{props.email}</span>
                <span className="signout" onClick={()=>{props.onHandleClickSignout()}}>Log Out</span>
            </div>
            
        </div>
        );
}