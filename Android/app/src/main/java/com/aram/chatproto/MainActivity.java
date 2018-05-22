package com.aram.chatproto;

import android.content.Intent;
import android.graphics.PorterDuff;
import android.os.Bundle;
import android.support.design.widget.TabLayout;
import android.support.v4.content.ContextCompat;
import android.support.v4.view.ViewPager;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;

import com.google.firebase.auth.FirebaseAuth;

public class MainActivity extends AppCompatActivity {

    private Toolbar mToolbar;
    private ViewPager mViewPager;
    private TabLayout mTabLayout;
    private MyApplication mApplication;
    private MainTapPager mTabPager;
//    private

    @Override
    public void onBackPressed() {
        //super.onBackPressed();
        finishAndRemoveTask();
    }

    @Override
    protected void onResume() {
        super.onResume();

        if(FirebaseAuth.getInstance().getCurrentUser() == null){
            Intent intent = new Intent(this, LoginRegisterActivity.class);
            startActivity(intent);
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        if(FirebaseAuth.getInstance().getCurrentUser() == null){
            Intent intent = new Intent(this, LoginRegisterActivity.class);
            startActivity(intent);
        }

        mToolbar = (Toolbar ) findViewById(R.id.main_page_appbar);
        setSupportActionBar(mToolbar);
        getSupportActionBar().setTitle("");

        mTabLayout = (TabLayout)findViewById(R.id.main_tab);



        for(int i = 0; i < mTabLayout.getTabCount(); i++){
            if(i == 0 ){
                int tabIconColor = ContextCompat.getColor(MainActivity.this, R.color.tab_icon_selected);
                mTabLayout.getTabAt(i).getIcon().setColorFilter(tabIconColor, PorterDuff.Mode.SRC_IN);
            }else{
                int tabIconColor = ContextCompat.getColor(MainActivity.this, R.color.tab_icon_color);
                mTabLayout.getTabAt(i).getIcon().setColorFilter(tabIconColor, PorterDuff.Mode.SRC_IN);
            }
        }

        //Add fragments
        mTabPager = new MainTapPager(getSupportFragmentManager());

        ListFragment listFragment = new ListFragment();
        listFragment.setParentActivity(MainActivity.this);

        ChatFragment chatFragment = new ChatFragment();
        chatFragment.setParentActivity(MainActivity.this);

        mTabPager.addFragment(listFragment);
        mTabPager.addFragment(chatFragment);
        mTabPager.addFragment(new SettingFragment());


        mViewPager = (ViewPager)findViewById(R.id.main_tab_pager);

        //Setting adapter
        mViewPager.setAdapter(mTabPager);
        mTabLayout.setupWithViewPager(mViewPager);



        mTabLayout.setupWithViewPager(mViewPager);
        mTabLayout.getTabAt(0).setIcon(R.drawable.tab_icon_list);
        mTabLayout.getTabAt(1).setIcon(R.drawable.tab_icon_chat);
        mTabLayout.getTabAt(2).setIcon(R.drawable.tab_icon_setting);


        mApplication = (MyApplication)getApplication();



        mApplication.observeRooms();

    }
}
