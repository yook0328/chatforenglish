package com.aram.chatproto;


import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.google.firebase.auth.FirebaseAuth;


/**
 * A simple {@link Fragment} subclass.
 */
public class SettingFragment extends Fragment {

    View mFragmentView;
    TextView mEmailTxt;
    TextView mSignout;

    public SettingFragment() {
        // Required empty public constructor
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        mFragmentView = inflater.inflate(R.layout.fragment_setting, container, false);

        mEmailTxt = (TextView)mFragmentView.findViewById(R.id.email);
        mSignout = (TextView)mFragmentView.findViewById(R.id.logout_btn);

        mEmailTxt.setText(FirebaseAuth.getInstance().getCurrentUser().getEmail());

        mSignout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                FirebaseAuth.getInstance().signOut();

                Intent intent = new Intent(mFragmentView.getContext(), LoginRegisterActivity.class);

                startActivity(intent);
            }
        });


        return mFragmentView;
    }

}
