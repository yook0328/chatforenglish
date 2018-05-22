package com.aram.chatproto;

import android.content.Context;
import android.graphics.Point;
import android.support.v7.widget.RecyclerView;
import android.view.Display;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.aram.chatproto.Model.Message;

import java.util.List;

/**
 * Created by Aram on 2018. 1. 25..
 */

public class MessageAdapter extends RecyclerView.Adapter<MessageAdapter.MessageViewHolder> {
    List<Message> messageList;
    ChatLogActivity parentActivity;

    public MessageAdapter(List<Message> _messageList, ChatLogActivity _parent) {
        super();

        messageList = _messageList;
        parentActivity = _parent;
    }

    @Override
    public void onBindViewHolder(MessageViewHolder holder, int position) {
        Message msg = messageList.get(position);

        WindowManager wm = (WindowManager)parentActivity.getSystemService(Context.WINDOW_SERVICE);
        Display display = wm.getDefaultDisplay();
        Point size = new Point();
        display.getSize(size);
        int width = size.x;
        int height = size.y;

        holder.text.setMaxWidth((int)(width * 0.55));
        holder.edittext.setMaxWidth((int)(width * 0.55));
//
//        ConstraintLayout.LayoutParams lp_text = (ConstraintLayout.LayoutParams)holder.text.getLayoutParams();
//
//        holder.text.setLayoutParams(lp_text);
        RelativeLayout.LayoutParams lp_edittext = (RelativeLayout.LayoutParams)holder.edittext.getLayoutParams();


//
        RelativeLayout.LayoutParams lp_arrowicon = (RelativeLayout.LayoutParams)holder.arrowIcon.getLayoutParams();

        RelativeLayout.LayoutParams lp_chatbubble = (RelativeLayout.LayoutParams)holder.chatBubble.getLayoutParams();

        if(msg.getType() < 2){
            holder.text.setText(msg.getText());
            holder.edittext.setText("");

            lp_arrowicon.height = 0;
            lp_edittext.height = 0;
            if(msg.getFromId().equals(parentActivity.my_id) ){

                lp_chatbubble.removeRule(RelativeLayout.CENTER_HORIZONTAL);
                lp_chatbubble.removeRule(RelativeLayout.ALIGN_PARENT_START);
                lp_chatbubble.addRule(RelativeLayout.ALIGN_PARENT_END);
                holder.chatBubble.setBackgroundResource(R.drawable.chat_bubble_my_style);
            }else{

                lp_chatbubble.removeRule(RelativeLayout.CENTER_HORIZONTAL);
                lp_chatbubble.removeRule(RelativeLayout.ALIGN_PARENT_END);
                lp_chatbubble.addRule(RelativeLayout.ALIGN_PARENT_START);
                holder.chatBubble.setBackgroundResource(R.drawable.chat_bubble_other_style);
            }

        }else if(msg.getType() == 2){
            holder.text.setText(msg.getOriginal_text());
            holder.edittext.setText(msg.getText());
            lp_arrowicon.height = lp_arrowicon.width;
            lp_edittext.height = ViewGroup.LayoutParams.WRAP_CONTENT;


            lp_chatbubble.removeRule(RelativeLayout.ALIGN_PARENT_END);
            lp_chatbubble.removeRule(RelativeLayout.ALIGN_PARENT_START);
            lp_chatbubble.addRule(RelativeLayout.CENTER_HORIZONTAL);
            holder.chatBubble.setBackgroundResource(R.drawable.chat_bubble_edit_style);
        }
        else if(msg.getType() == 3){
            holder.text.setText(msg.getText());
            holder.edittext.setText("");

            lp_arrowicon.height = 0;
            lp_edittext.height = 0;
            lp_chatbubble.removeRule(RelativeLayout.ALIGN_PARENT_END);
            lp_chatbubble.removeRule(RelativeLayout.ALIGN_PARENT_START);
            lp_chatbubble.addRule(RelativeLayout.CENTER_HORIZONTAL);
            holder.chatBubble.setBackgroundResource(R.drawable.chat_bubble_edit_style);
        }
        holder.edittext.setLayoutParams(lp_edittext);
        holder.arrowIcon.setLayoutParams(lp_arrowicon);
        holder.chatBubble.setLayoutParams(lp_chatbubble);
    }

    @Override
    public int getItemCount() {
        return messageList.size();
    }

    @Override
    public MessageViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.chat_bubble_cell, parent, false);

        return new MessageViewHolder(view);
    }


    public class MessageViewHolder extends RecyclerView.ViewHolder {
        public TextView text, edittext;
        public ImageView arrowIcon;
        public RelativeLayout chatBubble;
        public MessageViewHolder(View itemView) {
            super(itemView);

            text = (TextView)itemView.findViewById(R.id.message_textview);
            edittext = (TextView)itemView.findViewById(R.id.message_edit_textview);
            arrowIcon = (ImageView)itemView.findViewById(R.id.icon_bottom_arrow_imageview);
            chatBubble = (RelativeLayout)itemView.findViewById(R.id.chat_bubble);

            text.setPaintFlags(View.INVISIBLE);
            edittext.setPaintFlags(View.INVISIBLE);
        }
    }
}
