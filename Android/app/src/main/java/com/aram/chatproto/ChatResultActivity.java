package com.aram.chatproto;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.aram.chatproto.Events.MyMsgArrayList;
import com.aram.chatproto.Model.ChatRoom;
import com.aram.chatproto.Model.Message;

public class ChatResultActivity extends AppCompatActivity {
    RecyclerView mContainer;
    private MyApplication mApplication;

    MyMsgArrayList<Message> msgArrayList = new MyMsgArrayList<>();
    Toolbar mToolbar;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_chat_result);

        mContainer = (RecyclerView)findViewById(R.id.container);

        mApplication = (MyApplication)getApplication();

        mToolbar = (Toolbar)findViewById(R.id.chat_log_appbar_layout) ;

        setSupportActionBar(mToolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setTitle("");


        String roomId = getIntent().getStringExtra("room_id");

        mContainer.setLayoutManager(new LinearLayoutManager(getApplicationContext()));

        ChatRoom room = mApplication.chatRooms.get(roomId);
        for(Message msg : room.getMessages()){
            if(msg.getType() == 2){
                msgArrayList.add(msg);
            }
        }

        mContainer.setAdapter(new ResultChatAdapter( msgArrayList , room.getDescription()));

    }

    class ResultChatAdapter extends RecyclerView.Adapter<ResultChatAdapter.ResultCellViewHolder> {

        MyMsgArrayList<Message> msgArrayList;
        String description;

        public ResultChatAdapter(MyMsgArrayList<Message> _msgArrayList, String _description){
            msgArrayList = _msgArrayList;
            description = _description;
        }

        @Override
        public ResultCellViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
            View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.chat_result_cell, parent, false);

            return new ResultCellViewHolder(view);
        }

        @Override
        public void onBindViewHolder(ResultCellViewHolder holder, int position) {
            holder.chatContainer.removeAllViews();
            if(position == msgArrayList.size()){
                setResultChatView(holder.chatContainer);
            }else{
                setMsgView(holder.chatContainer, msgArrayList.get(position));
            }

        }

        void setMsgView(LinearLayout container, Message msg){

            TextView original = new TextView(container.getContext());
            original.setText("원문 : " + msg.getOriginal_text());
            LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
            int margin = (int)Utils.pxFromDp(container.getContext(), 5);
            lp.setMargins(margin,margin,margin,0);
            original.setLayoutParams(lp);

            container.addView(original);


            TextView edit = new TextView(container.getContext());
            edit.setText("수정 : " + msg.getText());
            lp = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
            lp.setMargins(margin,margin,margin,0);
            edit.setLayoutParams(lp);
            container.addView(edit);

            String[] option =msg.getOptions().split("%*$");

            for(int i = 0; i < option.length; i++){
                if(option[i].trim().length() > 0){
                    TextView op = new TextView(container.getContext());
                    op.setText(" - " + option[i]);
                    lp = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
                    lp.setMargins(margin,margin,margin,0);
                    op.setLayoutParams(lp);
                    container.addView(op);
                }
            }

            if(msg.getDescription().length() > 0 ){
                TextView description = new TextView(container.getContext());
                description.setText("부가설명 : " + msg.getDescription());
                lp = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
                lp.setMargins(margin,margin,margin,0);
                description.setLayoutParams(lp);
                container.addView(description);
            }



            View boundary = new View(container.getContext());
            lp = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, (int)Utils.pxFromDp(container.getContext(), 1));
            lp.setMargins(
                    0,margin,0,0
            );
            boundary.setBackgroundColor(getResources().getColor(R.color.entry_hint_color));
            boundary.setLayoutParams(lp);
            container.addView(boundary);

        }
        void setResultChatView(LinearLayout container){
            TextView _description = new TextView(container.getContext());
            _description.setText("총평 : " + description);
            LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
            int margin = (int)Utils.pxFromDp(container.getContext(), 5);
            lp.setMargins(margin,margin,margin,0);
            _description.setLayoutParams(lp);

            container.addView(_description);
        }

        @Override
        public int getItemCount() {
            return msgArrayList.size() + (description.length() > 0 ? 1 : 0);
        }

        class ResultCellViewHolder extends RecyclerView.ViewHolder{
            public LinearLayout chatContainer;

            public ResultCellViewHolder(View itemView) {
                super(itemView);

                chatContainer = (LinearLayout)itemView.findViewById(R.id.root_conatainer);
            }
        }
    }
}
