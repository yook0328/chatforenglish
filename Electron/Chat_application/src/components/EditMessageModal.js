import React from "react";


export default class EditTextModal extends React.Component{
  
  
  constructor(props){
      super(props);
      
      var edit_option_flag = Array(this.props.edit_option_list.length)
      for(var i = 0; i < edit_option_flag.length; i++){
        edit_option_flag[i] = false
      }
      this.state = {
        edit_option_flag : edit_option_flag,
        description: ''
      }
  }
  componentDidMount() {
    var element = document.getElementsByClassName("edit_text_modal_edit_text")
    element[0].style.height = "5px";
    element[0].style.height = element[0].scrollHeight + "px";
    element[0].focus()
    // var dom = document.getElementsByClassName("edit_text_modal_container")
    // dom[0].scrollTop = dom[0].scrollHeight
    
  }
  componentDidUpdate(){
    
  }
  onHandleCheckOptionList = (target, index) => {
    
    var tmp = this.state.edit_option_flag.slice()
    tmp.splice(index,1, !tmp[index])
    this.setState({
      edit_option_flag: tmp
    })
    
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
            <div className="edit_text_modal_bubble_container">
              <span className="edit_text_modal_label">원문</span>
              <div className="edit_text_modal_original_text_bubble">
                <span className="edit_text_modal_original_text">{this.props.EditText}</span>
              </div>
            </div>
            
            <div className="edit_text_modal_bubble_container">
              <span className="edit_text_modal_label">수정</span>
              <div className="edit_text_modal_original_text_bubble">
                  <textarea className="edit_text_modal_edit_text" defaultValue={this.props.EditText} onKeyUp = {(e)=>{
                    this.props.autoResizeTextarea(e)
                  }}></textarea>
              </div>
            </div>
            
            <div className="edit_option_container">
              
              {this.state.edit_option_flag.map((value, index, arr) => {
                return (<div className="edit_option_cell" key={index}>
                  <input type="checkbox" checked={this.state.edit_option_flag[index]} onChange={(target)=>{
                    this.onHandleCheckOptionList(target, index)
                  }}/>
                  <span>{this.props.edit_option_list[index]}</span>
                </div>)
              })}
            </div>
            <div className="description_container">
              <span className="edit_text_modal_label">추가 설명</span>
              <textarea className="edit_text_description" defaultValue={this.state.description} onKeyUp = {(e)=>{
                this.props.autoResizeTextarea(e)
              }}></textarea>
            </div>
            <div className="edit_text_modal_submit_btn" onClick={()=>{
              var element = document.getElementsByClassName("edit_text_modal_edit_text")
             
              var description = document.getElementsByClassName("edit_text_description")
              var options = ''
              
              for(var i = 0; i<this.state.edit_option_flag.length; i++){
                if(this.state.edit_option_flag[i]==true){
                  
                  options += this.props.edit_option_list[i] + '%*$'
                  
                }
              }

              let result = {
                result : element[0].value.trim(),
                options : options.slice(0,options.length - 3),
                description: description[0].value.trim()
              }


              this.props.onHandleSubmitEditMessage(result)
            }}>
              <span className="edit_text_modal_submit_btn_label">Submit</span>
            </div>
            
          </div>
  
      </div>
    )
  }  
}
