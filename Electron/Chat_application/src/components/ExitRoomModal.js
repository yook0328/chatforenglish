import React from "react";


export default class ExitRoomModal extends React.Component{
  
  
  constructor(props){
      super(props);
      
  }
  componentDidMount() {

    
  }
  componentDidUpdate(){
    
  }

  render() {
    return (
      <div className="modal_main_container">
          <div className="modal_background">
  
          </div>
          <div className="modal_content_container">
            <div className="edit_text_modal_close_btn_container" onClick={(e)=>{
              
              this.props.onHandleClickModalCloseBtn()
            }}>
              <img src='../src/img/icon_close.png' className="edit_text_modal_close_btn"/>
            </div>
            <div className="description_content_container">
                <textarea defaultValue={this.props.description} onKeyUp = {(e)=>{
                        this.props.onHandleDescription(e)
                    }}/>
            </div>
            <div className="exit_modal_submit_btn" onClick={(e)=>
                {
                    this.props.onHandleExitRoom()
                }
            }>
              <span >채팅 종료</span>
            </div>
          </div>
      </div>
    )
  }  
}
