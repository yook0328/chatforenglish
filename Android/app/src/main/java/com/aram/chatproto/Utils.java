package com.aram.chatproto;

import android.content.Context;

/**
 * Created by Aram on 2018. 1. 7..
 */

public class Utils {
    public static float dpFromPx(final Context context, final float px) {
        return px / context.getResources().getDisplayMetrics().density;
    }

    public static float pxFromDp(final Context context, final float dp) {
        return dp * context.getResources().getDisplayMetrics().density;
    }
}
