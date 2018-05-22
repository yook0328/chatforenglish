package com.aram.chatproto;

import android.content.Context;
import android.content.Intent;
import android.graphics.Point;
import android.support.constraint.ConstraintLayout;
import android.support.v7.widget.RecyclerView;
import android.view.Display;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.aram.chatproto.Events.DataEvent;
import com.aram.chatproto.Events.MyDictionary;
import com.aram.chatproto.Events.OnValueEventListener;
import com.aram.chatproto.Model.ChatRoom;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Created by Aram on 2018. 3. 10..
 */

public class ResultChatRoomAdapter extends RecyclerView.Adapter<ResultChatRoomAdapter.ResultChatRoomCellViewHolder> {

    ChatFragment parentFragment;
    MyDictionary<String, ChatRoom> resultRoomList = new MyDictionary<>();
    ResultChatRoomAdapter mAdapter;

    public ResultChatRoomAdapter( ChatFragment _parent) {
        super();
        mAdapter = this;
        parentFragment = _parent;
        resultRoomList.addValueEventListener(new OnValueEventListener() {
            @Override
            public void onDataAdded(DataEvent event) {
                mAdapter.notifyDataSetChanged();
            }

            @Override
            public void onDataChanged(DataEvent event) {
                mAdapter.notifyDataSetChanged();
            }

            @Override
            public void onDataRemoved(DataEvent event) {
                mAdapter.notifyDataSetChanged();
            }
        });

    }

    public void addResultRoom(String key, ChatRoom chatRoom){
        resultRoomList.put(key, chatRoom);
    }

    public void removeResultRoom(String key){
        if(resultRoomList.containsKey(key)){
            resultRoomList.remove(key);
        }
    }

    public ChatRoom getResultRoom(String key){

        if(resultRoomList.containsKey(key)) {
            return resultRoomList.get(key);
        }else{
            return null;
        }
    }

    @Override
    public void onBindViewHolder(ResultChatRoomAdapter.ResultChatRoomCellViewHolder holder, int position) {
        Object key = resultRoomList.keySet().toArray()[position];
        final ChatRoom room = resultRoomList.get(key);


        WindowManager wm = (WindowManager)parentFragment.getActivity().getSystemService(Context.WINDOW_SERVICE);
        Display display = wm.getDefaultDisplay();
        Point size = new Point();
        display.getSize(size);
        int width = size.x;
        int height = size.y;

        holder.chatLogBtn.setMaxWidth((int)(width * 0.125));
        holder.chatResultBtn.setMaxWidth((int)(width * 0.125));


        SimpleDateFormat sfd = new SimpleDateFormat("yyyy-MM-dd HH:mm");


        holder.timestamp.setText(sfd.format(new Date(room.getTimestamp())));

        holder.username.setText(room.getMentor().getUsername());

        ConstraintLayout.LayoutParams log_lp = (ConstraintLayout.LayoutParams)holder.chatLogBtn.getLayoutParams();
        ConstraintLayout.LayoutParams result_lp = (ConstraintLayout.LayoutParams)holder.chatResultBtn.getLayoutParams();

        log_lp.width = (int)(width * 0.2);
        result_lp.width = (int)(width * 0.2);

        holder.chatLogBtn.setLayoutParams(log_lp);
        holder.chatResultBtn.setLayoutParams(result_lp);

        holder.chatLogBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(parentFragment.getContext(), ChatLogActivity.class);

                intent.putExtra("room_id", room.getId());
                intent.putExtra("active", false);
                parentFragment.startActivity(intent);
            }
        });
        holder.chatResultBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(parentFragment.getContext(), ChatResultActivity.class);

                intent.putExtra("room_id", room.getId());
                parentFragment.startActivity(intent);
            }
        });
//
//        ConstraintLayout.LayoutParams lp_text = (ConstraintLayout.LayoutParams)holder.text.getLayoutParams();
//
//        holder.text.setLayoutParams(lp_text);

    }

    @Override
    public int getItemCount() {
        return resultRoomList.size();
    }

    @Override
    public ResultChatRoomAdapter.ResultChatRoomCellViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.chat_room_cell, parent, false);

        return new ResultChatRoomAdapter.ResultChatRoomCellViewHolder(view);
    }


    public class ResultChatRoomCellViewHolder extends RecyclerView.ViewHolder {
        public TextView username, timestamp;
        public ImageView profileImage;
        public Button chatLogBtn, chatResultBtn;

        public ResultChatRoomCellViewHolder(View itemView) {
            super(itemView);

            username = (TextView)itemView.findViewById(R.id.mentor_username);
            timestamp = (TextView)itemView.findViewById(R.id.timestamp);
            profileImage = (ImageView)itemView.findViewById(R.id.mentor_profile_image);
            chatLogBtn = (Button) itemView.findViewById(R.id.chat_log_btn);
            chatResultBtn = (Button) itemView.findViewById(R.id.chat_result_btn);


        }
    }
}
