package com.aram.chatproto;

import android.app.Activity;
import android.os.Bundle;
import android.support.constraint.ConstraintLayout;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewTreeObserver;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.RelativeLayout;

import com.aram.chatproto.Events.DataEvent;
import com.aram.chatproto.Events.OnValueEventListener;
import com.aram.chatproto.Model.ChatRoom;
import com.aram.chatproto.Model.Message;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ServerValue;

import java.util.HashMap;
import java.util.List;

public class ChatLogActivity extends AppCompatActivity {

    Toolbar mToolbar;
    ImageButton mChatSendBtn;
    EditText mMessageInput;
    List<Message> messageList;
    RecyclerView mChatListContainer;
    MessageAdapter mMessageAdapter;
    private FirebaseAuth mAuth;
    FirebaseDatabase mDatabase;

    private MyApplication mApplication;

    String my_id;
    String user_id;
    String room_id;
    ChatRoom chatRoom;

    LinearLayoutManager mLinearLayoutManager;
    RelativeLayout mRootContainer;
    boolean isShowKeyboard = false;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_chat_log);

        mToolbar = (Toolbar)findViewById(R.id.chat_log_appbar_layout);



        mApplication = (MyApplication)getApplication();
        setSupportActionBar(mToolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);


        ////Firbase
        mAuth = FirebaseAuth.getInstance();
        mDatabase = FirebaseDatabase.getInstance();
        room_id = getIntent().getStringExtra("room_id");
        chatRoom = mApplication.chatRooms.get(room_id);
        user_id = chatRoom.getMentor().getId();
        my_id = mAuth.getCurrentUser().getUid();
        messageList = chatRoom.getMessages();
        getSupportActionBar().setTitle(chatRoom.getMentor().getUsername());
        mRootContainer = (RelativeLayout)findViewById(R.id.root_conatainer);
        mRootContainer.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
            @Override
            public void onGlobalLayout() {
                int heightDiff = mRootContainer.getRootView().getHeight() - mRootContainer.getHeight();
                if (heightDiff > Utils.pxFromDp(ChatLogActivity.this, 200)) {
                    mLinearLayoutManager.scrollToPosition(messageList.size()-1);
                    isShowKeyboard = true;
                }else if(isShowKeyboard && !(heightDiff > Utils.pxFromDp(ChatLogActivity.this, 200))){
                    isShowKeyboard = false;
                }
            }
        });

        mChatSendBtn = (ImageButton)findViewById(R.id.message_send_btn);
        mMessageInput = (EditText)findViewById(R.id.message_input_edittext);
        mChatListContainer = (RecyclerView)findViewById(R.id.chat_list_container);



        boolean isActive = getIntent().getBooleanExtra("active", true);

        if(isActive){
            ViewTreeObserver heightObserver = mChatSendBtn.getViewTreeObserver();
            heightObserver.addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
                @Override
                public void onGlobalLayout() {

                    ConstraintLayout.LayoutParams lp_chat_btn = (ConstraintLayout.LayoutParams)mChatSendBtn.getLayoutParams();
                    lp_chat_btn.width = mChatSendBtn.getHeight();
                    mChatSendBtn.setLayoutParams(lp_chat_btn);
                    ConstraintLayout.LayoutParams lp_input_text = (ConstraintLayout.LayoutParams)mMessageInput.getLayoutParams();
                    lp_input_text.height = mChatSendBtn.getHeight();
                    mMessageInput.setLayoutParams(lp_input_text);

                }
            });
        }else{
            ConstraintLayout inputConatainer = findViewById(R.id.input_container);
            RelativeLayout.LayoutParams lp = (RelativeLayout.LayoutParams)inputConatainer.getLayoutParams();
            lp.height = 0;
            inputConatainer.setLayoutParams(lp);
            mChatSendBtn.setEnabled(false);
            mMessageInput.setEnabled(false);
        }


        //RecyclerView setting

        mLinearLayoutManager = new LinearLayoutManager(getApplicationContext());
        mChatListContainer.setLayoutManager(mLinearLayoutManager);
        mMessageAdapter = new MessageAdapter(messageList, ChatLogActivity.this);
        mChatListContainer.setAdapter(mMessageAdapter);

        chatRoom.getMessages().addValueEventListener(new OnValueEventListener() {
            @Override
            public void onDataAdded(DataEvent event) {
                mMessageAdapter.notifyDataSetChanged();
                mLinearLayoutManager.scrollToPosition(messageList.size()-1);
            }

            @Override
            public void onDataChanged(DataEvent event) {

            }

            @Override
            public void onDataRemoved(DataEvent event) {

            }
        });

        mChatListContainer.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View view, MotionEvent motionEvent) {

                hideKeyboard(view);
                return false;
            }
        });


        mLinearLayoutManager.scrollToPosition(messageList.size()-1); //Scroll 제일 아래로

        ////// (2)메시지 전송 부분 수정한다

        //observeChatLog();

        mChatSendBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String msg = mMessageInput.getText().toString();
                if(msg.isEmpty())
                    return;

                HashMap<String, Object> msgMap = new HashMap<>();
                msgMap.put("toId", user_id);
                msgMap.put("fromId", my_id);
                msgMap.put("type", 0);
                final Object timestamp = ServerValue.TIMESTAMP;
                msgMap.put("timestamp", timestamp);
                msgMap.put("text", msg);

                mDatabase.getReference().child("messages").push().updateChildren(msgMap, new DatabaseReference.CompletionListener() {
                    @Override
                    public void onComplete(DatabaseError databaseError, DatabaseReference databaseReference) {
                        if(databaseError != null){

                            return;
                        }
                        final String msgKey = databaseReference.getKey();
                        final HashMap<String, Object> usermsgMap = new HashMap<>();
                        usermsgMap.put("read", 1);
                        usermsgMap.put("timestamp", timestamp);

                        mDatabase.getReference().child("user-messages").child(my_id).child(room_id)
                                .child(msgKey).updateChildren(usermsgMap, new DatabaseReference.CompletionListener() {
                            @Override
                            public void onComplete(DatabaseError databaseError, DatabaseReference databaseReference) {
                                if(databaseError != null){

                                    return;
                                }

                                mDatabase.getReference().child("user-messages").child(user_id).child( room_id)
                                        .child(msgKey).updateChildren(usermsgMap, new DatabaseReference.CompletionListener() {
                                    @Override
                                    public void onComplete(DatabaseError databaseError, DatabaseReference databaseReference) {
                                        if(databaseError != null){

                                            return;
                                        }
                                        mMessageInput.setText("");
                                    }
                                });
                            }
                        });
                    }
                });
            }
        });
    }

    public void hideKeyboard(View view){
        InputMethodManager inputMethodManager = (InputMethodManager)getSystemService(Activity.INPUT_METHOD_SERVICE);
        inputMethodManager.hideSoftInputFromWindow(view.getWindowToken(), 0);
    }
}
