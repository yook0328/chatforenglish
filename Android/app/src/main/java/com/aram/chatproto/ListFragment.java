package com.aram.chatproto;


import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.aram.chatproto.Events.ChatRoomDataEvent;
import com.aram.chatproto.Events.DataEvent;
import com.aram.chatproto.Events.OnValueEventListener;
import com.aram.chatproto.Listener.RecyclerItemClickListener;
import com.aram.chatproto.Model.ChatRoom;


/**
 * A simple {@link Fragment} subclass.
 */
public class ListFragment extends Fragment {

    View mFragmentView;
    private RecyclerView mActiveChatRoomsContainer;
    private TextView mUsernameTxt;
    private MyApplication mApplication;
    private MainActivity mParent;
    ActiveChatRoomAdapter mAdapter;
//    MyDictionary<String, ChatRoom> mActiveRoomList = new MyDictionary<>();


    public ListFragment() {
        // Required empty public constructor
    }

    public void setParentActivity(MainActivity parent){
        mParent = parent;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        mApplication = (MyApplication)mParent.getApplication();

        mFragmentView = inflater.inflate(R.layout.fragment_list, container, false);

        mActiveChatRoomsContainer = (RecyclerView)mFragmentView.findViewById(R.id.active_chat_room_list);

//        mDatabase = FirebaseDatabase.getInstance().getReference();
//        mMentorRef = mDatabase.child("Users").orderByChild("type").equalTo("Mentor");
//
//        mMentorRef.keepSynced(true);

        mActiveChatRoomsContainer.setHasFixedSize(true);
        mActiveChatRoomsContainer.setLayoutManager(new LinearLayoutManager(getContext()));
        mAdapter = new ActiveChatRoomAdapter(ListFragment.this);
        mActiveChatRoomsContainer.setAdapter(mAdapter);

        mUsernameTxt = (TextView)mFragmentView.findViewById(R.id.profile_username);

        mUsernameTxt.setText(mApplication.getUser().getUsername());


        /////// acitve room list 를 구하도록 하자
//        mApplication.chatRooms
        for( String key : mApplication.chatRooms.keySet()){
            ChatRoom chatRoom = mApplication.chatRooms.get(key);
            if(chatRoom.isFinish()){
                continue;
            }

            mAdapter.addActiveRoom(chatRoom.getId(), chatRoom);

        }

        mApplication.chatRooms.addValueEventListener(new OnValueEventListener() {
            @Override
            public void onDataAdded(DataEvent event) {
                ChatRoom room = mApplication.chatRooms.get(((ChatRoomDataEvent)event).getKey());
                if(room.isFinish() == false){
                    mAdapter.addActiveRoom(room.getId(), room);
                }

            }

            @Override
            public void onDataChanged(DataEvent event) {
                ChatRoom room = mApplication.chatRooms.get(((ChatRoomDataEvent)event).getKey());

                if(room.isFinish()){
                    mAdapter.removeActiveRoom(room.getId());
                }
            }

            @Override
            public void onDataRemoved(DataEvent event) {

            }
        });
        /////
        mActiveChatRoomsContainer.addOnItemTouchListener(new RecyclerItemClickListener(getContext(), mActiveChatRoomsContainer,
                new RecyclerItemClickListener.OnItemClickListener() {
                    @Override
                    public void onItemClick(View view, int position) {
                        Intent chatIntent = new Intent(mParent, ChatLogActivity.class);

                        chatIntent.putExtra("room_id", mAdapter.getActiveRoom(position).getId());
                        chatIntent.putExtra("active", true);
                        startActivity(chatIntent);
                    }

                    @Override
                    public void onItemLongClick(View view, int position) {

                    }
                }));

        return mFragmentView;
    }



    @Override
    public void onStart() {
        super.onStart();


    }


}


