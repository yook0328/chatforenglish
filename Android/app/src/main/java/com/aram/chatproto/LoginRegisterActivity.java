package com.aram.chatproto;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v7.app.AppCompatActivity;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RadioGroup;
import android.widget.Toast;

import com.aram.chatproto.Model.User;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;
import com.google.firebase.iid.FirebaseInstanceId;

import java.util.HashMap;
import java.util.Map;

public class LoginRegisterActivity extends AppCompatActivity {
    RadioGroup mSegmentItems;
    Button mSubmitBtn;
    EditText mEmailTxt;
    EditText mUsernameTxt;
    View mUsernameUnderline;
    MyApplication mApplication;
    EditText mPwTxt;
    LinearLayout.LayoutParams mUsernameParams;
    LinearLayout.LayoutParams mUsernameUnderlineParams;
    private FirebaseAuth mAuth;

    private ProgressDialog mProgress;
    

    @Override
    public void onBackPressed() {
//        super.onBackPressed();
        finishAndRemoveTask();
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login_register);

        mApplication = (MyApplication)getApplication();

        if(FirebaseAuth.getInstance().getCurrentUser() != null && getSharedPreferences("UserInfo",0) != null){
            Intent intent = new Intent(this, MainActivity.class);
            User user = new User();
            user.setId(FirebaseAuth.getInstance().getCurrentUser().getUid());
            SharedPreferences settings = getSharedPreferences("UserInfo", 0);

            user.setEmail(settings.getString("Email","").toString());
            user.setProfileImageUrl(settings.getString("ProfileImageUrl","").toString());
            user.setUsername(settings.getString("Username","").toString());
            user.setType(settings.getString("Type","").toString());

            mApplication.setUser(user);

            startActivity(intent);
        }
        mSegmentItems = (RadioGroup)findViewById(R.id.nav_item_container);
        mSubmitBtn = (Button)findViewById(R.id.login_register_btn);
        mEmailTxt = (EditText)findViewById(R.id.email_txt);
        mUsernameTxt = (EditText)findViewById(R.id.username_txt);
        mUsernameUnderline = (View)findViewById(R.id.username_underline);
        mPwTxt = (EditText)findViewById(R.id.pw_txt);
        mUsernameParams = (LinearLayout.LayoutParams)mUsernameTxt.getLayoutParams();
        mUsernameParams.height = 0;
        mUsernameTxt.setLayoutParams(mUsernameParams);
        mUsernameUnderlineParams = (LinearLayout.LayoutParams)mUsernameUnderline.getLayoutParams();
        mUsernameUnderlineParams.height = 0;
        mUsernameUnderline.setLayoutParams(mUsernameUnderlineParams);

        mSegmentItems.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup radioGroup, int i) {
                switch (i){
                    case R.id.segment_login:
                        mUsernameParams = (LinearLayout.LayoutParams)mUsernameTxt.getLayoutParams();
                        mUsernameParams.height = 0;
                        mUsernameTxt.setLayoutParams(mUsernameParams);
                        mUsernameUnderlineParams = (LinearLayout.LayoutParams)mUsernameUnderline.getLayoutParams();
                        mUsernameUnderlineParams.height = 0;
                        mUsernameUnderline.setLayoutParams(mUsernameUnderlineParams);
                        mSubmitBtn.setText("Login");
                        break;
                    case R.id.segment_register:
                        mUsernameParams = (LinearLayout.LayoutParams)mUsernameTxt.getLayoutParams();
                        mUsernameParams.height = LinearLayout.LayoutParams.WRAP_CONTENT;
                        mUsernameTxt.setLayoutParams(mUsernameParams);

                        mUsernameUnderlineParams = (LinearLayout.LayoutParams)mUsernameUnderline.getLayoutParams();
                        mUsernameUnderlineParams.height = getResources().getDimensionPixelSize(R.dimen.underline_dimen);
                        mUsernameUnderline.setLayoutParams(mUsernameUnderlineParams);
                        mSubmitBtn.setText("Register");
                        break;
                }
            }
        });

        /////////
        mAuth = FirebaseAuth.getInstance();

        ////
        mProgress = new ProgressDialog(this);

        setupSubmitBtn();
    }

    void setupSubmitBtn(){
        mSubmitBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                switch (mSegmentItems.getCheckedRadioButtonId()){
                    case R.id.segment_login:
                        handleLogin();
                        break;
                    case R.id.segment_register:
                        handleRegister();

                        break;
                }
            }
        });
    }
    void handleLogin(){
        String email = mEmailTxt.getText().toString();
        String password = mPwTxt.getText().toString();
        if(!TextUtils.isEmpty(email) & !TextUtils.isEmpty(password)){
            mProgress.setTitle("Login...");
            mProgress.setCanceledOnTouchOutside(false);
            mProgress.show();
            mAuth.signInWithEmailAndPassword(email, password).addOnCompleteListener(new OnCompleteListener<AuthResult>() {
                @Override
                public void onComplete(@NonNull Task<AuthResult> task) {
                    if (task.isSuccessful()){

                        final Map<String, Object> userMap = new HashMap<>();
                        userMap.put("platform", "Android");
                        Log.d("token", FirebaseInstanceId.getInstance().getToken());
                        userMap.put("deviceToken", FirebaseInstanceId.getInstance().getToken());
                        FirebaseDatabase.getInstance().getReference().child("Users").child(mAuth.getCurrentUser().getUid())
                                .updateChildren(userMap, new DatabaseReference.CompletionListener() {
                                    @Override
                                    public void onComplete(DatabaseError databaseError, DatabaseReference databaseReference) {
                                        FirebaseDatabase.getInstance().getReference().child("Users").child(mAuth.getCurrentUser().getUid())
                                                .addListenerForSingleValueEvent(new ValueEventListener() {
                                                    @Override
                                                    public void onDataChange(DataSnapshot dataSnapshot) {
                                                        mApplication.setUser(new User(dataSnapshot));
                                                        Intent mainIntent = new Intent(LoginRegisterActivity.this, MainActivity.class);
                                                        mProgress.dismiss();
                                                        User user = mApplication.getUser();
                                                        SharedPreferences settings = getSharedPreferences("UserInfo", 0);
                                                        SharedPreferences.Editor editor = settings.edit();
                                                        editor.putString("Username", user.getUsername());
                                                        editor.putString("Email", user.getEmail());
                                                        editor.putString("ProfileImageUrl", user.getProfileImageUrl());
                                                        editor.putString("Type", user.getType());
                                                        editor.commit();

                                                        startActivity(mainIntent);
                                                        finish();
                                                    }

                                                    @Override
                                                    public void onCancelled(DatabaseError databaseError) {
                                                        Log.d("error", databaseError.toString());
                                                    }
                                                });
                                    }
                                });




                    }else{
                        mProgress.hide();
                        Toast.makeText(LoginRegisterActivity.this, "Authentication failed.",
                                Toast.LENGTH_SHORT).show();
                    }
                }
            });
        }

    }
    void handleRegister(){
        final String email = mEmailTxt.getText().toString();
        String password = mPwTxt.getText().toString();
        final String username = mUsernameTxt.getText().toString();
        if(!TextUtils.isEmpty(email) & !TextUtils.isEmpty(username) & !TextUtils.isEmpty(password)){
            mProgress.setTitle("Register...");
            mProgress.setCanceledOnTouchOutside(false);
            mProgress.show();

            mAuth.createUserWithEmailAndPassword(email, password).addOnCompleteListener(this, new OnCompleteListener<AuthResult>() {
                @Override
                public void onComplete(@NonNull Task<AuthResult> task) {
                    if (task.isSuccessful()){
                        FirebaseUser user = mAuth.getCurrentUser();
                        FirebaseDatabase database = FirebaseDatabase.getInstance();
                        DatabaseReference myRef = database.getReference("Users");
                        final HashMap<String, String> userMap = new HashMap<>();
                        userMap.put("username", username);
                        userMap.put("email", email);
                        userMap.put("type", "student");
                        userMap.put("profileImageUrl", "default");
                        userMap.put("id", user.getUid());
                        userMap.put("platform", "Android");
                        userMap.put("deviceToken", FirebaseInstanceId.getInstance().getToken());

                        myRef.child(user.getUid()).setValue(userMap).addOnCompleteListener(new OnCompleteListener<Void>() {
                            @Override
                            public void onComplete(@NonNull Task<Void> task) {
                                if (task.isSuccessful()){

                                    mApplication.setUser(new User(userMap));
                                    User user = mApplication.getUser();
                                    SharedPreferences settings = getSharedPreferences("UserInfo", 0);
                                    SharedPreferences.Editor editor = settings.edit();
                                    editor.putString("Username", user.getUsername());
                                    editor.putString("Email", user.getEmail());
                                    editor.putString("ProfileImageUrl", user.getProfileImageUrl());
                                    editor.putString("Type", user.getType());
                                    editor.commit();

                                    Intent mainIntent = new Intent(LoginRegisterActivity.this, MainActivity.class);
                                    mProgress.dismiss();

                                    startActivity(mainIntent);
                                    finish();
                                }else{
                                    mProgress.hide();
                                    Toast.makeText(LoginRegisterActivity.this, "Authentication failed.",
                                            Toast.LENGTH_SHORT).show();
                                }
                            }
                        });
                    }else{
                        mProgress.hide();
                        Toast.makeText(LoginRegisterActivity.this, "Authentication failed.",
                                Toast.LENGTH_SHORT).show();
                    }
                }
            });
        }
    }

    public void hideKeyboard(View view){
        InputMethodManager inputMethodManager = (InputMethodManager)getSystemService(Activity.INPUT_METHOD_SERVICE);
        inputMethodManager.hideSoftInputFromWindow(view.getWindowToken(), 0);
    }
}
