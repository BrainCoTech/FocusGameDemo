package wendu.jsbdemo;

import android.os.CountDownTimer;
import android.webkit.JavascriptInterface;

import org.json.JSONException;
import org.json.JSONObject;

import wendu.dsbridge.CompletionHandler;

/**
 * Created by du on 16/12/31.
 */

public class JsApi {
    @JavascriptInterface
    public void getUserInfo(Object args, CompletionHandler<Object> handler) throws JSONException {
        String name = "Test_001";
        String avatar = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1594895469817&di=72061eb0f251672b08300559c17a6737&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201802%2F27%2F20180227232444_omtjy.jpeg";
        JSONObject ret = new JSONObject();
        ret.put("name", name);
        ret.put("avatar", avatar);
        ret.put("token", "tokenXXXX");
        handler.complete(ret);
    }

    @JavascriptInterface
    public void getGameInfo(Object args, CompletionHandler<Object> handler) throws JSONException {
        Integer lvFrom = 10;
        Integer lvTo = 100;
        Integer duration = 1500;
        JSONObject ret = new JSONObject();
        ret.put("lvFrom", lvFrom);
        ret.put("lvTo", lvTo);
        ret.put("duration", duration);
        handler.complete(ret);
    }

    @JavascriptInterface
    public void getUserAttention(Object args, final CompletionHandler<Double> handler) {
        handler.setProgressData(100.0);
//        new CountDownTimer(360000, 1000) {
//            int i = 10;
//            @Override
//            public void onTick(long millisUntilFinished) {
//                //setProgressData can be called many times util complete be called.
//                handler.setProgressData(1+Math.random()*(100-1+1));
//
//            }
//            @Override
//            public void onFinish() {
//                //complete the js invocation with data; handler will be invalid when complete is called
//                handler.complete(0.0);
//
//            }
//        }.start();
    }

    @JavascriptInterface
    public String onStart(Object arg) {
        return "onStart, call" ;
    }

    @JavascriptInterface
    public String onFinish(Object arg) throws JSONException {
        JSONObject jsonObject= (JSONObject) arg;
        return "onFinish, " + jsonObject.toString();
    }
}