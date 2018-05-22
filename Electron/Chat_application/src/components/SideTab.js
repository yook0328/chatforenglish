import React from "react";



export default function SideTap(props) {
    
    return (
        <div className="sidetab">
            <nav className="sidetab-nav">
                <a href="#"  className="student-list-tap" onClick={props.onHandleClickListTab}>
                    <img src={props.selectedTab == 'list' ? '../src/img/selected_icon_list.png':'../src/img/icon_list.png'}></img>
                </a>
                <a href="#"  className="chat-tab" onClick={props.onHandleClickChatTab}>
                    <img src={props.selectedTab == 'chat' ? '../src/img/selected_icon_chat.png': '../src/img/icon_chat.png'}></img>
                </a>
                <a href="#"  className="setting-tab" onClick={props.onHandleClickSettingTab}>
                    <img src={props.selectedTab == 'setting' ? '../src/img/selected_icon_setting.png':'../src/img/icon_setting.png'}></img>
                </a>
            </nav>
            
        </div>
    );
  }