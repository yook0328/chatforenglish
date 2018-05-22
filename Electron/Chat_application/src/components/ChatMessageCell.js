import React from 'react';

const myChatBubble = {
    marginLeft : 'auto',
    backgroundColor : '#FFF176'
}
const otherChatBubble = {
    // marginRight : 'auto',
    backgroundColor : 'white'
    
}
const editChatBubble = {
    backgroundColor : '#D4E157',
    marginLeft : 'auto',
    marginRight : 'auto'

}
const systemChatBubble = {
    backgroundColor : '#E1F5FE',
    marginLeft : 'auto',
    marginRight : 'auto'

}

export default class ChatMessageCell extends React.Component{
    constructor(props){
        super(props);
        
    }
    componentDidMount() {
        var dom = document.getElementsByClassName("chat_messages_container")
        dom[0].scrollTop = dom[0].scrollHeight
        if(this.props.type == 2){
            console.log(this.props)
        }
    }
    render() {
        switch(this.props.type){
            case 0:
                return (
                    <div className="chat_message_cell_row" >
                        <div className="chat_message_bubble" style={this.props.id == this.props.fromId ? myChatBubble: otherChatBubble}
                        >
                            <span className="chat_message_text">{this.props.text}</span>
                        </div>
                        {this.props.id != this.props.fromId ? <input type="checkbox" style={
                            {
                                marginRight : 'auto',
                                marginTop : 'auto',
                                marginBottom : '5px',
                                marginLeft : '5px'
                            }
                        } checked={this.props.checked}  onChange = {(target)=> {
        
                            this.props.onChangeStudentCheckBox(target,{
                                index : this.props.index
                            })
                        }}/>: null}
        
                    </div>)
            case 1:
                return (
                    <div className="chat_message_cell_row" >
                        <div className="chat_message_bubble" style={this.props.id == this.props.fromId ? myChatBubble: otherChatBubble}
                        >
                            <span className="chat_message_text">{this.props.text}</span>
                        </div>
                        {this.props.id != this.props.fromId ? <input type="checkbox" style={
                            {
                                marginRight : 'auto',
                                marginTop : 'auto',
                                marginBottom : '5px',
                                marginLeft : '5px'
                            }
                        } checked={this.props.checked}  onChange = {(target)=> {
        
                            this.props.onChangeStudentCheckBox(target,{
                                index : this.props.index
                            })
                        }}/>: null}
        
                    </div>)
            case 2:
                return (<div className="chat_message_cell_row" >
                    <div className="chat_message_bubble" style={editChatBubble}>
                        <div className="edited_message_container">
                            <span className="chat_original_text">{this.props.original_text}</span>
                            <img src='../src/img/icon_bottom_arrow.png' className="chat_edit_arrow" /> 
                            <span className="chat_edited_text">{this.props.text}</span>
                        </div>
                        
                    </div>
                </div>)
            
            case 3: 
                return (<div className="chat_message_cell_row" >
                    <div className="chat_message_bubble" style={editChatBubble}>
                        <span className="chat_system_text">{this.props.text}</span>
                        
                    </div>
                </div>)

            default:
                return null
        }
    }
  }