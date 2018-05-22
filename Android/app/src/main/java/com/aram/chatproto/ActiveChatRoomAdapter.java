package com.aram.chatproto;

import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.aram.chatproto.Events.DataEvent;
import com.aram.chatproto.Events.MyDictionary;
import com.aram.chatproto.Events.OnValueEventListener;
import com.aram.chatproto.Model.ChatRoom;

/**
 * Created by Aram on 2018. 3. 8..
 */

public class ActiveChatRoomAdapter extends RecyclerView.Adapter<ActiveChatRoomAdapter.ActiveChatRoomViewHolder>  {

    MyDictionary<String, ChatRoom> activeRoomList = new MyDictionary<>();
    ListFragment mParent;
    ActiveChatRoomAdapter mAdapter;
    public ActiveChatRoomAdapter(ListFragment parent){
        mParent = parent;
        mAdapter = this;
        activeRoomList.addValueEventListener(new OnValueEventListener() {
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

    public void addActiveRoom(String key, ChatRoom chatRoom){
        activeRoomList.put(key, chatRoom);
        chatRoom.getMessages().addValueEventListener(new OnValueEventListener() {
            @Override
            public void onDataAdded(DataEvent event) {
                mAdapter.notifyDataSetChanged();
            }

            @Override
            public void onDataChanged(DataEvent event) {

            }

            @Override
            public void onDataRemoved(DataEvent event) {

            }
        });
    }

    public void removeActiveRoom(String key){
        if(activeRoomList.containsKey(key)){
            activeRoomList.remove(key);
        }
    }

    public ChatRoom getActiveRoom(String key){

        if(activeRoomList.containsKey(key)) {
            return activeRoomList.get(key);
        }else{
            return null;
        }
    }
    public ChatRoom getActiveRoom(int index){
        Object key = activeRoomList.keySet().toArray()[index];

        return activeRoomList.get(key);

    }
    @Override
    public ActiveChatRoomViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.active_chat_room_list_cell, parent, false);

        return new ActiveChatRoomViewHolder(view);
    }

    @Override
    public void onBindViewHolder(ActiveChatRoomViewHolder holder, int position) {
        Object key = activeRoomList.keySet().toArray()[position];
        ChatRoom room = activeRoomList.get(key);

        holder.username.setText(room.getMentor().getUsername());
        int index = room.getMessages().size() - 1;
        if(index >= 0){
            holder.text.setText(room.getMessages().get(index).getText());
        }




    }

    @Override
    public int getItemCount() {
        return activeRoomList.size();
    }

    public class ActiveChatRoomViewHolder extends RecyclerView.ViewHolder {
        public TextView username, text;
//        public ImageView arrowIcon;
//        public RelativeLayout chatBubble;
        public ActiveChatRoomViewHolder(View itemView) {
            super(itemView);

            text = (TextView)itemView.findViewById(R.id.last_msg);
            username = (TextView)itemView.findViewById(R.id.mentor_username);

//
//            text.setPaintFlags(View.INVISIBLE);
//            edittext.setPaintFlags(View.INVISIBLE);
        }
    }
}
