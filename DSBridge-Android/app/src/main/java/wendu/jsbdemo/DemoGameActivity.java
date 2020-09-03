package wendu.jsbdemo;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.widget.Toast;

import wendu.dsbridge.DWebView;
import wendu.dsbridge.OnReturnValue;

public class DemoGameActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_h5_call_native);

        final DWebView dwebView = (DWebView) findViewById(R.id.webview);
        DWebView.setWebContentsDebuggingEnabled(true);
        dwebView.addJavascriptObject(new JsApi(), null);
//        dwebView.loadUrl("http://cdn.7tiao.net/zzgame/game1/");
//        dwebView.loadUrl("http://cdn.7tiao.net/zzgame/game1/index2.php");
        dwebView.loadUrl("http://hwlgame.online/expressman/index.html");
    }

    void showToast(Object o) {
        Toast.makeText(this, o.toString(), Toast.LENGTH_SHORT).show();
    }

    void setMuted(boolean muted) {
        final DWebView dWebView = (DWebView) findViewById(R.id.webview);
        dWebView.callHandler("setMuted", new Object[]{true}, new OnReturnValue<Integer>() {
            @Override
            public void onValue(Integer retValue) {
                showToast(retValue);
            }
        });
    }

    void syncResume() {
        final DWebView dWebView = (DWebView) findViewById(R.id.webview);
        dWebView.callHandler("syncResume", new OnReturnValue<Boolean>() {
            @Override
            public void onValue(Boolean retValue) {
                showToast(retValue);
            }
        });
    }

    void syncPause() {
        final DWebView dWebView = (DWebView) findViewById(R.id.webview);
        dWebView.callHandler("syncPause", new OnReturnValue<Boolean>() {
            @Override
            public void onValue(Boolean retValue) {
              showToast(retValue);
            }
        });
    }
}