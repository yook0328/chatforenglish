package com.aram.chatproto;


import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.aram.chatproto.Events.ChatRoomDataEvent;
import com.aram.chatproto.Events.DataEvent;
import com.aram.chatproto.Events.OnValueEventListener;
import com.aram.chatproto.Model.ChatRoom;


/**
 * A simple {@link Fragment} subclass.
 */
public class ChatFragment extends Fragment {

    View mFragmentView;
    private MyApplication mApplication;
    private MainActivity mParent;
    RecyclerView mChatRoomContainer;
    ResultChatRoomAdapter  mAdapter;

    public ChatFragment() {
        // Required empty public constructor
    }
    public void setParentActivity(MainActivity parent){
        mParent = parent;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        mApplication = (MyApplication)mParent.getApplication();

        mFragmentView = inflater.inflate(R.layout.fragment_chat, container, false);

        mChatRoomContainer = (RecyclerView)mFragmentView.findViewById(R.id.chat_room_list);
        mChatRoomContainer.setLayoutManager(new LinearLayoutManager(getContext()));

        mAdapter = new ResultChatRoomAdapter(ChatFragment.this);
        mChatRoomContainer.setAdapter(mAdapter);

        mApplication.chatRooms.addValueEventListener(new OnValueEventListener() {
            @Override
            public void onDataAdded(DataEvent event) {
                Object key = ((ChatRoomDataEvent)event).getKey();
                ChatRoom room = mApplication.chatRooms.get(key);
                if(room.isFinish()){
                    mAdapter.addResultRoom(room.getId(), room);
                }
            }

            @Override
            public void onDataChanged(DataEvent event) {
                Object key = ((ChatRoomDataEvent)event).getKey();
                ChatRoom room = mApplication.chatRooms.get(key);
                if(room.isFinish()){
                    mAdapter.addResultRoom(room.getId(), room);
                }
            }

            @Override
            public void onDataRemoved(DataEvent event) {

            }
        });

        for( String key : mApplication.chatRooms.keySet()){
            ChatRoom chatRoom = mApplication.chatRooms.get(key);
            if(chatRoom.isFinish()){
                continue;
            }

            mAdapter.addResultRoom(chatRoom.getId(), chatRoom);

        }

        return mFragmentView;
    }

}
