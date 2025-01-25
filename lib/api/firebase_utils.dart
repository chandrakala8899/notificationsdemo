import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;


class FirebaseUtils {
  static Future<String> getAccessToken() async{
    final serviceAccountJson = {
  "type": "service_account",
  "project_id": "pushnotifications-57afa",
  "private_key_id": "868a0a71d095f7d4f1d0feded8053ff4e3309bb7",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDNVFgoqnjuhtii\nNGm375+n+yyl7gE4WZEnRuhp/Im/X1lhkfRibT7+DFpj/aEXshLUWcgJ/eYVasRE\n05GESg7sXzm0uUH6Y0NYCNRlaO+ACwIZ2H4muHsl5VyH38FSgNPHERe74paWJg28\nLGI3Wk19TdUSLO3oPRQhq2t8Qd+jCnPXHWtpRvHNB4rN1FLcH230Vwz+XBvQsK18\n7M7GVtjgzYobZ5zpi2AkW2CLukzwlN7Jg+Qm09lQZfoLZnR4nY5nsZ5d7SgYelkO\nfgj/ShV/weoZOz76TI/sx8HPMyc11uhn6TyXNiLc3G7B9Qvv0/9olfRxZgangzVG\nZ5E86AotAgMBAAECggEAMuTMWj4Q7gyR/ziPGLamI/Cz2ygQeNtoiWv/uR+NtBfp\n82+GO+xYsAc3U2//ITy0ApsDZIigol/dqLKpL7lclBWxW7yMoEfA3j4ICV/Wd24j\nFe1trWLOMXE1u38Ib877Ty0LLTiney2Q+3qj2JUDPoMPhGsLCCS1i/ftkzXPvR0t\nEVpUtyw/gdmfZY08XYq/R2KGcPx+wuNQCb7ci5RxW+nAuWPI/1afoCVqs0ZG3ITz\nENugGp20Yv1FkBYh0h8sbnDC8oCmclKZKcbw8Of3dEq6qMwcY2JS4zYBkcl2eoix\ncVe8LDd6dTHYjaZPeA5/J2c+VCnEU6tJX4EUUDgcKQKBgQDx+0CoKD5YIJKNFUIM\nBtvdaBRfAaf62Nd80Ov8jLVfLkboZ0NnOHys1/AXWyuug2gQWYx7g2v5iJS+F/wo\naQUbt09oy5GhdRtLMFvtlS73jt9v0lX2hU73t9h4qee9eDzn+vor9ILJoGDSQQQQ\n0A5vMgCtXTQyPK/FD6HsDspVJQKBgQDZOYSsoZ6mmkvQ0tYZQqPyuh2Xsv1sBTMM\nLhZF53YZOXHKpfo+gdANpZ/ns+uN0Lfs4DO4fMxWI3zFTupQ+U7NqpXGnwfPCZIJ\nP4tlc2G9trrBvNS5jvp+WVUwimULpige2TjPmuSyS0Gn9foVhvUD/Ml8JnRRpIX4\n5A43YCdGaQKBgDnW9ah8HhLQjlccurHHPeyZQS1IZw+Fn1RdV9sBAyViGV7Zt/nH\nPb3Oy7u5diJ7lHc8AGFRk5CMvgkGEKbUG315foitB/1Q0ZpST9blLtnLk8rVuuh3\nCt4ZWqvU6OiYAe7tRbkV8+Ef7aS0F7WxFZIsoI7P1XcgnF79EpYrHt/lAoGBAJi+\nZDeLceaOio8tIdUjUetEybg46RAC2/FNmuXOqvFzvjsT2NIJL8XY14byscjHof0T\nberk/j33uC15nzQPCkV+FNFUVAZWIXUVVKyipHDlQ48le6N7EVK0+D0oo4K8dGu0\nrMj2jqd8WY+EXDS08Ca8ouUEmTgravUnT4PKvfM5AoGAV99hWBujlP//lzI7R3FE\nEIfOVQiUaAupa/qpHq81iiU6RMTsFEMj3rLoHgvhKRKJhFzqKXPPDk5WGUjN8gY3\nDYqbQNwVTleWGGZllxVphEYiduWE0CgmjNArI8BrgFo4yts3wbx7oT+BT3QKoKbW\njlZQmdIKBb6+HOlM1bs+9VU=\n-----END PRIVATE KEY-----\n",
  "client_email": "firebase-adminsdk-1w3dn@pushnotifications-57afa.iam.gserviceaccount.com",
  "client_id": "103900683721719145943",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-1w3dn%40pushnotifications-57afa.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
};

List<String> scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
];

http.Client client = await auth.clientViaServiceAccount(
  auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
  scopes,
); 

auth.AccessCredentials credentials = await auth.obtainAccessCredentialsViaServiceAccount(
   auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
   scopes,
   client
);

client.close();
return credentials.accessToken.data;
  }
}